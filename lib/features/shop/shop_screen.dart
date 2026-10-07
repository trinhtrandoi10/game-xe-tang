import 'package:flutter/material.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../game/domain/economy/economy.dart';
import '../../game/domain/save/save_game.dart';
import '../../shared/widgets/iron_widgets.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen(
      {super.key,
      required this.strings,
      required this.profile,
      required this.onBack,
      required this.onBuy,
      this.feedback});

  final AppStrings strings;
  final GameProfile profile;
  final VoidCallback onBack;
  final void Function(CatalogProduct product) onBuy;
  final String? feedback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back,
                          color: IronGorgeColors.cyan)),
                  const SizedBox(width: 4),
                  const Text('04 //',
                      style: TextStyle(
                          color: IronGorgeColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5)),
                  const SizedBox(width: 10),
                  Text(strings.text('shop'),
                      style: const TextStyle(
                          color: IronGorgeColors.text,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2)),
                  const Spacer(),
                  ResourceStrip(
                      parts: profile.parts,
                      data: profile.aresData,
                      titan: profile.titan,
                      dense: true),
                ],
              ),
              const SizedBox(height: 15),
              GorgePanel(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: const Color(0xFF122127),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.wifi_off,
                        color: IronGorgeColors.amber, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(strings.text('storeOffline'),
                            style: const TextStyle(
                                color: IronGorgeColors.text,
                                fontSize: 12,
                                height: 1.35))),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (feedback != null)
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(feedback!,
                        style: const TextStyle(
                            color: IronGorgeColors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w700))),
              if (feedback != null) const SizedBox(height: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 900
                        ? 4
                        : constraints.maxWidth > 570
                            ? 2
                            : 1;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: columns == 1 ? 3.2 : 1.35,
                      ),
                      itemCount: mvpCatalog.length,
                      itemBuilder: (context, index) {
                        final product = mvpCatalog[index];
                        return _ProductCard(
                            strings: strings,
                            product: product,
                            owned: profile.owned(product.id),
                            canBuy: profile.parts >= product.priceParts,
                            onBuy: () => onBuy(product));
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(strings.text('noRealMoney'),
                      style: const TextStyle(
                          color: IronGorgeColors.muted,
                          fontSize: 10,
                          letterSpacing: 0.7))),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard(
      {required this.strings,
      required this.product,
      required this.owned,
      required this.canBuy,
      required this.onBuy});

  final AppStrings strings;
  final CatalogProduct product;
  final int owned;
  final bool canBuy;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final capped = owned >= product.maxOwned;
    return GorgePanel(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            color: IronGorgeColors.cyan.withAlpha(20),
            child: Icon(_iconFor(product.id),
                color: IronGorgeColors.cyan, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(strings.text(product.titleKey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: IronGorgeColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6)),
                const SizedBox(height: 5),
                Text(strings.text(product.descriptionKey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: IronGorgeColors.muted,
                        fontSize: 10,
                        height: 1.25)),
                const SizedBox(height: 6),
                Text('${strings.text('owned')}: $owned / ${product.maxOwned}',
                    style: const TextStyle(
                        color: IronGorgeColors.amber,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IronButton(
            label:
                capped ? strings.text('equipped') : '${product.priceParts} ◈',
            onPressed: capped || !canBuy ? null : onBuy,
            compact: true,
            filled: !capped && canBuy,
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String id) {
    return switch (id) {
      'field_repair_kit' => Icons.medical_services_outlined,
      'ap_crate' => Icons.blur_circular,
      'he_crate' => Icons.local_fire_department_outlined,
      _ => Icons.cloud_outlined,
    };
  }
}
