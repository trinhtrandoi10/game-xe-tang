import 'dart:async';
import 'dart:math' as math;

import '../../core/math/game_vector.dart';
import '../domain/ai/ai.dart';
import '../domain/combat/combat.dart';
import '../domain/mission/mission.dart';
import '../domain/save/save_game.dart';
import '../domain/vehicle/vehicle.dart';
import 'snapshots/game_snapshot.dart';

typedef GameSessionListener = void Function();

class PlayerCommand {
  const PlayerCommand({this.throttle = 0, this.steering = 0, this.turret = 0});

  final double throttle;
  final double steering;
  final double turret;

  PlayerCommand copyWith({double? throttle, double? steering, double? turret}) {
    return PlayerCommand(
      throttle: throttle ?? this.throttle,
      steering: steering ?? this.steering,
      turret: turret ?? this.turret,
    );
  }
}

class GameSession {
  GameSession(this.profile) {
    _buildWorld(fromProfile: true);
  }

  static const double worldHalfSize = 480;
  static const townPosition = GameVector(-10, -10);
  static const radarPosition = GameVector(290, 0);
  static const radarRadius = 70.0;

  final GameProfile profile;
  final _random = math.Random(99);
  final List<GameSessionListener> _listeners = <GameSessionListener>[];
  final List<EnemyUnit> _enemies = <EnemyUnit>[];
  final List<_Projectile> _projectiles = <_Projectile>[];
  final List<_Effect> _effects = <_Effect>[];
  final WeaponState weapon = WeaponState();

  late TankState player;
  late MissionRuntime mission;
  GamePhase phase = GamePhase.active;
  PlayerCommand _command = const PlayerCommand();
  Timer? _timer;
  String? _lockedTargetId;
  String? _eventMessage;
  double _eventMessageTimer = 0;
  double _saveTimer = 0;
  double _fixedAccumulator = 0;
  bool _fireRequested = false;
  bool _saveRequested = true;
  int _shotCounter = 0;

  void addListener(GameSessionListener listener) => _listeners.add(listener);

  void removeListener(GameSessionListener listener) =>
      _listeners.remove(listener);

  void start() {
    _timer ??= Timer.periodic(const Duration(milliseconds: 16), (_) {
      tick(1 / 60);
    });
    _notify();
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _listeners.clear();
  }

  void tick(double elapsedSeconds) {
    _fixedAccumulator += elapsedSeconds.clamp(0, 0.1);
    var steps = 0;
    while (_fixedAccumulator >= 1 / 60 && steps < 3) {
      _fixedAccumulator -= 1 / 60;
      _step(1 / 60);
      steps++;
    }
    if (steps == 3) _fixedAccumulator = 0;
    _notify();
  }

  void setMovement({required double throttle, required double steering}) {
    _command = _command.copyWith(
      throttle: throttle.clamp(-1, 1).toDouble(),
      steering: steering.clamp(-1, 1).toDouble(),
    );
  }

  void setTurretInput(double value) {
    _command = _command.copyWith(turret: value.clamp(-1, 1).toDouble());
  }

  void aimBy(double radians) {
    if (phase != GamePhase.active) return;
    player.turretHeading = normalizeAngle(
      player.turretHeading + radians.clamp(-0.3, 0.3).toDouble(),
    );
    _notify();
  }

  void fire() => _fireRequested = true;

  void switchAmmo() {
    player.selectedAmmo = player.selectedAmmo == AmmoType.ap
        ? AmmoType.he
        : AmmoType.ap;
    _postMessage(player.selectedAmmo == AmmoType.ap ? 'AP READY' : 'HE READY');
    _notify();
  }

  void lockTarget() {
    final target = _findAimTarget();
    _lockedTargetId = target?.id;
    _postMessage(
      target == null
          ? 'NO TARGET'
          : 'TARGET LOCKED // ${target.id.toUpperCase()}',
    );
    _notify();
  }

  void repair() {
    if (phase != GamePhase.active) return;
    final kits = profile.inventory['field_repair_kit'] ?? 0;
    if (kits <= 0) {
      _postMessage('NO REPAIR KIT');
      return;
    }
    if (player.health >= player.config.maxHealth &&
        !player.engineDisabled &&
        !player.leftTrackDisabled &&
        !player.rightTrackDisabled) {
      _postMessage('HULL ALREADY NOMINAL');
      return;
    }
    profile.inventory['field_repair_kit'] = kits - 1;
    player.repair(player.config.maxHealth * 0.25);
    _postMessage('FIELD REPAIR COMPLETE');
    _saveRequested = true;
  }

