# IRON GORGE: ARES OVERRIDE — KẾ HOẠCH TRIỂN KHAI

**Phiên bản:** 1.1  
**Ngày cập nhật:** 2026-09-13  
**Trạng thái:** Approved for technical spike  
**Tên sản phẩm English:** `IRON GORGE: ARES OVERRIDE`  
**Tên sản phẩm Tiếng Việt:** `KHE SẮT: CHỈ THỊ ZERO`  
**Stack chính:** Flutter + Flutter Scene + Rapier 3D  
**Gameplay:** Single-player offline hoàn toàn  
**Commerce:** Google Play/App Store IAP theo yêu cầu; không backend riêng  
**Ngôn ngữ:** Tiếng Việt (`vi`) và Tiếng Anh (`en`)  
**Project slug:** `iron_gorge_ares_override`  
**Tài liệu nguồn:** `GAME_DESIGN_AND_IMPLEMENTATION_PLAN.md`

---

## 1. Mục đích tài liệu

Tài liệu này là kế hoạch triển khai code chính thức cho `IRON GORGE: ARES OVERRIDE` (`KHE SẮT: CHỈ THỊ ZERO` ở locale Tiếng Việt) sau khi chốt bỏ hướng Flame 3D và chuyển sang:

- Flutter cho application shell, menu, HUD, garage, shop và settings.
- `flutter_scene` cho scene graph, render 3D, camera, model, material, lighting, animation, LOD và particle.
- `flutter_scene_rapier` cho physics 3D, collider, rigid body, query, joint và collision event.
- Gameplay core viết bằng Dart thuần, không phụ thuộc trực tiếp vào API renderer hay physics backend.

Tài liệu này thay thế định hướng kỹ thuật, roadmap implementation và thứ tự ticket liên quan đến Flame 3D trong các mục 12, 17, 18, 19 và 21 của GDD. Nội dung cốt truyện, gameplay, bản đồ, nhiệm vụ và economy trong GDD vẫn là nguồn thiết kế chính.

---

## 2. Quyết định đã khóa

### ADR-001 — Renderer

Sử dụng `flutter_scene` làm renderer 3D chính.

Lý do:

- Render dựa trên Flutter GPU/Impeller.
- Có scene graph, PBR, shadow, glTF/GLB, instancing, LOD và particle.
- Tích hợp trực tiếp dưới dạng Flutter widget.
- Có physics contract để thay backend mà không đổi gameplay.

### ADR-002 — Physics

Sử dụng `flutter_scene_rapier` làm physics backend.

MVP dùng physics theo hướng gameplay-driven:

- Xe tăng người chơi dùng controller kinematic có ground query.
- Không mô phỏng từng mắt xích.
- Projectile tốc độ cao dùng swept query/raycast để tránh xuyên vật thể giữa hai frame.
- Vật thể môi trường tĩnh dùng collider đơn giản hóa, không dùng render mesh trực tiếp làm collider nếu không cần thiết.

### ADR-003 — Kiến trúc phụ thuộc

Gameplay domain không import `flutter_scene` hoặc `flutter_scene_rapier`.

Mọi phụ thuộc engine đi qua port/adapter để:

- Unit test gameplay không cần GPU.
- Có thể nâng version engine có breaking change trong phạm vi adapter.
- Có đường lui sang renderer/engine khác nếu technical spike thất bại.

### ADR-004 — Phạm vi bản phát hành đầu

Bản phát hành đầu là MVP 1 × 1 km, không phải toàn bộ chiến dịch 16 × 16 km.

### ADR-005 — Offline runtime

Game là single-player offline hoàn toàn ở lớp gameplay:

- Không yêu cầu đăng nhập.
- Không có tài khoản game.
- Không có backend gameplay hoặc kết nối bắt buộc khi khởi động.
- Campaign, mission, garage, inventory, loadout và save/load đều hoạt động khi thiết bị không có mạng.
- Save local có schema version và backup.
- Mất mạng không được chặn người chơi khởi động hoặc tiếp tục campaign.

Ngoại lệ duy nhất là commerce: thiết bị phải có mạng khi người chơi chủ động mở catalog store, mua hàng, khôi phục giao dịch hoặc đồng bộ lại entitlement với Google Play/App Store.

### ADR-006 — IAP và entitlement

Giữ IAP cho nội dung không tạo lợi thế chiến đấu:

- Skin, decal và cosmetic effect.
- Gói nhạc/radio.
- Supporter pack.
- Expansion/DLC có vùng và nhiệm vụ riêng.

Không bán bằng tiền thật:

- Đạn, giáp hoặc vũ khí mạnh hơn.
- Phụ tùng, Titan hoặc tài nguyên dùng nâng sức mạnh.
- Consumable chiến đấu.
- Loot box.
- Subscription trong bản phát hành đầu.

Commerce bản đầu là client-only, dùng tài khoản Google Play/App Store và không có backend riêng. Chỉ hỗ trợ non-consumable IAP. Entitlement đã xác nhận được cache cục bộ và tiếp tục dùng offline. Restore trên thiết bị mới cần kết nối store.

Trade-off đã chấp nhận:

- Client-only không chống gian lận tốt bằng server verification.
- Refund/revoke chỉ được phát hiện khi ứng dụng kết nối và đồng bộ lại với store.
- Nếu cần bảo mật doanh thu cao hơn trong tương lai, có thể thêm verification service tùy chọn nhưng gameplay offline không được phụ thuộc vào service đó.

### ADR-007 — Mục tiêu hiệu năng

- 30 FPS ổn định là yêu cầu bắt buộc trên thiết bị Android mục tiêu.
- 60 FPS là mục tiêu mở rộng cho cấu hình thấp/trung bình nếu profiler cho phép.
- Không mở rộng map trước khi MVP đạt performance gate trên thiết bị thật.

### ADR-008 — Localization Anh/Việt

Hỗ trợ Tiếng Việt và Tiếng Anh ngay từ MVP, không dịch bổ sung vào cuối dự án.

- Flutter `gen_l10n` và file ARB là nguồn chuỗi UI chính thức.
- Tiếng Việt là ngôn ngữ nguồn; Tiếng Anh là bản dịch phát hành.
- Domain, mission data và item catalog chỉ lưu localization key, không lưu text hiển thị trực tiếp.
- Tên sản phẩm cũng lấy từ localization: `appTitle = "KHE SẮT: CHỈ THỊ ZERO"` trong `vi` và `appTitle = "IRON GORGE: ARES OVERRIDE"` trong `en`.
- Lần chạy đầu dùng `vi` nếu thiết bị dùng Tiếng Việt, nếu không fallback sang `en`.
- Người chơi đổi ngôn ngữ trong Settings và thiết lập được lưu local.
- Đổi ngôn ngữ không cần mạng và không yêu cầu restart.
- MVP gồm text/phụ đề song ngữ; English voice-over không thuộc phạm vi MVP.

