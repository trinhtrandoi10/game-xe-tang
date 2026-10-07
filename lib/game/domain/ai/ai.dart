import '../../../core/math/game_vector.dart';

enum EnemyArchetype { scout, medium }

enum AiState {
  patrol,
  investigate,
  acquireTarget,
  aim,
  fire,
  flank,
  reposition,
  disabled,
  destroyed
}

class EnemyConfig {
  const EnemyConfig({
    required this.archetype,
    required this.maxHealth,
    required this.maxSpeed,
    required this.detectionRange,
    required this.weaponDamage,
    required this.fireCooldown,
    required this.armor,
  });

  final EnemyArchetype archetype;
  final double maxHealth;
  final double maxSpeed;
  final double detectionRange;
  final double weaponDamage;
  final double fireCooldown;
  final double armor;
}

const scoutConfig = EnemyConfig(
  archetype: EnemyArchetype.scout,
  maxHealth: 480,
  maxSpeed: 12,
  detectionRange: 330,
  weaponDamage: 46,
  fireCooldown: 3.6,
  armor: 70,
);

const mediumConfig = EnemyConfig(
  archetype: EnemyArchetype.medium,
  maxHealth: 820,
  maxSpeed: 7,
  detectionRange: 390,
  weaponDamage: 92,
  fireCooldown: 5.2,
  armor: 125,
);

class EnemyUnit {
  EnemyUnit({
    required this.id,
    required this.config,
    required this.position,
    required this.heading,
  }) : health = config.maxHealth;

  final String id;
  final EnemyConfig config;
  GameVector position;
  double heading;
  double turretHeading = 0;
  double health;
  double fireCooldown = 1.3;
  double stateTimer = 0;
  AiState state = AiState.patrol;
  bool leftTrackDisabled = false;
  bool rightTrackDisabled = false;

  bool get isAlive => health > 0;

  bool get isScout => config.archetype == EnemyArchetype.scout;

  double get healthRatio => (health / config.maxHealth).clamp(0, 1).toDouble();

  void applyDamage(double damage) {
    health = (health - damage).clamp(0, config.maxHealth).toDouble();
    if (health <= 0) state = AiState.destroyed;
  }
}