  void pause() {
    if (phase == GamePhase.active) phase = GamePhase.paused;
    _notify();
  }

  void resume() {
    if (phase == GamePhase.paused) phase = GamePhase.active;
    _notify();
  }

  void restart() {
    profile.missionStage = MissionStage.reachTown.name;
    profile.captureProgress = 0;
    profile.defendRemaining = 45;
    profile.destroyedScouts = 0;
    _buildWorld(fromProfile: false);
    phase = GamePhase.active;
    start();
  }

  bool consumeSaveRequest() {
    final requested = _saveRequested;
    _saveRequested = false;
    return requested;
  }

  GameSnapshot get snapshot {
    return GameSnapshot(
      phase: phase,
      missionStage: mission.stage,
      playerPosition: player.position,
      playerHeading: player.heading,
      turretHeading: player.turretHeading,
      playerHealth: player.health,
      playerMaxHealth: player.config.maxHealth,
      apAmmo: player.apAmmo,
      heAmmo: player.heAmmo,
      selectedAmmo: player.selectedAmmo,
      reloadRemaining: weapon.reloadRemaining,
      reloadDuration: weapon.reloadDuration,
      leftTrackDisabled: player.leftTrackDisabled,
      rightTrackDisabled: player.rightTrackDisabled,
      engineDisabled: player.engineDisabled,
      enemies: List<EnemySnapshot>.unmodifiable(
        _enemies.map(
          (enemy) => EnemySnapshot(
            id: enemy.id,
            archetype: enemy.config.archetype,
            state: enemy.state,
            position: enemy.position,
            heading: enemy.heading,
            turretHeading: enemy.turretHeading,
            health: enemy.health,
            maxHealth: enemy.config.maxHealth,
          ),
        ),
      ),
      projectiles: List<ProjectileSnapshot>.unmodifiable(
        _projectiles.map(
          (projectile) => ProjectileSnapshot(
            position: projectile.position,
            previousPosition: projectile.previousPosition,
            fromPlayer: projectile.fromPlayer,
            ammo: projectile.ammo,
          ),
        ),
      ),
      effects: List<EffectSnapshot>.unmodifiable(
        _effects.map(
          (effect) => EffectSnapshot(
            position: effect.position,
            life: effect.life,
            colorSeed: effect.colorSeed,
          ),
        ),
      ),
      captureProgress: mission.captureProgress,
      defendRemaining: mission.defendRemaining,
      destroyedScouts: mission.destroyedScouts,
      objectiveProgress: mission.progress.clamp(0, 1).toDouble(),
      elapsed: mission.elapsed,
      targetPosition: _targetPosition,
      lockedTargetId: _lockedTargetId,
      eventMessage: _eventMessage,
      tutorialKey: _tutorialKey,
    );
  }

  GameVector get _targetPosition {
    if (mission.stage == MissionStage.reachTown) return townPosition;
    if (mission.stage == MissionStage.destroyScouts) {
      final target = _enemies
          .where((enemy) => enemy.isAlive && enemy.isScout)
          .firstOrNull;
      return target?.position ?? radarPosition;
    }
    return radarPosition;
  }

  String? get _tutorialKey {
    if (mission.stage == MissionStage.reachTown && mission.elapsed < 24) {
      return 'tutorialMove';
    }
    if (mission.stage == MissionStage.destroyScouts &&
        mission.destroyedScouts == 0) {
      return 'tutorialAim';
    }
    if (mission.stage == MissionStage.captureRadar) {
      return 'tutorialCapture';
    }
    return null;
  }