---

## 3. Baseline công nghệ

### 3.1. Toolchain yêu cầu

Baseline để bắt đầu spike:

- Flutter stable `>= 3.47.1`.
- Dart SDK đi kèm Flutter, đáp ứng constraint của package.
- Android Studio và Android SDK tương thích Flutter stable đã chọn.
- JDK 17.
- Một điện thoại Android thật thuộc phân khúc mục tiêu, RAM 6 GB.
- Git và CI có khả năng build Android APK/AAB.

Môi trường hiện tại đang dùng Flutter 3.35.3 và Dart 3.9.2, do đó phải nâng Flutter trước khi scaffold project.

### 3.2. Package baseline

Version baseline tại thời điểm chốt:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  flutter_scene: ^0.23.0
  flutter_scene_rapier: ^0.5.1
  in_app_purchase: ^3.3.0
  intl: any
  vector_math: any

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```

Quy tắc version:

- Chỉ dùng version trên để tạo spike ban đầu.
- Commit `pubspec.lock` cho application.
- Sau khi spike đạt, khóa exact version trước khi viết combat.
- Không nâng minor version engine giữa sprint nếu không có ticket migration riêng.
- Mọi lần nâng engine phải chạy lại smoke test render, physics và Android soak test.

Nguồn kỹ thuật:

- [Flutter Scene](https://pub.dev/packages/flutter_scene)
- [Flutter Scene Rapier](https://pub.dev/packages/flutter_scene_rapier)
- [Flutter Scene API](https://pub.dev/documentation/flutter_scene/latest/)
- [Flutter in_app_purchase](https://pub.dev/packages/in_app_purchase)

### 3.3. Package bổ sung

Chỉ thêm package khi có use case cụ thể. Nhóm chức năng dự kiến:

- Navigation và dependency injection cho Flutter shell.
- JSON serialization cho config data-driven.
- Local file/path API cho save game.
- Audio backend có độ trễ thấp trên Android/iOS.
- Logging/crash reporting ở giai đoạn phát hành.

Không khóa các package này trước technical spike để giảm bề mặt lỗi toolchain.

---

## 4. Phạm vi MVP

### 4.1. Trải nghiệm chơi

MVP là một nhiệm vụ mở đầu dài 8–10 phút:

1. Khởi động T-99 trong garage bị phá hủy.
2. Tutorial tiến, lùi, xoay thân và xoay tháp pháo.
3. Bắn mục tiêu thử bằng AP và HE.
4. Di chuyển đến thị trấn Bình Minh.
5. Đụng độ hai xe trinh sát ARES.
6. Tiếp cận và chiếm radar Nam-1.
7. Phòng thủ radar 90 giây trước một xe trung và viện binh.
8. Hoàn thành nhiệm vụ, nhận Phụ tùng.
9. Trở về garage, mua và trang bị bộ sửa chữa.
10. Lưu checkpoint và cho phép tiếp tục/chơi lại.

### 4.2. Gameplay có trong MVP

- Một xe người chơi: T-99 Bão Thép.
- Hai archetype địch: xe nhẹ và xe trung.
- Thân xe và tháp pháo xoay độc lập.
- Camera thứ ba sau xe.
- Joystick trái và vùng aim bên phải.
- Hai loại đạn: AP và HE.
- Reload, ammo switching và ammo capacity.
- Giáp trước, hông, sau và nóc.
- Hai module damage: xích và động cơ.
- AI patrol, investigate, acquire, aim, fire và flank cơ bản.
- Objective reach, destroy, capture và defend.
- HUD, pause, retry, result screen.
- Garage tối giản, wallet, inventory và shop bằng Phụ tùng.
- Save/load local.

### 4.3. Ngoài phạm vi MVP

- Map 16 × 16 km.
- Streaming toàn thế giới và floating origin hoàn chỉnh.
- HEAT, ATGM, drone, pháo binh và không kích.
- Đồng đội chiến đấu.
- Boss.
- Thời tiết động.
- Môi trường phá hủy diện rộng.
- Nhiều xe người chơi.
- Live IAP và store sandbox chưa nằm trong MVP gameplay; interface, entitlement schema và fake purchase adapter vẫn phải có từ đầu.
- Backend, account và cloud save.
- Toàn bộ 12 nhiệm vụ chính.

---

## 5. Kiến trúc hệ thống

### 5.1. Sơ đồ cấp cao

```text
Flutter Application
├── App shell / Navigation / Settings
├── LocaleController / AppLocalizations
├── Menu / Garage / Shop / Inventory
├── Store Catalog / Purchase / Restore
├── HUD / Pause / Mission Result
└── GameScreen
    └── SceneView
        ├── SceneRendererAdapter
        ├── RapierPhysicsAdapter
        ├── InputAdapter
        ├── AudioAdapter
        └── GameSession
            ├── SimulationClock
            ├── VehicleSystem
            ├── WeaponSystem
            ├── DamageSystem
            ├── AISystem
            ├── MissionSystem
            ├── SpawnSystem
            ├── EconomySystem
            └── CheckpointSystem

Platform Commerce Boundary
├── PurchaseService
├── StoreCatalogService
├── EntitlementRepository
├── Google Play / App Store Adapter
└── Offline Entitlement Cache
```

### 5.2. Layer

#### Presentation

- Flutter widgets và HUD.
- Chỉ gửi command vào game và đọc immutable snapshot/event.
- Không tự tính damage, reward hoặc mission state.
- Resolve localization key bằng `AppLocalizations`; không nhận câu hiển thị đã hard-code từ domain.

#### Application

- Điều phối `GameSession`.
- Load mission, bắt đầu/pause/resume/end session.
- Chuyển domain event thành UI state, audio cue và visual effect request.

#### Domain

- Vehicle state và movement rule.
- Weapon, projectile và reload rule.
- Armor penetration và damage.
- AI state machine.
- Mission objective graph.
- Wallet, inventory, loadout và transaction.
- Save schema.

Domain là Dart thuần và phải chạy được bằng `dart test`/`flutter test` không cần renderer.

#### Infrastructure

- Flutter Scene renderer.
- Rapier physics.
- Asset loader.
- Local persistence.
- Platform IAP adapter và entitlement cache.
- Audio implementation.
- Device profiling và platform services.

### 5.3. Port bắt buộc

```dart
abstract interface class ScenePort {
  Future<void> loadLevel(String levelId);
  void spawnVisual(VisualSpawnRequest request);
  void syncTransform(EntityId id, WorldTransform transform);
  void removeVisual(EntityId id);
}

