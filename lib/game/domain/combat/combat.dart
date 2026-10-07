import 'dart:math' as math;

enum AmmoType { ap, he }

enum ArmorZone { front, side, rear, top }

class ArmorProfile {
  const ArmorProfile({
    required this.front,
    required this.side,
    required this.rear,
    required this.top,
  });

  final double front;
  final double side;
  final double rear;
  final double top;

  double valueFor(ArmorZone zone) {
    return switch (zone) {
      ArmorZone.front => front,
      ArmorZone.side => side,
      ArmorZone.rear => rear,
      ArmorZone.top => top,
    };
  }
}

class AmmoProfile {
  const AmmoProfile({
    required this.type,
    required this.penetration,
    required this.damage,
    required this.splashRadius,
    required this.projectileSpeed,
  });

  final AmmoType type;
  final double penetration;
  final double damage;
  final double splashRadius;
  final double projectileSpeed;
}

const apProfile = AmmoProfile(
  type: AmmoType.ap,
  penetration: 245,
  damage: 360,
  splashRadius: 0,
  projectileSpeed: 210,
);

const heProfile = AmmoProfile(
  type: AmmoType.he,
  penetration: 62,
  damage: 230,
  splashRadius: 34,
  projectileSpeed: 145,
);

AmmoProfile profileForAmmo(AmmoType ammo) =>
    ammo == AmmoType.ap ? apProfile : heProfile;

class DamageResult {
  const DamageResult({
    required this.penetrated,
    required this.damage,
    required this.zone,
    required this.effectiveArmor,
    required this.module,
  });

  final bool penetrated;
  final double damage;
  final ArmorZone zone;
  final double effectiveArmor;
  final DamageModule module;
}

enum DamageModule { none, engine, leftTrack, rightTrack }

class DamageResolver {
  const DamageResolver._();

  static DamageResult resolve({
    required AmmoProfile ammo,
    required ArmorProfile armor,
    required ArmorZone zone,
    required double impactAngleDegrees,
    required double moduleRoll,
  }) {
    final angleRadians = impactAngleDegrees.abs() * math.pi / 180;
    final cosine = math.cos(angleRadians).abs().clamp(0.25, 1.0);
    final effectiveArmor = armor.valueFor(zone) / cosine;
    final penetrated = ammo.penetration >= effectiveArmor;
    if (!penetrated) {
      return DamageResult(
        penetrated: false,
        damage: ammo.type == AmmoType.he ? ammo.damage * 0.12 : 0,
        zone: zone,
        effectiveArmor: effectiveArmor,
        module: DamageModule.none,
      );
    }

    final module = switch (moduleRoll) {
      < 0.14 => DamageModule.engine,
      < 0.27 => DamageModule.leftTrack,
      < 0.40 => DamageModule.rightTrack,
      _ => DamageModule.none,
    };
    final angleMultiplier =
        (1.08 - angleRadians.abs() / math.pi * 0.18).clamp(0.72, 1.08);
    return DamageResult(
      penetrated: true,
      damage: ammo.damage * angleMultiplier,
      zone: zone,
      effectiveArmor: effectiveArmor,
      module: module,
    );
  }
}

class WeaponState {
  WeaponState({this.reloadDuration = 2.6});

  final double reloadDuration;
  double reloadRemaining = 0;

  bool get isReady => reloadRemaining <= 0;

  void tick(double dt) {
    reloadRemaining =
        (reloadRemaining - dt).clamp(0, reloadDuration).toDouble();
  }

  void beginReload() {
    reloadRemaining = reloadDuration;
  }

  double get reloadRatio =>
      (reloadRemaining / reloadDuration).clamp(0, 1).toDouble();
}