  void _buildWorld({required bool fromProfile}) {
    mission = MissionRuntime();
    if (fromProfile) {
      mission.restoreFromProfile(
        stageCode: profile.missionStage,
        captureProgress: profile.captureProgress,
        defendRemaining: profile.defendRemaining,
        destroyedScouts: profile.destroyedScouts,
        rewardClaimed: profile.rewardClaimed,
      );
      if (mission.stage == MissionStage.complete ||
          mission.stage == MissionStage.failed) {
        final rewardWasClaimed = mission.rewardClaimed;
        mission = MissionRuntime()..rewardClaimed = rewardWasClaimed;
        profile.missionStage = mission.stage.name;
        profile.captureProgress = 0;
        profile.defendRemaining = 45;
        profile.destroyedScouts = 0;
      }
    }

    final startPosition = switch (mission.stage) {
      MissionStage.reachTown => const GameVector(-350, 250),
      MissionStage.destroyScouts => townPosition,
      MissionStage.captureRadar ||
      MissionStage.defendRadar => const GameVector(220, 0),
      MissionStage.complete ||
      MissionStage.failed => const GameVector(-350, 250),
    };
    player = TankState(config: t99StormConfig, position: startPosition);
    player.turretHeading = headingTo(player.position, radarPosition);
    player.apAmmo += (profile.inventory['ap_crate'] ?? 0).clamp(0, 2) * 4;
    player.heAmmo += (profile.inventory['he_crate'] ?? 0).clamp(0, 2) * 4;
    _enemies
      ..clear()
      ..addAll(<EnemyUnit>[
        EnemyUnit(
          id: 'scout_01',
          config: scoutConfig,
          position: const GameVector(-35, -55),
          heading: 0.8,
        ),
        EnemyUnit(
          id: 'scout_02',
          config: scoutConfig,
          position: const GameVector(70, 35),
          heading: -0.7,
        ),
        EnemyUnit(
          id: 'medium_01',
          config: mediumConfig,
          position: const GameVector(285, 105),
          heading: math.pi,
        ),
      ]);
    var alreadyDestroyed = mission.destroyedScouts;
    for (final enemy in _enemies.where((candidate) => candidate.isScout)) {
      if (alreadyDestroyed <= 0) break;
      enemy.health = 0;
      enemy.state = AiState.destroyed;
      alreadyDestroyed--;
    }
    player.heading = _headingToCurrentObjective();
    _projectiles.clear();
    _effects.clear();
    _lockedTargetId = null;
    _eventMessage = null;
    _eventMessageTimer = 0;
    _saveTimer = 0;
    _fixedAccumulator = 0;
    _fireRequested = false;
    _saveRequested = true;
  }

  double _headingToCurrentObjective() {
    final target = switch (mission.stage) {
      MissionStage.reachTown => townPosition,
      MissionStage.destroyScouts =>
        _enemies
                .where((enemy) => enemy.isAlive && enemy.isScout)
                .firstOrNull
                ?.position ??
            townPosition,
      MissionStage.captureRadar || MissionStage.defendRadar => radarPosition,
      MissionStage.complete || MissionStage.failed => player.position,
    };
    return headingTo(player.position, target);
  }

  void _step(double dt) {
    if (phase != GamePhase.active) return;
    mission.elapsed += dt;
    _saveTimer += dt;
    if (_saveTimer >= 8) {
      _saveTimer = 0;
      _saveRequested = true;
      _copyMissionToProfile();
    }
    if (_eventMessageTimer > 0) {
      _eventMessageTimer -= dt;
      if (_eventMessageTimer <= 0) _eventMessage = null;
    }

    weapon.tick(dt);
    _updatePlayer(dt);
    _updateEnemies(dt);
    _updateProjectiles(dt);
    _updateEffects(dt);
    _updateMission(dt);
    if (player.isDestroyed && phase == GamePhase.active) {
      mission.stage = MissionStage.failed;
      profile.missionStage = mission.stage.name;
      phase = GamePhase.failed;
      _postMessage('T-99 DESTROYED');
      _saveRequested = true;
    }
  }

  void _updatePlayer(double dt) {
    final throttle = _command.throttle;
    final steering = _command.steering;
    final trackFactor = player.leftTrackDisabled || player.rightTrackDisabled
        ? 0.35
        : 1.0;
    final engineFactor = player.engineDisabled ? 0.45 : 1.0;
    final targetSpeed =
        (throttle >= 0
            ? player.config.maxSpeed * throttle
            : player.config.reverseSpeed * throttle) *
        trackFactor *
        engineFactor;
    player.speed = moveTowards(
      player.speed,
      targetSpeed,
      player.config.acceleration * dt,
    );
    final turnFactor = (throttle.abs() + 0.15).clamp(0.15, 1.0);
    player.heading = normalizeAngle(
      player.heading + steering * player.config.hullTurnRate * turnFactor * dt,
    );
    player.turretHeading = normalizeAngle(
      player.turretHeading +
          _command.turret * player.config.turretTurnRate * dt,
    );
    player.position =
        (player.position +
                GameVector.fromHeading(player.heading) * player.speed * dt)
            .clamp(
              -worldHalfSize,
              worldHalfSize,
              -worldHalfSize,
              worldHalfSize,
            );

    if (_fireRequested) {
      _fireRequested = false;
      _tryFire();
    }
  }

