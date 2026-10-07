enum StoreProductType {
  nonConsumableCosmetic,
  nonConsumableSupporterPack,
  nonConsumableExpansion
}

class StoreProduct {
  const StoreProduct(
      {required this.id,
      required this.titleKey,
      required this.type,
      this.localizedPrice});

  final String id;
  final String titleKey;
  final StoreProductType type;
  final String? localizedPrice;
}

class PurchaseUpdate {
  const PurchaseUpdate(
      {required this.transactionId,
      required this.productId,
      required this.status});

  final String transactionId;
  final String productId;
  final PurchaseStatus status;
}

enum PurchaseStatus { pending, purchased, restored, canceled, failed }

abstract interface class PurchaseService {
  Future<List<StoreProduct>> loadProducts(Set<String> productIds);

  Stream<PurchaseUpdate> get updates;

  Future<String> purchase(String productId);

  Future<void> restorePurchases();

  Future<void> completePurchase(String transactionId);
}

class VerifiedEntitlement {
  const VerifiedEntitlement(
      {required this.transactionId,
      required this.productId,
      required this.platform,
      required this.verifiedAt});

  final String transactionId;
  final String productId;
  final String platform;
  final DateTime verifiedAt;
}

class EntitlementSnapshot {
  const EntitlementSnapshot(
      {required this.records, required this.lastSyncedAt});

  final List<VerifiedEntitlement> records;
  final DateTime? lastSyncedAt;

  bool owns(String productId) =>
      records.any((record) => record.productId == productId);
}

abstract interface class EntitlementRepository {
  Future<EntitlementSnapshot> loadCached();

  Future<void> grantVerified(VerifiedEntitlement entitlement);

  Future<void> reconcile(List<VerifiedEntitlement> storeEntitlements);
}

/// Idempotent fake/cache implementation used until the platform store
/// adapter is enabled after the vertical-slice gate.
class MemoryEntitlementRepository implements EntitlementRepository {
  final Map<String, VerifiedEntitlement> _records =
      <String, VerifiedEntitlement>{};
  DateTime? _lastSyncedAt;

  @override
  Future<EntitlementSnapshot> loadCached() async => EntitlementSnapshot(
      records: List<VerifiedEntitlement>.unmodifiable(_records.values),
      lastSyncedAt: _lastSyncedAt);

  @override
  Future<void> grantVerified(VerifiedEntitlement entitlement) async {
    _records[entitlement.transactionId] = entitlement;
  }

  @override
  Future<void> reconcile(List<VerifiedEntitlement> storeEntitlements) async {
    _records
      ..clear()
      ..addEntries(storeEntitlements
          .map((record) => MapEntry(record.transactionId, record)));
    _lastSyncedAt = DateTime.now().toUtc();
  }
}

class OfflinePurchaseService implements PurchaseService {
  @override
  Stream<PurchaseUpdate> get updates => const Stream<PurchaseUpdate>.empty();

  @override
  Future<void> completePurchase(String transactionId) async {}

  @override
  Future<List<StoreProduct>> loadProducts(Set<String> productIds) async =>
      <StoreProduct>[];

  @override
  Future<String> purchase(String productId) async => 'offline';

  @override
  Future<void> restorePurchases() async {}
}