abstract interface class PhysicsPort {
  PhysicsHit? raycast(RayQuery query);
  PhysicsHit? shapeCast(ShapeCastQuery query);
  List<EntityId> overlapSphere(SphereQuery query);
  GroundHit? queryGround(WorldPosition position);
}

abstract interface class InputPort {
  PlayerCommand sample();
}

abstract interface class SaveGameRepository {
  Future<SaveGame?> loadLatest();
  Future<void> saveAtomic(SaveGame save);
}

abstract interface class PurchaseService {
  Future<List<StoreProduct>> loadProducts(Set<String> productIds);
  Stream<PurchaseUpdate> get updates;
  Future<PurchaseStartResult> purchase(String productId);
  Future<void> restorePurchases();
  Future<void> completePurchase(String transactionId);
}

abstract interface class EntitlementRepository {
  Future<EntitlementSnapshot> loadCached();
  Future<void> grantVerified(VerifiedEntitlement entitlement);
  Future<void> reconcile(List<VerifiedEntitlement> storeEntitlements);
}
```

Tên và signature cuối cùng có thể thay đổi trong implementation, nhưng ranh giới phụ thuộc không được thay đổi.

### 5.4. Luồng một frame

```text
Input sample
  → enqueue PlayerCommand
  → fixed simulation step
  → vehicle/combat/AI/mission update
  → Rapier step và physics query
  → domain events
  → sync scene transforms/effects
  → publish HUD snapshot
  → render
```

Quy tắc thời gian:

- Physics/combat dùng fixed timestep mặc định `1/60 s`.
- Giới hạn tối đa ba substep để tránh spiral of death.
- Renderer nội suy transform giữa hai simulation state.
- AI decision chạy 5–10 Hz; steering/aim được cập nhật mượt theo simulation.
- HUD snapshot giới hạn khoảng 20 Hz nếu rebuild UI ảnh hưởng hiệu năng.

---

## 6. Cấu trúc thư mục

```text
lib/
├── bootstrap/
│   ├── bootstrap.dart
│   └── app_environment.dart
├── app/
│   ├── app.dart
│   ├── router.dart
│   ├── locale_controller.dart
│   └── theme.dart
├── l10n/
│   ├── app_vi.arb
│   ├── app_en.arb
│   └── glossary.md
├── core/
│   ├── ids/
│   ├── math/
│   ├── result/
│   └── diagnostics/
├── game/
│   ├── domain/
│   │   ├── common/
│   │   ├── vehicle/
│   │   ├── combat/
│   │   ├── ai/
│   │   ├── mission/
│   │   ├── economy/
│   │   ├── commerce/
│   │   └── save/
│   ├── application/
│   │   ├── game_session.dart
│   │   ├── simulation_clock.dart
│   │   ├── commands/
│   │   ├── events/
│   │   └── snapshots/
│   ├── infrastructure/
│   │   ├── scene/
│   │   ├── physics/
│   │   ├── input/
│   │   ├── audio/
│   │   ├── assets/
│   │   ├── commerce/
│   │   └── persistence/
│   └── presentation/
│       ├── game_screen.dart
│       ├── hud/
│       └── overlays/
├── features/
│   ├── main_menu/
│   ├── garage/
│   ├── shop/
│   ├── inventory/
│   ├── mission_result/
│   ├── store/
│   └── settings/
└── shared/
    └── widgets/

assets/
├── config/
│   ├── vehicles/
│   ├── weapons/
│   ├── enemies/
│   ├── missions/
│   ├── economy/
│   └── graphics/
├── levels/
├── models/
├── textures/
├── audio/
├── effects/
└── shaders/

test/
├── game/domain/
├── game/application/
├── features/
└── fixtures/

integration_test/
├── mission_smoke_test.dart
├── save_restore_test.dart
└── garage_shop_test.dart

tool/
├── validate_game_data.dart
├── validate_localizations.dart
├── profile_report.dart
└── build_asset_manifest.dart
```

---

## 7. Thiết kế các hệ gameplay

### 7.1. Tank controller

MVP không dùng mô phỏng bánh/xích vật lý đầy đủ. Controller gồm:

- Kinematic chassis collider.
- Ground ray/shape query tại nhiều điểm dưới thân xe.
- Gia tốc, giảm tốc, reverse speed và hull turn rate theo config.
- Căn thân xe theo normal địa hình có smoothing.
- Giới hạn slope và quy tắc trượt/lùi khi vượt slope.
- Surface modifier cho đường, đất và bùn.
- Turret yaw độc lập với hull yaw.
- Gun pitch có min/max angle.

Camera:

- Spring-arm camera thứ ba.
- Raycast từ pivot đến camera để tránh xuyên tường.
- Aim point được raycast từ tâm màn hình.
- Camera shake có cường độ giới hạn và tùy chọn tắt.

### 7.2. Projectile và weapon

`WeaponSystem` chịu trách nhiệm:

- Fire rate và reload state.
- Loại đạn đang chọn.
- Ammo count.
- Muzzle transform.
- Dispersion và aim assist.
- Phát `ShotFiredEvent`.

`ProjectileSystem`:

- Dùng object pool cho visual projectile, tracer và impact effect.
- AP dùng ballistic step kết hợp swept query.
- HE dùng ballistic step; khi va chạm tạo overlap sphere để tính splash.
- Không dùng một dynamic rigid body riêng cho mọi viên đạn nếu profiler cho thấy tốn CPU.

### 7.3. Armor và damage

Mỗi xe có armor zone:

- Front.
- Side left/right.
- Rear.
- Top.

Pipeline xử lý hit:

1. Physics trả về target, point, normal và collider metadata.
2. `DamageResolver` xác định armor zone.
3. Tính effective armor từ base armor và góc va chạm.
4. So sánh penetration với effective armor.
5. Nếu không xuyên, phát `RicochetEvent` hoặc `BlockedHitEvent`.
6. Nếu xuyên, gây hull damage và kiểm tra module gần hit point.
7. Phát event cho audio, VFX, HUD và AI threat response.

MVP chỉ mô phỏng xích và động cơ:

- Hỏng xích: không tiến/lùi, vẫn xoay tháp pháo và có thể sửa.
- Hỏng động cơ: giảm tốc/gia tốc; critical có thể gây cháy theo rule đơn giản.

Turret, ammo rack và crew damage đưa sang vertical slice.

### 7.4. Enemy AI

FSM MVP:

```text
Patrol
  → Investigate
  → AcquireTarget
  → Aim
  → Fire
  → Reposition/Flank
  → Aim

Any state
  → Disabled
  → Destroyed