  void _tryFire() {
    if (!weapon.isReady) return;
    final ammo = player.selectedAmmo;
    if (player.ammoFor(ammo) <= 0) {
      _postMessage('NO ${ammo == AmmoType.ap ? 'AP' : 'HE'} AMMO');
      return;
    }
    if (ammo == AmmoType.ap) {
      player.apAmmo--;
    } else {
      player.heAmmo--;
    }
    final direction = GameVector.fromHeading(player.turretHeading);
    final origin = player.position + direction * 16;
    _projectiles.add(
      _Projectile(
        position: origin,
        previousPosition: origin,
        velocity: direction * profileForAmmo(ammo).projectileSpeed,
        fromPlayer: true,
        ammo: ammo,
        life: 3.5,
      ),
    );
    _effects.add(
      _Effect(position: origin, life: 0.35, colorSeed: _shotCounter++),
    );
    weapon.beginReload();
  }

  void _updateEnemies(double dt) {
    for (final enemy in _enemies) {
      if (!enemy.isAlive) continue;
      enemy.fireCooldown -= dt;
      final distance = enemy.position.distanceTo(player.position);
      if (enemy.state == AiState.disabled) {
        enemy.stateTimer -= dt;
        if (enemy.stateTimer <= 0) enemy.state = AiState.aim;
        continue;
      }
      if (distance > enemy.config.detectionRange) {
        enemy.state = AiState.patrol;
        enemy.stateTimer += dt;
        final patrolHeading =
            math.sin(enemy.stateTimer * 0.35 + enemy.id.length) * 0.2;
        enemy.heading = normalizeAngle(enemy.heading + patrolHeading * dt);
        enemy.position =
            (enemy.position +
                    GameVector.fromHeading(enemy.heading) *
                        enemy.config.maxSpeed *
                        0.15 *
                        dt)
                .clamp(
                  -worldHalfSize,
                  worldHalfSize,
                  -worldHalfSize,
                  worldHalfSize,
                );
        continue;
      }

      enemy.state = AiState.acquireTarget;
      final desiredHeading = headingTo(enemy.position, player.position);
      enemy.turretHeading = _rotateTowards(
        enemy.turretHeading,
        desiredHeading,
        1.6 * dt,
      );
      if (enemy.isScout && distance > 115) {
        enemy.state = AiState.flank;
        enemy.heading = _rotateTowards(
          enemy.heading,
          desiredHeading + 0.6,
          1.8 * dt,
        );
        enemy.position =
            (enemy.position +
                    GameVector.fromHeading(enemy.heading) *
                        enemy.config.maxSpeed *
                        dt)
                .clamp(
                  -worldHalfSize,
                  worldHalfSize,
                  -worldHalfSize,
                  worldHalfSize,
                );
      } else if (!enemy.isScout && distance < 170) {
        enemy.state = AiState.reposition;
        enemy.heading = _rotateTowards(
          enemy.heading,
          desiredHeading + math.pi,
          1.0 * dt,
        );
        enemy.position =
            (enemy.position +
                    GameVector.fromHeading(enemy.heading) *
                        enemy.config.maxSpeed *
                        0.55 *
                        dt)
                .clamp(
                  -worldHalfSize,
                  worldHalfSize,
                  -worldHalfSize,
                  worldHalfSize,
                );
      } else {
        enemy.state = AiState.aim;
      }

      if (enemy.fireCooldown <= 0 &&
          distance < enemy.config.detectionRange * 0.9) {
        enemy.state = AiState.fire;
        _projectiles.add(
          _Projectile(
            position:
                enemy.position +
                GameVector.fromHeading(enemy.turretHeading) * 12,
            previousPosition: enemy.position,
            velocity:
                GameVector.fromHeading(enemy.turretHeading) *
                (enemy.isScout ? 125 : 150),
            fromPlayer: false,
            ammo: enemy.isScout ? AmmoType.he : AmmoType.ap,
            life: 3.2,
            damageOverride: enemy.config.weaponDamage,
          ),
        );
        enemy.fireCooldown =
            enemy.config.fireCooldown + _random.nextDouble() * 1.4;
      }
    }
  }

