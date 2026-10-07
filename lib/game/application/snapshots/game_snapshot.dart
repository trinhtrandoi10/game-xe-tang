import '../../../core/math/game_vector.dart';
import '../../domain/ai/ai.dart';
import '../../domain/combat/combat.dart';
import '../../domain/mission/mission.dart';

enum GamePhase { active, paused, completed, failed }

class EnemySnapshot {
  const EnemySnapshot({
    required this.id,
    required this.archetype,
    required this.state,
    required this.position,
    required this.heading,
    required this.turretHeading,
    required this.health,
    required this.maxHealth,
  });

  final String id;
  final EnemyArchetype archetype;
  final AiState state;
  final GameVector position;
  final double heading;
  final double turretHeading;
  final double health;
  final double maxHealth;

  bool get isDestroyed => state == AiState.destroyed;
}

class ProjectileSnapshot {
  const ProjectileSnapshot({
    required this.position,
    required this.previousPosition,
    required this.fromPlayer,
    required this.ammo,
  });

  final GameVector position;
  final GameVector previousPosition;
  final bool fromPlayer;
  final AmmoType ammo;
}

class EffectSnapshot {
  const EffectSnapshot(
      {required this.position, required this.life, required this.colorSeed});

  final GameVector position;
  final double life;
  final int colorSeed;
}

class GameSnapshot {
  const GameSnapshot({
    required this.phase,
    required this.missionStage,
    required this.playerPosition,
    required this.playerHeading,
    required this.turretHeading,
    required this.playerHealth,
    required this.playerMaxHealth,
    required this.apAmmo,
    required this.heAmmo,
    required this.selectedAmmo,
    required this.reloadRemaining,
    required this.reloadDuration,
    required this.leftTrackDisabled,
    required this.rightTrackDisabled,
    required this.engineDisabled,
    required this.enemies,
    required this.projectiles,
    required this.effects,
    required this.captureProgress,
    required this.defendRemaining,
    required this.destroyedScouts,
    required this.objectiveProgress,
    required this.elapsed,
    required this.targetPosition,
    required this.lockedTargetId,
    required this.eventMessage,
    required this.tutorialKey,
  });

  final GamePhase phase;
  final MissionStage missionStage;
  final GameVector playerPosition;
  final double playerHeading;
  final double turretHeading;
  final double playerHealth;
  final double playerMaxHealth;
  final int apAmmo;
  final int heAmmo;
  final AmmoType selectedAmmo;
  final double reloadRemaining;
  final double reloadDuration;
  final bool leftTrackDisabled;
  final bool rightTrackDisabled;
  final bool engineDisabled;
  final List<EnemySnapshot> enemies;
  final List<ProjectileSnapshot> projectiles;
  final List<EffectSnapshot> effects;
  final double captureProgress;
  final double defendRemaining;
  final int destroyedScouts;
  final double objectiveProgress;
  final double elapsed;
  final GameVector targetPosition;
  final String? lockedTargetId;
  final String? eventMessage;
  final String? tutorialKey;

  int get aliveEnemies => enemies.where((enemy) => !enemy.isDestroyed).length;

  int get ammo => selectedAmmo == AmmoType.ap ? apAmmo : heAmmo;
}