```

Perception:

- Khoảng cách phát hiện.
- Field of view.
- Line-of-sight raycast.
- Threat memory với thời gian hết hạn.
- Gunshot/impact stimulus đơn giản.

Navigation MVP:

- Waypoint graph do level designer đặt.
- Cover/flank point được author sẵn.
- Không triển khai navmesh động trong MVP.
- Nếu không tìm được đường sau timeout, AI reset về waypoint gần nhất hoặc chuyển sang fire-from-position.

### 7.5. Mission runtime

Objective type MVP:

- `reach`
- `destroy`
- `capture`
- `defend`
- `interact`

Mission chạy như directed graph, không hard-code trong screen/component.

Mỗi objective có:

- Start condition.
- Completion condition.
- Failure condition.
- Optional timeout.
- UI text key.
- Spawn/action khi bắt đầu hoặc kết thúc.
- Checkpoint flag.
- Reward.

### 7.6. Save game

Save MVP gồm:

- `schemaVersion`.
- Campaign/mission progress.
- Checkpoint state.
- Wallet.
- Inventory và loadout.
- Settings.
- Timestamp và checksum cơ bản.

Entitlement mua bằng tiền thật không được coi là dữ liệu sở hữu đáng tin cậy trong campaign save. Nó nằm trong `EntitlementRepository` riêng, gồm transaction id, product id, platform, trạng thái xác nhận và thời điểm đồng bộ gần nhất.

Quy tắc ghi:

1. Serialize sang file tạm.
2. Flush thành công.
3. Giữ file save trước đó làm backup.
4. Replace file chính.
5. Nếu load file chính thất bại, thử backup.

Không save trực tiếp toàn bộ scene graph hay physics world. Chỉ save domain state tối thiểu để tái dựng scene.

### 7.7. Economy và shop

MVP chỉ có `Phụ tùng`.

Purchase transaction:

1. Validate product tồn tại và đã mở khóa.
2. Validate số dư và giới hạn sở hữu.
3. Tạo transaction id.
4. Trừ wallet và cấp item trong cùng domain transaction.
5. Persist save.
6. Nếu persist thất bại, rollback snapshot trong memory và thông báo lỗi.

Gameplay chỉ đọc loadout; không gọi trực tiếp shop UI hoặc persistence.

### 7.8. IAP và entitlement offline

Tích hợp IAP dùng package Flutter chính thức `in_app_purchase` và adapter riêng cho Google Play/App Store.

Product type bản đầu:

- `nonConsumableCosmetic`
- `nonConsumableSupporterPack`
- `nonConsumableExpansion`

Không hỗ trợ consumable hoặc subscription bằng tiền thật trong bản đầu. Vật phẩm tiêu hao trong trận chỉ được mua bằng tài nguyên gameplay.

Luồng mua:

1. Người chơi chủ động mở Store; nếu offline, hiển thị catalog cache ở chế độ chỉ xem.
2. Khi online, tải tên và giá thật từ platform store; không hard-code giá tiền thật.
3. Khởi tạo purchase và lắng nghe purchase update.
4. Không cấp entitlement khi trạng thái là pending, canceled hoặc failed.
5. Khi platform trả trạng thái purchased/restored và verification data hợp lệ, kiểm tra transaction id chưa được xử lý.
6. Ghi entitlement idempotent vào local repository.
7. Hoàn tất/acknowledge giao dịch với platform ngay sau khi cấp thành công.
8. Entitlement đã cache được sử dụng khi offline.

State machine:

```text
Unavailable/Offline
  → LoadingCatalog
  → Ready
  → PurchasePending
  → Purchased → Granting → Completing → Owned
  → Canceled
  → Failed

RestoreRequested
  → Restoring
  → ReconcileEntitlements
  → Restored/NoPurchases/Failed
```

Quy tắc offline:

- Game không tự buộc kết nối store khi boot hoặc load campaign.
- Không có entitlement cache vẫn phải chơi được toàn bộ campaign chính.
- Mất mạng giữa purchase giữ trạng thái pending; không đoán giao dịch thất bại hay tự cấp item.
- Khi người chơi mở Store hoặc chọn Restore lúc có mạng, ứng dụng query lại giao dịch và reconcile.
- Cài lại/chuyển thiết bị cần online và dùng cùng tài khoản store để Restore Purchases.
- Refund/revoke được áp dụng ở lần reconcile online tiếp theo; khi offline, cache cuối cùng tiếp tục có hiệu lực.

Do không có backend, local entitlement cache không thể chống sửa đổi tuyệt đối. Không lưu một boolean `isPremium` đơn lẻ; phải lưu record theo transaction và chỉ tạo record từ purchase update của platform. Đây là mức bảo vệ phù hợp với cosmetic/DLC không pay-to-win, nhưng phải được đánh giá lại nếu mô hình doanh thu thay đổi.

Tài liệu nền tảng phải đối chiếu khi implement:

- [Flutter in_app_purchase API](https://pub.dev/documentation/in_app_purchase/latest/in_app_purchase/)
- [Google Play Billing — Integrate and process purchases](https://developer.android.com/google/play/billing/integrate)
- [Google Play Billing — Security and verification](https://developer.android.com/google/play/billing/security)
- [Apple StoreKit 2](https://developer.apple.com/storekit/)

### 7.9. Localization Tiếng Việt/Tiếng Anh

Sử dụng localization tích hợp của Flutter:

```text
lib/l10n/
├── app_vi.arb
├── app_en.arb
└── glossary.md