  void _updateProjectiles(double dt) {
    final expired = <_Projectile>[];
    for (final projectile in _projectiles) {
      projectile.previousPosition = projectile.position;
      projectile.position += projectile.velocity * dt;
      projectile.life -= dt;
      var hit = false;
      if (projectile.fromPlayer) {
        EnemyUnit? target;
        var closest = double.infinity;
        for (final enemy in _enemies.where((candidate) => candidate.isAlive)) {
          final radius = enemy.isScout ? 14.0 : 19.0;
          final distance = distanceToSegment(
            enemy.position,
            projectile.previousPosition,
            projectile.position,
          );
          if (distance <= radius &&
              projectile.previousPosition.distanceTo(enemy.position) <
                  closest) {
            closest = projectile.previousPosition.distanceTo(enemy.position);
            target = enemy;
          }
        }
        if (target != null) {
          hit = true;
          _resolveEnemyHit(target, projectile);
        }
      } else if (distanceToSegment(
            player.position,
            projectile.previousPosition,
            projectile.position,
          ) <=
          18) {
        hit = true;
        final damage =
            projectile.damageOverride ??
            profileForAmmo(projectile.ammo).damage * 0.28;
        player.applyHullDamage(damage);
        _effects.add(
          _Effect(position: player.position, life: 0.55, colorSeed: 5),
        );
        _postMessage('INCOMING HIT // -${damage.round()}');
      }
      if (hit ||
          projectile.life <= 0 ||
          projectile.position.length > worldHalfSize * 1.8) {
        expired.add(projectile);
      }
    }
    _projectiles.removeWhere(expired.contains);
  }

  void _resolveEnemyHit(EnemyUnit enemy, _Projectile projectile) {
    final ammo = profileForAmmo(projectile.ammo);
    final zone = _classifyArmorZone(enemy.heading, projectile.velocity);
    final result = DamageResolver.resolve(
      ammo: ammo,
      armor: ArmorProfile(
        front: enemy.config.armor * 1.35,
        side: enemy.config.armor,
        rear: enemy.config.armor * 0.62,
        top: enemy.config.armor * 0.45,
      ),
      zone: zone,
      impactAngleDegrees: _impactAngle(enemy.heading, projectile.velocity),
      moduleRoll: _random.nextDouble(),
    );
    enemy.applyDamage(result.damage);
    if (result.module == DamageModule.leftTrack) {
      enemy.leftTrackDisabled = true;
    }
    if (result.module == DamageModule.rightTrack) {
      enemy.rightTrackDisabled = true;
    }
    if (result.module == DamageModule.engine) {
      enemy.state = AiState.disabled;
      enemy.stateTimer = 3.5;
    }
    _effects.add(
      _Effect(
        position: enemy.position,
        life: result.penetrated ? 0.75 : 0.45,
        colorSeed: result.penetrated ? 2 : 3,
      ),
    );
    if (!result.penetrated) {
      _postMessage('RICOCHET // ${zone.name.toUpperCase()}');
    } else {
      _postMessage('${enemy.id.toUpperCase()} // -${result.damage.round()}');
      if (!enemy.isAlive) {
        if (enemy.isScout) mission.destroyedScouts++;
        _postMessage('${enemy.id.toUpperCase()} DESTROYED');
        _saveRequested = true;
      }
      if (ammo.splashRadius > 0) {
        for (final splashTarget in _enemies.where(
          (candidate) => candidate.isAlive && candidate != enemy,
        )) {
          if (splashTarget.position.distanceTo(enemy.position) <=
              ammo.splashRadius) {
            splashTarget.applyDamage(ammo.damage * 0.26);
          }
        }
      }
    }
  }

  void _updateMission(double dt) {
    final distanceToTown = player.position.distanceTo(townPosition);
    final distanceToRadar = player.position.distanceTo(radarPosition);
    switch (mission.stage) {
      case MissionStage.reachTown:
        if (distanceToTown <= 54) {
          mission.stage = MissionStage.destroyScouts;
          _postMessage('CONTACT // ARES SCOUTS');
          _copyMissionToProfile();
          _saveRequested = true;
        }
      case MissionStage.destroyScouts:
        if (mission.destroyedScouts >= 2) {
          mission.stage = MissionStage.captureRadar;
          _postMessage('ROUTE OPEN // RADAR NAM-1');
          _copyMissionToProfile();
          _saveRequested = true;
        }
      case MissionStage.captureRadar:
        if (distanceToRadar <= radarRadius) {
          final enemyPressure = _enemies.any(
            (enemy) =>
                enemy.isAlive && enemy.position.distanceTo(radarPosition) < 95,
          );
          mission.captureProgress =
              (mission.captureProgress + dt * (enemyPressure ? 0.035 : 0.12))
                  .clamp(0, 1)
                  .toDouble();
          if (mission.captureProgress >= 1) {
            mission.stage = MissionStage.defendRadar;
            mission.defendRemaining = 45;
            _spawnDefenders();
            _postMessage('RADAR CAPTURED // INCOMING WAVE');
            _copyMissionToProfile();
            _saveRequested = true;
          }
        } else {
          mission.captureProgress = (mission.captureProgress - dt * 0.025)
              .clamp(0, 1)
              .toDouble();
        }
      case MissionStage.defendRadar:
        if (distanceToRadar <= radarRadius + 18) {
          mission.defendRemaining = (mission.defendRemaining - dt)
              .clamp(0, 45)
              .toDouble();
          if (mission.defendRemaining <= 0) _completeMission();
        }
      case MissionStage.complete:
      case MissionStage.failed:
        break;
    }
  }

