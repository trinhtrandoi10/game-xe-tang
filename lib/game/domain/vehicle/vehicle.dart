import '../../../core/math/game_vector.dart';
import '../combat/combat.dart';

class VehicleConfig {
  const VehicleConfig({
    required this.id,
    required this.displayNameKey,
    required this.maxHealth,
    required this.maxSpeed,
    required this.reverseSpeed,
    required this.acceleration,
    required this.hullTurnRate,
    required this.turretTurnRate,
    required this.armor,
  });

  final String id;
  final String displayNameKey;
  final double maxHealth;
  final double maxSpeed;
  final double reverseSpeed;
  final double acceleration;
  final double hullTurnRate;
  final double turretTurnRate;
  final ArmorProfile armor;
}

const t99StormConfig = VehicleConfig(
  id: 't99_storm',
  displayNameKey: 't99Name',
  maxHealth: 1800,
  maxSpeed: 16,
  reverseSpeed: 6.5,
  acceleration: 12,
  hullTurnRate: 0.95,
  turretTurnRate: 1.55,
  armor: ArmorProfile(front: 180, side: 95, rear: 55, top: 35),
);

class TankState {
  TankState({required this.config, required this.position})
      : health = config.maxHealth;

  final VehicleConfig config;
  GameVector position;
  double heading = 0;
  double turretHeading = 0;
  double speed = 0;
  double health;
  int apAmmo = 12;
  int heAmmo = 8;
  AmmoType selectedAmmo = AmmoType.ap;
  double reloadRemaining = 0;
  bool leftTrackDisabled = false;
  bool rightTrackDisabled = false;
  bool engineDisabled = false;

  bool get isDestroyed => health <= 0;

  double get healthRatio => (health / config.maxHealth).clamp(0, 1).toDouble();

  int ammoFor(AmmoType ammo) => ammo == AmmoType.ap ? apAmmo : heAmmo;

  void addAmmo(AmmoType ammo, int amount) {
    if (ammo == AmmoType.ap) {
      apAmmo += amount;
    } else {
      heAmmo += amount;
    }
  }

  void applyHullDamage(double damage) {
    health = (health - damage).clamp(0, config.maxHealth).toDouble();
  }

  void repair(double amount) {
    health = (health + amount).clamp(0, config.maxHealth).toDouble();
    leftTrackDisabled = false;
    rightTrackDisabled = false;
    engineDisabled = false;
  }
}