l10n.yaml
```

Phạm vi dịch bắt buộc:

- Main menu, Settings, Garage, Shop và Inventory.
- HUD, pause, tutorial và control hint.
- Objective title, description, progress và failure reason.
- Hội thoại, radio message và phụ đề.
- Item, weapon, vehicle, upgrade và cosmetic description.
- Thông báo save, lỗi, IAP, restore và offline state.
- Accessibility label.

Quy ước dữ liệu:

- Widget dùng key được sinh bởi `gen_l10n`.
- Mission JSON dùng các trường như `titleKey`, `descriptionKey`, `dialogueKey`; không chứa câu Tiếng Việt/Tiếng Anh trực tiếp.
- Product catalog nội bộ dùng localization key cho mô tả; giá và tên sản phẩm IAP do platform store cung cấp theo locale hiện tại.
- Placeholder dùng ICU syntax và phải có cùng tên/kiểu ở cả hai file ARB.
- Plural, số, phần trăm và thời lượng phải format theo locale.
- Tên riêng được quản lý trong `glossary.md` để dịch nhất quán.
- Glossary khóa `Khe Sắt` → `Iron Gorge`; thuật ngữ cốt truyện `Chỉ thị Zero` → `Zero Directive`. Riêng tên sản phẩm English dùng `ARES Override` theo quyết định branding, không dịch từng chữ từ tên Việt.

Locale behavior:

1. Lần chạy đầu đọc locale thiết bị.
2. Chọn `vi` nếu locale bắt đầu bằng `vi`, còn lại chọn `en`.
3. Người chơi có thể chọn `Tiếng Việt`, `English` hoặc `Theo thiết bị` trong Settings.
4. `LocaleController` cập nhật UI ngay và lưu lựa chọn vào local settings.
5. Gameplay simulation không restart; subtitle đang hiển thị được cập nhật từ key hoặc áp dụng từ câu kế tiếp.

Font/UI:

- Font phát hành phải chứa đủ glyph Tiếng Việt và Latin.
- Không dùng uppercase bằng cách biến đổi chuỗi nếu font/locale tạo kết quả khó đọc; ưu tiên bản dịch định dạng sẵn.
- Button, objective panel và subtitle box phải hỗ trợ wrap và giới hạn dòng có chủ đích.
- Test ở chiều rộng màn hình nhỏ nhất được hỗ trợ và text scale tối thiểu 1.0/1.3.
- Không đặt text quan trọng bên trong texture 3D; nếu bắt buộc, phải có texture riêng cho từng locale.

Audio:

- MVP dùng voice/radio Tiếng Việt nếu có, đi kèm phụ đề Việt/Anh theo lựa chọn.
- Nếu chưa có voice asset, cả hai locale dùng subtitle đầy đủ.
- English voice-over chỉ được lập kế hoạch sau vertical slice và không chặn MVP.

---

## 8. Asset và level pipeline

### 8.1. Quy ước asset 3D

- Source authoring: Blender.
- Exchange format: `.glb`.
- Runtime ưu tiên asset đã preprocess bằng pipeline Flutter Scene.
- Trục tọa độ, unit và pivot phải được test/khóa trong spike.
- Tank model tách node ít nhất thành hull, turret, gun và wheel/track visual groups.
- Collider là mesh đơn giản riêng, không tái sử dụng high-poly render mesh.
- Material ưu tiên atlas và texture nén có mipmap.

### 8.2. Naming

```text
t99_hull
t99_turret
t99_gun
t99_col_hull
t99_col_turret
enemy_scout_a
radar_nam1
sector_00_00
spawn_enemy_light_01
cover_town_01
```

### 8.3. Level MVP

Map 1 × 1 km được chia logic thành bốn sector 500 × 500 m:

```text
sector_00_01 | sector_01_01
-------------+-------------
sector_00_00 | sector_01_00
```

Trong MVP có thể load cả bốn sector một lần, nhưng dữ liệu phải được lưu theo sector từ đầu để chuẩn bị cho streaming.

Mỗi sector khai báo:

- Bounds.
- Environment asset.
- Static colliders.
- Spawn point/group.
- Mission trigger.
- Waypoint/cover point.
- Audio zone.
- Neighbor ids.

---

## 9. Roadmap triển khai

Ước lượng dưới đây giả định hai lập trình viên và một 3D generalist part-time. Solo developer nên nhân thời lượng khoảng 1,8–2,2 lần.

### Giai đoạn 0 — Foundation và toolchain

**Thời lượng:** 3–5 ngày

Deliverable:

- Nâng và khóa Flutter stable tương thích.
- Scaffold Android/iOS Flutter app.
- Add Flutter Scene và Rapier.
- Chạy `flutter_scene:init` và xác minh asset pipeline.
- Landscape orientation và immersive mode.
- Cấu hình `gen_l10n`, `l10n.yaml`, `app_vi.arb` và `app_en.arb`.
- CI chạy format, analyze, unit test và Android debug build.
- Chọn và ghi lại thiết bị Android chuẩn.
- Performance overlay/debug logging tối thiểu.

Gate:

- App trắng build và chạy trên Android thật.
- Flutter Scene render primitive đầu tiên.
- CI xanh.

### Giai đoạn 1 — Technical spike renderer và physics

**Thời lượng:** 1–2 tuần, timebox cứng

Deliverable:

- Load một model tank `.glb`.
- Render terrain mẫu 500 × 500 m.
- Perspective camera và light/shadow.
- Hull/turret/gun node độc lập.
- Rapier world, static terrain collider và tank collider.
- Raycast, overlap query và collision event mẫu.
- Touch input tối thiểu.
- Benchmark Android 15 phút.

Go criteria:

- Không crash hoặc lỗi shader nghiêm trọng.
- Tank/model đúng scale, orientation và material.
- Camera/input có thể điều khiển liên tục.
- Physics query ổn định.
- FPS không thường xuyên dưới 30 trên thiết bị chuẩn.
- Không có memory growth mất kiểm soát trong 15 phút.

No-go:

- Lỗi renderer/driver lặp lại trên thiết bị mục tiêu.
- Không thể đạt 30 FPS với scene đại diện tối thiểu.
- Collision query hoặc asset pipeline không đủ ổn định để viết gameplay.

Nếu no-go, dừng production và lập ADR mới trước khi tiếp tục.

### Giai đoạn 2 — Tank controller

**Thời lượng:** 2 tuần

Deliverable:

- Simulation clock.
- Player command/input mapping.
- Hull movement, acceleration, reverse và turn.
- Ground alignment, slope và surface modifier.
- Turret/gun control độc lập.
- Third-person camera collision.
- Debug tuning panel cho movement constants.

Acceptance:

- Chơi bằng cảm ứng trong 10 phút không bị drift input.
- Không xuyên terrain hoặc obstacle tĩnh.
- Camera không xuyên công trình rõ rệt.
- Có thể tune toàn bộ feel từ config mà không sửa controller code.

### Giai đoạn 3 — Combat core

**Thời lượng:** 2 tuần

Deliverable:

- Weapon state machine.
- AP/HE projectile.
- Swept collision và impact metadata.
- Armor zones và penetration resolver.
- Hull health, track và engine damage.
- Reload/ammo HUD snapshot.
- Muzzle flash, impact, ricochet, smoke và camera shake bản placeholder.

Acceptance:

- Test tự động cho front/side/rear armor và góc va chạm.
- Projectile tốc độ cao không xuyên mục tiêu do tunneling trong test chuẩn.
- Pool không tăng object count vô hạn.
- Damage kết quả có thể tái lập khi dùng cùng random seed.

### Giai đoạn 4 — Enemy AI

**Thời lượng:** 1–2 tuần

Deliverable:

- AI FSM.
- Perception và line of sight.
- Waypoint patrol.
- Aim/fire/reload.
- Reposition và flank point.
- Hai archetype enemy data.
- AI debug overlay.

Acceptance:

- AI không phát hiện người chơi xuyên obstacle.
- AI bắn, đổi vị trí và có thể bị vô hiệu hóa.
- Mười AI hoạt động trong scene benchmark vẫn đạt performance gate.
- State transition có unit test.

### Giai đoạn 5 — Mission, spawn và checkpoint

**Thời lượng:** 1–2 tuần

Deliverable:

- Mission definition loader.
- Objective graph.
- Reach/destroy/capture/defend/interact.
- Spawn group.
- Failure, retry và result.
- Checkpoint domain state.
- Dialogue/radio event placeholder.
- Dialogue và objective chỉ tham chiếu localization key.

Acceptance:

- Chạy được mission fixture từ đầu đến cuối không hard-code trong `GameScreen`.
- Retry không nhân đôi spawn hoặc reward.
- Load checkpoint khôi phục đúng objective hiện tại.

### Giai đoạn 6 — Flutter shell, garage, shop và save

**Thời lượng:** 1–2 tuần

Deliverable:

- Main menu và continue/new game.
- HUD hoàn chỉnh cho MVP.
- Pause/settings.
- Language selector: Theo thiết bị/Tiếng Việt/English.
- Mission result.
- Garage/loadout tối giản.
- Wallet/inventory/shop bằng Phụ tùng.
- Atomic local save và backup restore.
- `PurchaseService` fake và versioned entitlement schema.
- Store UI có trạng thái offline/read-only nhưng chưa gọi store thật.

Acceptance:

- Luồng menu → mission → result → garage → shop → continue hoạt động.
- Shop không thể trừ tiền hai lần hoặc cấp item hai lần.
- Save migration fixture và corrupted-save fallback có test.
- Gameplay chạy bình thường khi fake commerce adapter báo unavailable/offline.

### Giai đoạn 7 — Content MVP

**Thời lượng:** 2 tuần

Deliverable:

- Map 1 × 1 km gồm garage, đường, thị trấn và radar.
- Encounter xe nhẹ và xe trung.
- Nhiệm vụ capture/defend 8–10 phút.
- Tutorial contextual.
- Nội dung UI, tutorial, objective và subtitle hoàn chỉnh bằng Tiếng Việt/Tiếng Anh.
- Audio, VFX và haptic bản MVP.
- Balance pass đầu tiên.

Acceptance:

- Có thể chơi từ main menu đến kết quả mà không dùng debug command.
- Người chơi thử hiểu mục tiêu mà không cần developer giải thích.
- Không thiếu localization key hoặc lỗi font/tràn chữ nghiêm trọng ở cả hai ngôn ngữ.
- Không có soft-lock phổ biến.

### Giai đoạn 8 — Optimization và MVP release candidate

**Thời lượng:** 1–2 tuần

Deliverable:

- CPU/GPU/memory profiling trên thiết bị thật.
- Graphics preset low/medium.
- Texture, collider, shadow và particle optimization.
- 30-minute soak test.
- Release APK/AAB nội bộ.
- Bug triage và known-issues document.

MVP gate:

- FPS p95 đáp ứng ngân sách 30 FPS.
- Không crash trong 30 phút.
- Memory không tăng mất kiểm soát qua ba lần retry.
- Save/load và shop transaction ổn định.
- Mission completion rate trong playtest nội bộ đạt mức chấp nhận được.

### Giai đoạn 9 — World streaming foundation

Chỉ bắt đầu sau khi MVP gate đạt.

**Thời lượng dự kiến:** 2–3 tuần

- Sector loader 500 × 500 m.
- Predictive preload theo hướng di chuyển.
- Asset cache và delayed unload.
- AI simulation tier.
- Sector state persistence.
- Floating origin.
- Chuyển MVP từ load-all sang stream bốn sector.

### Giai đoạn 10 — Vertical slice 2 × 2 km

**Thời lượng dự kiến:** 6–10 tuần tùy art/content

- 16 sector.
- Làng, rừng, sông, cầu và căn cứ địch.
- Ba kiểu encounter.
- Boss.
- Weather preset chuyển đổi.
- Garage/nâng cấp gần chất lượng phát hành.
- Art, audio và VFX target quality.

Chỉ sau vertical slice mới lập kế hoạch production cho toàn bộ 16 × 16 km và 12 nhiệm vụ chính.

### Giai đoạn 11 — IAP sandbox và entitlement

Chỉ bắt đầu sau khi gameplay/retention của vertical slice đã được kiểm chứng.

**Thời lượng dự kiến:** 2–3 tuần

Deliverable:

- Product catalog mapping cho Google Play và App Store.
- `in_app_purchase` adapter.
- Purchase stream lifecycle.
- Pending, purchased, restored, canceled và failed state.
- Idempotent entitlement grant.
- Client-side complete/acknowledge flow.
- Offline entitlement cache.
- Restore Purchases.
- Refund/revoke reconcile khi kết nối store trở lại.
- Sandbox test trên Android và iOS.

Acceptance:

- Campaign chính chạy khi không có mạng hoặc store unavailable.
- Không cấp entitlement cho pending/failed/canceled purchase.
- Một transaction phát lại nhiều lần chỉ cấp entitlement một lần.
- Mất mạng giữa purchase không làm mất dấu transaction và không tự cấp item.
- Entitlement đã xác nhận vẫn hoạt động offline sau khi restart.
- Restore trên thiết bị mới khôi phục đúng non-consumable purchase.
- Refund/revoke được phản ánh sau lần reconcile online tiếp theo.

---

## 10. Backlog ưu tiên

### Epic FOUND — Foundation

1. `FOUND-001` Nâng Flutter và chạy `flutter doctor` sạch cho Android.
2. `FOUND-002` Scaffold app Android/iOS và khóa orientation.
3. `FOUND-003` Tích hợp Flutter Scene asset pipeline.
4. `FOUND-004` Tích hợp Rapier backend.
5. `FOUND-005` CI format/analyze/test/build.
6. `FOUND-006` Performance HUD và structured logging.

### Epic RENDER — Renderer spike

1. `RENDER-001` Render primitive và camera.
2. `RENDER-002` Load tank GLB.
3. `RENDER-003` Tách transform hull/turret/gun.
4. `RENDER-004` Terrain, light, shadow và material.
5. `RENDER-005` Scene/asset dispose test.
6. `RENDER-006` Android benchmark report.

### Epic PHYS — Physics spike

1. `PHYS-001` Rapier world lifecycle.
2. `PHYS-002` Static terrain/obstacle collider.
3. `PHYS-003` Tank kinematic collider.
4. `PHYS-004` Raycast/shape-cast/overlap adapter.
5. `PHYS-005` Collision metadata mapping về `EntityId`.

### Epic TANK — Vehicle

1. `TANK-001` Player command model.
2. `TANK-002` Acceleration/reverse/turn controller.
3. `TANK-003` Ground alignment và slope.
4. `TANK-004` Turret/gun aim.
5. `TANK-005` Third-person camera collision.
6. `TANK-006` Touch controls và sensitivity settings.

### Epic COMBAT — Combat

1. `COMBAT-001` Weapon/reload state machine.
2. `COMBAT-002` Projectile pool.
3. `COMBAT-003` Swept collision.
4. `COMBAT-004` AP penetration resolver.
5. `COMBAT-005` HE splash resolver.
6. `COMBAT-006` Armor-zone metadata.
7. `COMBAT-007` Track/engine module damage.
8. `COMBAT-008` Combat events và VFX/audio bridge.

### Epic AI — Enemy AI

1. `AI-001` AI FSM runtime.
2. `AI-002` Vision/LOS sensor.
3. `AI-003` Waypoint patrol.
4. `AI-004` Aim/fire behavior.
5. `AI-005` Reposition/flank behavior.
6. `AI-006` AI debug overlay và performance throttling.

### Epic MISSION — Mission

1. `MISSION-001` Mission schema và validator.
2. `MISSION-002` Objective graph runtime.
3. `MISSION-003` Trigger/spawn system.
4. `MISSION-004` Capture/defend objective.
5. `MISSION-005` Fail/retry/checkpoint.
6. `MISSION-006` Reward và mission result.

### Epic META — Meta game

1. `META-001` Versioned save schema.
2. `META-002` Atomic save/backup.
3. `META-003` Wallet/inventory/loadout.
4. `META-004` Product catalog.
5. `META-005` Shop transaction/rollback.
6. `META-006` Garage và equipment UI.

### Epic COMMERCE — IAP và entitlement

1. `COMMERCE-001` Product id mapping theo platform.
2. `COMMERCE-002` PurchaseService fake và offline behavior.
3. `COMMERCE-003` Platform purchase adapter bằng `in_app_purchase`.
4. `COMMERCE-004` Purchase state machine và listener lifecycle.
5. `COMMERCE-005` Idempotent entitlement repository.
6. `COMMERCE-006` Local entitlement cache và migration.
7. `COMMERCE-007` Complete/acknowledge retry queue.
8. `COMMERCE-008` Restore Purchases.
9. `COMMERCE-009` Reconcile refund/revoke.
10. `COMMERCE-010` Google Play/App Store sandbox test matrix.

### Epic LOC — Localization Anh/Việt

1. `LOC-001` Cấu hình Flutter `gen_l10n` và locale resolution.
2. `LOC-002` Tạo `app_vi.arb`, `app_en.arb` và glossary.
3. `LOC-003` LocaleController và lưu lựa chọn offline.
4. `LOC-004` Localize app shell, menu và Settings.
5. `LOC-005` Localize HUD, tutorial và objective.
6. `LOC-006` Localize dialogue, radio và subtitle.
7. `LOC-007` Localize garage, item catalog và shop state.
8. `LOC-008` Validator phát hiện missing/unused/mismatched placeholder key.
9. `LOC-009` Font glyph và UI overflow test cho `vi`/`en`.
10. `LOC-010` Biên tập/copy review bản Tiếng Anh.

### Epic MVP — Content và release

1. `MVP-001` Map sector data và level assembly.
2. `MVP-002` Tutorial sequence.
3. `MVP-003` Bình Minh encounter.
4. `MVP-004` Radar capture/defend encounter.
5. `MVP-005` Audio/VFX/haptic pass.
6. `MVP-006` Balance/playtest pass.
7. `MVP-007` Android performance pass.
8. `MVP-008` Release candidate smoke test.

---

## 11. Chiến lược test

### Unit test bắt buộc

- Vehicle acceleration, reverse và turn constraints.
- Armor-zone classification.
- Effective armor và penetration outcome.
- AP/HE damage.
- Reload/ammo state machine.
- AI state transitions.
- Mission objective transitions.
- Reward idempotency.
- Wallet/inventory transaction rollback.
- Save migration và corrupted-save recovery.
- Locale resolution, fallback và persisted language selection.
- Localization key parity và ICU placeholder parity giữa `vi`/`en`.

### Integration test

- App boot và load GameScreen.
- Load/unload level nhiều lần.
- Start → complete → retry mission.
- Save ở checkpoint → kill app → continue.
- Mission reward → shop purchase → reload save.
- Pause/resume/background/foreground.
- Store unavailable/offline → campaign và garage vẫn hoạt động.
- Purchase pending → restart app → reconcile mà không cấp trùng.
- Purchased/restored event phát lặp → entitlement chỉ được grant một lần.
- Entitlement cache → restart offline → cosmetic/DLC vẫn khả dụng.
- Đổi `vi` ↔ `en` không restart app và không làm reset gameplay state.
- Chạy mission fixture ở cả `vi` và `en`; không hiện localization key thô.

### Device test

- Android target device là bắt buộc trong mọi performance gate.
- iOS smoke test bắt đầu muộn nhất trước vertical slice.
- Emulator chỉ dùng kiểm tra chức năng, không dùng chốt FPS, memory hoặc nhiệt độ.
- IAP phải được test bằng Google Play license tester và App Store sandbox/TestFlight trên thiết bị thật.
- UI localization phải test trên màn hình nhỏ nhất hỗ trợ, cả `vi`/`en` và text scale 1.0/1.3.

### Regression fixture

Mỗi bug thuộc combat, mission, shop hoặc save phải có test hoặc fixture tái hiện trước khi đóng ticket nếu kỹ thuật cho phép.

---

## 12. Ngân sách hiệu năng ban đầu

Các con số dưới đây là budget ban đầu và phải được điều chỉnh bằng profiler:

- Frame time p95 không vượt 33,3 ms trên Android mục tiêu.
- Tối đa 10 AI combat đầy đủ trong MVP benchmark.
- AI decision 5–10 Hz; không chạy mọi quyết định mỗi frame.
- Không tạo allocation lớn liên tục trong simulation loop.
- Projectile, impact, smoke và debris dùng pool.
- Texture thông thường 512–2048 px; không dùng 4K trong MVP.
- Shadow chỉ cho directional light và object quan trọng ở khoảng cách gần.
- Collider dùng primitive/convex đơn giản khi có thể.
- Mức RAM mục tiêu ban đầu dưới khoảng 900 MB trên thiết bị 6 GB, sau đó hạ tiếp bằng profiler.
- Scene load phải có progress UI; không để UI đóng băng không phản hồi.
- Sau ba lần retry mission, memory phải quay về vùng ổn định thay vì tăng tuyến tính.

Mỗi báo cáo performance phải ghi:

- Thiết bị và OS.
- Flutter/engine/package version.
- Graphics preset.
- FPS p50/p95/min.
- CPU/GPU frame time nếu có.
- Peak memory và memory sau soak.
- Scene/encounter đang chạy.

---

## 13. Definition of Done cho MVP

MVP chỉ hoàn thành khi:

- Chơi được từ main menu đến mission result không cần debug tool.
- Tank điều khiển tốt bằng cảm ứng.
- Hull, turret, gun và camera hoạt động độc lập đúng thiết kế.
- AP và HE có feedback và kết quả damage nhất quán.
- Có ít nhất hai archetype địch với hành vi khác nhau.
- Mission dài 8–10 phút có tutorial, combat, capture và defend.
- Retry không nhân đôi enemy, reward hoặc listener.
- Save/load giữ đúng checkpoint, wallet, inventory và loadout.
- Shop transaction không mất hoặc cấp trùng item.
- Campaign chính hoàn toàn sử dụng được khi offline; Store unavailable không chặn boot, continue hoặc mission.
- Chạy 30 phút không crash.
- Không có memory growth mất kiểm soát qua ba lần retry.
- Đạt tối thiểu 30 FPS ổn định trên Android mục tiêu.
- Người chơi thử hiểu objective mà không cần developer hướng dẫn.
- Toàn bộ UI, HUD, tutorial, objective và subtitle MVP có bản `vi`/`en` hoàn chỉnh.
- Đổi ngôn ngữ trong Settings có hiệu lực ngay, được lưu offline và không cần restart.
- Không có missing key, raw key, glyph lỗi hoặc overflow nghiêm trọng ở hai locale.
- CI format, analyze, unit test, integration smoke và Android build đều xanh.

Live IAP không phải điều kiện hoàn thành gameplay MVP. Trước khi phát hành bản có IAP, Giai đoạn 11 phải đạt acceptance riêng.

---

## 14. Rủi ro và cách giảm thiểu

### Flutter Scene/Rapier còn pre-1.0

- Pin exact version sau spike.
- Cô lập toàn bộ API engine trong adapter.
- Không nâng version giữa sprint.
- Duy trì smoke scene để phát hiện regression khi nâng.

### Flutter GPU/driver khác nhau giữa thiết bị

- Test tối thiểu trên hai GPU family trước vertical slice.
- Graphics preset tắt dần shadow, post-process, particle và resolution scale.
- Lưu device/profile data trong benchmark report.

### Tank physics không cho cảm giác tốt

- Dùng kinematic gameplay controller thay vì kỳ vọng rigid-body tự tạo cảm giác lái.
- Tạo debug tuning panel từ sớm.
- Playtest controller trước khi làm content lớn.

### Projectile tốc độ cao bị tunneling

- Swept ray/shape cast giữa vị trí cũ và mới.
- Có regression test với nhiều timestep/frame rate.

### Asset pipeline gây load hitch

- Preprocess asset.
- Mipmap/texture compression.
- Async preload và cache.
- Chia sector data ngay từ MVP.

### Scope mở rộng quá sớm

- MVP và vertical slice là hai release gate độc lập.
- Không làm 16 × 16 km trước khi streaming 2 × 2 km đạt DoD.
- Mọi feature ngoài phạm vi MVP phải có quyết định đổi scope rõ ràng.

### Client-only IAP không có backend verification

- Chỉ bán non-consumable cosmetic, supporter pack và expansion; không bán sức mạnh hoặc tiền mềm.
- Chỉ grant khi platform báo purchased/restored và transaction id chưa được xử lý.
- Complete/acknowledge ngay và có retry queue cho giao dịch chưa hoàn tất.
- Query/reconcile khi người chơi mở Store hoặc chọn Restore lúc online.
- Chấp nhận rằng refund/revoke không thể cập nhật khi thiết bị đang offline.
- Nếu gian lận/doanh thu trở thành rủi ro đáng kể, lập ADR bổ sung verification service nhưng không thay đổi yêu cầu gameplay offline.

---

## 15. Việc thực hiện ngay trong Sprint 0

Thứ tự thực hiện:

1. Nâng Flutter stable lên bản tương thích Flutter Scene.
2. Chạy `flutter doctor -v` và xử lý lỗi Android toolchain.
3. Kết nối/chọn điện thoại Android mục tiêu.
4. Scaffold project Flutter trong repo.
5. Add `flutter_scene` và `flutter_scene_rapier`.
6. Chạy `dart run flutter_scene:init`.
7. Render primitive đầu tiên trên Android thật.
8. Tạo `ScenePort`, `PhysicsPort`, `PurchaseService` và `EntitlementRepository` trước khi thêm gameplay.
9. Import một tank placeholder có hull/turret tách node.
10. Lập benchmark report đầu tiên và quyết định go/no-go.

Không bắt đầu combat, AI, mission hoặc shop trước khi Giai đoạn 1 đạt go criteria.

---

## 16. Mốc ước lượng tổng thể

| Mốc | Đội 2 dev + art part-time | Solo ước lượng |
|---|---:|---:|
| Technical spike đạt gate | 2–3 tuần | 3–5 tuần |
| Tank + combat prototype | 6–7 tuần tích lũy | 11–15 tuần |
| MVP playable | 12–15 tuần tích lũy | 22–30 tuần |
| MVP release candidate | 14–17 tuần tích lũy | 26–34 tuần |
| Vertical slice 2 × 2 km | thêm 6–10 tuần | thêm 12–20 tuần |
| IAP sandbox và entitlement | thêm 2–3 tuần | thêm 3–5 tuần |

Estimate đã bao gồm localization text/phụ đề Việt–Anh cho phạm vi MVP, nhưng chưa bao gồm English voice-over, thu âm chuyên nghiệp, toàn bộ localization của chiến dịch 12–18 giờ hoặc thủ tục phát hành store.

---

## 17. Tiêu chí bắt đầu production toàn chiến dịch

Chỉ lập kế hoạch chi tiết cho thế giới 16 × 16 km khi vertical slice chứng minh được:

- Flutter Scene/Rapier ổn định trên Android và iOS mục tiêu.
- Sector streaming không tạo hitch dễ nhận thấy.
- Floating origin không làm sai mission, projectile hoặc AI.
- AI near/far chuyển tier đúng.
- Save/load sector state đáng tin cậy.
- Pipeline Blender → GLB → Flutter Scene đủ nhanh cho đội content.
- 30 FPS ổn định trong encounter đại diện.
- Có estimate thực tế về số sector, prefab và giờ công content.

Nếu một trong các điều kiện trên không đạt, phạm vi release phải giữ ở dạng mission-based map nhỏ thay vì open world liền mạch.