  void _spawnDefenders() {
    if (_enemies.any((enemy) => enemy.id == 'reinforcement_01')) return;
    _enemies.addAll(<EnemyUnit>[
      EnemyUnit(
        id: 'reinforcement_01',
        config: mediumConfig,
        position: const GameVector(410, -120),
        heading: math.pi,
      ),
      EnemyUnit(
        id: 'reinforcement_02',
        config: scoutConfig,
        position: const GameVector(420, 95),
        heading: math.pi,
      ),
    ]);
  }

  void _completeMission() {
    if (phase != GamePhase.active) return;
    mission.stage = MissionStage.complete;
    if (!mission.rewardClaimed) {
      mission.rewardClaimed = true;
      profile.parts += 420;
    }
    _copyMissionToProfile();
    phase = GamePhase.completed;
    _postMessage('MISSION COMPLETE // +420 PARTS');
    _saveRequested = true;
  }

  void _copyMissionToProfile() {
    profile.missionStage = mission.stage.name;
    profile.captureProgress = mission.captureProgress;
    profile.defendRemaining = mission.defendRemaining;
    profile.destroyedScouts = mission.destroyedScouts;
    profile.rewardClaimed = mission.rewardClaimed;
  }

  EnemyUnit? _findAimTarget() {
    EnemyUnit? best;
    var bestScore = double.infinity;
    for (final enemy in _enemies.where((candidate) => candidate.isAlive)) {
      final distance = enemy.position.distanceTo(player.position);
      final angle = normalizeAngle(
        headingTo(player.position, enemy.position) - player.turretHeading,
      ).abs();
      if (angle < 0.55 && distance < 430) {
        final score = distance + angle * 180;
        if (score < bestScore) {
          best = enemy;
          bestScore = score;
        }
      }
    }
    return best;
  }

  ArmorZone _classifyArmorZone(double targetHeading, GameVector shotDirection) {
    final relative = normalizeAngle(
      math.atan2(shotDirection.x, shotDirection.z) - targetHeading,
    ).abs();
    if (relative < math.pi / 4) return ArmorZone.front;
    if (relative < math.pi * 0.75) return ArmorZone.side;
    return ArmorZone.rear;
  }

  double _impactAngle(double targetHeading, GameVector shotDirection) {
    return normalizeAngle(
          math.atan2(shotDirection.x, shotDirection.z) - targetHeading,
        ).abs() *
        180 /
        math.pi;
  }

  double _rotateTowards(double current, double target, double maxDelta) {
    final delta = normalizeAngle(target - current);
    return normalizeAngle(
      current + delta.clamp(-maxDelta, maxDelta).toDouble(),
    );
  }

  void _updateEffects(double dt) {
    for (final effect in _effects) {
      effect.life -= dt;
    }
    _effects.removeWhere((effect) => effect.life <= 0);
  }

  void _postMessage(String message) {
    _eventMessage = message;
    _eventMessageTimer = 2.4;
  }

  void _notify() {
    for (final listener in List<GameSessionListener>.of(_listeners)) {
      listener();
    }
  }
}

class _Projectile {
  _Projectile({
    required this.position,
    required this.previousPosition,
    required this.velocity,
    required this.fromPlayer,
    required this.ammo,
    required this.life,
    this.damageOverride,
  });

  GameVector position;
  GameVector previousPosition;
  final GameVector velocity;
  final bool fromPlayer;
  final AmmoType ammo;
  double life;
  final double? damageOverride;
}

class _Effect {
  _Effect({
    required this.position,
    required this.life,
    required this.colorSeed,
  });

  final GameVector position;
  double life;
  final int colorSeed;
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
