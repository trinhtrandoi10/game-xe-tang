import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:iron_gorge_ares_override/core/math/game_vector.dart';
import 'package:iron_gorge_ares_override/game/application/game_session.dart';
import 'package:iron_gorge_ares_override/game/application/snapshots/game_snapshot.dart';
import 'package:iron_gorge_ares_override/game/domain/combat/combat.dart';
import 'package:iron_gorge_ares_override/game/domain/economy/economy.dart';
import 'package:iron_gorge_ares_override/game/domain/mission/mission.dart';
import 'package:iron_gorge_ares_override/game/domain/save/save_game.dart';
import 'package:iron_gorge_ares_override/game/infrastructure/commerce/commerce_port.dart';
import 'package:iron_gorge_ares_override/game/infrastructure/persistence/local_save_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('combat resolver', () {
    const armor = ArmorProfile(front: 180, side: 95, rear: 55, top: 35);

    test('AP penetrates the rear but can ricochet on a steep front angle', () {
      final rear = DamageResolver.resolve(
        ammo: apProfile,
        armor: armor,
        zone: ArmorZone.rear,
        impactAngleDegrees: 0,
        moduleRoll: 0.9,
      );
      final angledFront = DamageResolver.resolve(
        ammo: apProfile,
        armor: armor,
        zone: ArmorZone.front,
        impactAngleDegrees: 78,
        moduleRoll: 0.9,
      );

      expect(rear.penetrated, isTrue);
      expect(rear.damage, greaterThan(0));
      expect(angledFront.penetrated, isFalse);
      expect(angledFront.damage, 0);
    });

    test('HE creates a small blocked-hit damage result', () {
      final result = DamageResolver.resolve(
        ammo: heProfile,
        armor: armor,
        zone: ArmorZone.front,
        impactAngleDegrees: 0,
        moduleRoll: 0.9,
      );

      expect(result.penetrated, isFalse);
      expect(result.damage, greaterThan(0));
    });
  });

  test('mission runtime reports the MVP objective graph', () {
    final mission = MissionRuntime();
    expect(mission.objectiveKey, 'objectiveReach');
    mission.stage = MissionStage.destroyScouts;
    mission.destroyedScouts = 1;
    expect(mission.progress, 0.5);
    mission.stage = MissionStage.defendRadar;
    mission.defendRemaining = 15;
    expect(mission.progress, closeTo(2 / 3, 0.0001));
  });

  test('shop purchase changes inventory only after a valid balance check', () {
    final inventory = <String, int>{};
    final product = mvpCatalog.first;
    final rejected = buyProduct(
      inventory: inventory,
      product: product,
      parts: product.priceParts - 1,
    );
    expect(rejected.success, isFalse);
    expect(inventory, isEmpty);

    final accepted = buyProduct(
      inventory: inventory,
      product: product,
      parts: product.priceParts,
    );
    expect(accepted.success, isTrue);
    expect(inventory[product.id], 1);
  });

  test('save round-trips and rejects a corrupted checksum', () {
    final profile = GameProfile.newGame()..parts = 987;
    final save = SaveGame.create(profile, now: DateTime.utc(2026, 9, 13));
    final restored = SaveGame.fromJson(save.toJson());
    expect(restored.profile.parts, 987);
    expect(restored.schemaVersion, SaveGame.currentSchemaVersion);

    final corrupted = save.toJson();
    corrupted['checksum'] = 'bad';
    expect(() => SaveGame.fromJson(corrupted), throwsFormatException);
  });

  test('session moves the player and advances when reaching Binh Minh', () {
    final profile = GameProfile.newGame();
    final session = GameSession(profile);
    session.player.position = const GameVector(-10, -10);
    session.tick(1 / 60);
    expect(session.snapshot.missionStage, MissionStage.destroyScouts);
    session.dispose();
  });

  test('forward input moves straight without steering drift', () {
    final profile = GameProfile.newGame();
    final session = GameSession(profile);
    session.player.heading = 0;
    final start = session.player.position;

    session.setMovement(throttle: 1, steering: 0);
    for (var frame = 0; frame < 60; frame++) {
      session.tick(1 / 60);
    }

    expect(session.player.position.x, closeTo(start.x, 0.0001));
    expect(session.player.position.z, greaterThan(start.z));
    expect(session.player.heading, closeTo(0, 0.0001));
    session.dispose();
  });

  test('new mission starts facing its first objective', () {
    final profile = GameProfile.newGame();
    final session = GameSession(profile);
    final desired =
        (GameSession.townPosition - session.player.position).normalized;
    final forward = GameVector.fromHeading(session.player.heading);

    expect(forward.dot(desired), greaterThan(0.99));
    session.dispose();
  });

  test(
    'mission reward is granted once even if the completed frame repeats',
    () {
      final profile = GameProfile.newGame();
      final session = GameSession(profile);
      session.mission.stage = MissionStage.defendRadar;
      session.mission.defendRemaining = 0.01;
      session.player.position = GameSession.radarPosition;
      final before = profile.parts;

      session.tick(0.1);
      session.tick(0.1);

      expect(session.snapshot.phase, GamePhase.completed);
      expect(profile.parts, before + 420);
      session.dispose();
    },
  );

  test('local save falls back to the previous backup record', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final repository = LocalSaveRepository();
    final first = GameProfile.newGame()..parts = 321;
    final second = GameProfile.newGame()..parts = 654;
    await repository.saveAtomic(SaveGame.create(first));
    await repository.saveAtomic(SaveGame.create(second));
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('iron_gorge.save.primary', '{bad json');

    final restored = await repository.loadLatest();
    expect(restored?.profile.parts, 321);
  });

  test('entitlement grant is idempotent by transaction id', () async {
    final repository = MemoryEntitlementRepository();
    final entitlement = VerifiedEntitlement(
      transactionId: 'tx-001',
      productId: 'skin_red_desert',
      platform: 'test',
      verifiedAt: DateTime.utc(2026, 9, 13),
    );
    await repository.grantVerified(entitlement);
    await repository.grantVerified(entitlement);
    final cached = await repository.loadCached();
    expect(cached.records, hasLength(1));
    expect(cached.owns('skin_red_desert'), isTrue);
  });
}
