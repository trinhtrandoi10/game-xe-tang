class CatalogProduct {
  const CatalogProduct({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.priceParts,
    required this.maxOwned,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final int priceParts;
  final int maxOwned;
}

const mvpCatalog = <CatalogProduct>[
  CatalogProduct(
    id: 'field_repair_kit',
    titleKey: 'repairKit',
    descriptionKey: 'repairKitDescription',
    priceParts: 150,
    maxOwned: 10,
  ),
  CatalogProduct(
    id: 'ap_crate',
    titleKey: 'apCrate',
    descriptionKey: 'apCrateDescription',
    priceParts: 120,
    maxOwned: 10,
  ),
  CatalogProduct(
    id: 'he_crate',
    titleKey: 'heCrate',
    descriptionKey: 'heCrateDescription',
    priceParts: 100,
    maxOwned: 10,
  ),
  CatalogProduct(
    id: 'smoke_grenade',
    titleKey: 'smokeGrenade',
    descriptionKey: 'smokeGrenadeDescription',
    priceParts: 90,
    maxOwned: 10,
  ),
];

class ShopResult {
  const ShopResult({required this.success, required this.messageKey});

  final bool success;
  final String messageKey;
}

ShopResult buyProduct({
  required Map<String, int> inventory,
  required CatalogProduct product,
  required int parts,
}) {
  final owned = inventory[product.id] ?? 0;
  if (owned >= product.maxOwned || parts < product.priceParts) {
    return const ShopResult(success: false, messageKey: 'notEnoughParts');
  }
  inventory[product.id] = owned + 1;
  return const ShopResult(success: true, messageKey: 'purchaseSuccess');
}
