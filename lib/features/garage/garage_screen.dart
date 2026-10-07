import 'package:flutter/material.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../game/domain/save/save_game.dart';
import '../../shared/widgets/iron_widgets.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen(
      {super.key,
      required this.strings,
      required this.profile,
      required this.onBack,
      required this.onShop,
      required this.onSave});

  final AppStrings strings;
  final GameProfile profile;
  final VoidCallback onBack;
  final VoidCallback onShop;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 820;
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  compact ? 18 : 42, 18, compact ? 18 : 42, 20),
              child: Column(
                children: <Widget>[
                  _Header(
                      strings: strings,
                      title: strings.text('garage'),
                      onBack: onBack,
                      profile: profile),
                  const SizedBox(height: 18),
                  Expanded(
                    child: compact
                        ? SingleChildScrollView(
                            child: _Content(
                                strings: strings,
                                profile: profile,
                                onShop: onShop,
                                onSave: onSave,
                                compact: true))
                        : _Content(
                            strings: strings,
                            profile: profile,
                            onShop: onShop,
                            onSave: onSave,
                            compact: false),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(
      {required this.strings,
      required this.title,
      required this.onBack,
      required this.profile});

  final AppStrings strings;
  final String title;
  final VoidCallback onBack;
  final GameProfile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: IronGorgeColors.cyan)),
        const SizedBox(width: 4),
        Text('03 //',
            style: const TextStyle(
                color: IronGorgeColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5)),
        const SizedBox(width: 10),
        Text(title,
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
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(
      {required this.strings,
      required this.profile,
      required this.onShop,
      required this.onSave,
      required this.compact});

  final AppStrings strings;
  final GameProfile profile;
  final VoidCallback onShop;
  final VoidCallback onSave;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final preview = GorgePanel(
      padding: EdgeInsets.zero,
      color: const Color(0xFF0B1418),
      child: SizedBox(
        height: compact ? 260 : double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const CustomPaint(painter: GarageFloorPainter()),
            CustomPaint(painter: TankPreviewPainter()),
            Positioned(
              left: 18,
              top: 18,
              child: Text('ASSET // T99-STORM',
                  style: const TextStyle(
                      color: IronGorgeColors.muted,
                      fontSize: 10,
                      letterSpacing: 1.3)),
            ),
            Positioned(
              right: 18,
              bottom: 16,
              child: Text('READY // OFFLINE',
                  style: const TextStyle(
                      color: IronGorgeColors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4)),
            ),
          ],
        ),
      ),
    );

    final detail = GorgePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(strings.text('t99Name'),
              style: const TextStyle(
                  color: IronGorgeColors.amber,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4)),
          const SizedBox(height: 5),
          Text(strings.text('t99Class'),
              style: const TextStyle(
                  color: IronGorgeColors.muted,
                  fontSize: 10,
                  letterSpacing: 1.6)),
          const SizedBox(height: 24),
          _StatLine(
              label: strings.text('speed'),
              value: 0.76,
              valueLabel: '16.0 M/S',
              color: IronGorgeColors.cyan),
          const SizedBox(height: 13),
          _StatLine(
              label: strings.text('armor'),
              value: 0.68,
              valueLabel: '180 / 95 / 55',
              color: IronGorgeColors.green),
          const SizedBox(height: 13),
          _StatLine(
              label: strings.text('firepower'),
              value: 0.82,
              valueLabel: '125 MM // AP / HE',
              color: IronGorgeColors.amber),
          const SizedBox(height: 22),
          const Divider(color: IronGorgeColors.line, height: 1),
          const SizedBox(height: 16),
          Text(strings.text('equipment'),
              style: const TextStyle(
                  color: IronGorgeColors.cyan,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.8)),
          const SizedBox(height: 10),
          _EquipmentRow(
              label: strings.text('repairKit'),
              value: '${profile.owned('field_repair_kit')}x'),
          _EquipmentRow(
              label: strings.text('apCrate'),
              value: '${profile.owned('ap_crate')}x'),
          _EquipmentRow(
              label: strings.text('heCrate'),
              value: '${profile.owned('he_crate')}x'),
          const Spacer(),
          Row(
            children: <Widget>[
              Expanded(
                  child: IronButton(
                      label: strings.text('shop'),
                      onPressed: onShop,
                      compact: true,
                      icon: Icons.inventory_2_outlined)),
              const SizedBox(width: 10),
              Expanded(
                  child: IronButton(
                      label: strings.text('saveStatus'),
                      onPressed: onSave,
                      compact: true,
                      icon: Icons.save_outlined)),
            ],
          ),
        ],
      ),
    );

    if (compact) {
      return Column(children: <Widget>[
        SizedBox(height: 300, child: preview),
        const SizedBox(height: 14),
        SizedBox(height: 470, child: detail)
      ]);
    }
    return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(flex: 6, child: preview),
          const SizedBox(width: 16),
          Expanded(flex: 4, child: detail)
        ]);
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine(
      {required this.label,
      required this.value,
      required this.valueLabel,
      required this.color});

  final String label;
  final double value;
  final String valueLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Text(label,
              style: const TextStyle(
                  color: IronGorgeColors.muted,
                  fontSize: 10,
                  letterSpacing: 1.4)),
          const Spacer(),
          Text(valueLabel,
              style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1))
        ]),
        const SizedBox(height: 7),
        GorgeProgressBar(value: value, color: color, height: 6),
      ],
    );
  }
}

class _EquipmentRow extends StatelessWidget {
  const _EquipmentRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(children: <Widget>[
        Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: IronGorgeColors.text, fontSize: 11))),
        Text(value,
            style: const TextStyle(
                color: IronGorgeColors.amber,
                fontSize: 11,
                fontWeight: FontWeight.w800))
      ]),
    );
  }
}

class GarageFloorPainter extends CustomPainter {
  const GarageFloorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0x223D7378)
      ..strokeWidth = 1;
    for (var x = -size.height; x < size.width + size.height; x += 38) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), line);
    }
    for (var y = 28.0; y < size.height; y += 38) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    final strip = Paint()
      ..color = IronGorgeColors.amber.withAlpha(120)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, size.height * 0.82),
        Offset(size.width, size.height * 0.82), strip);
  }

  @override
  bool shouldRepaint(covariant GarageFloorPainter oldDelegate) => false;
}

class TankPreviewPainter extends CustomPainter {
  const TankPreviewPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.58);
    final scale = (size.shortestSide / 310).clamp(0.7, 1.4).toDouble();
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    canvas.rotate(-0.08);
    final shadow = Paint()..color = Colors.black.withAlpha(100);
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, 56), width: 330, height: 80),
        shadow);
    final tracks = Paint()..color = const Color(0xFF121C1F);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(-142, -58, 52, 170), const Radius.circular(18)),
        tracks);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(90, -58, 52, 170), const Radius.circular(18)),
        tracks);
    final hull = Path()
      ..moveTo(-112, 70)
      ..lineTo(-96, -54)
      ..lineTo(99, -54)
      ..lineTo(116, 70)
      ..close();
    canvas.drawPath(hull, Paint()..color = const Color(0xFF30494A));
    canvas.drawPath(
        hull,
        Paint()
          ..color = IronGorgeColors.cyan.withAlpha(150)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    final top = Path()
      ..moveTo(-74, 22)
      ..lineTo(-54, -42)
      ..lineTo(55, -42)
      ..lineTo(76, 22)
      ..lineTo(25, 50)
      ..lineTo(-25, 50)
      ..close();
    canvas.drawPath(top, Paint()..color = const Color(0xFF3E5C59));
    canvas.drawPath(
        top,
        Paint()
          ..color = IronGorgeColors.amber.withAlpha(160)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.drawRect(const Rect.fromLTWH(50, -16, 190, 18),
        Paint()..color = const Color(0xFF365051));
    canvas.drawRect(const Rect.fromLTWH(50, -16, 190, 3),
        Paint()..color = IronGorgeColors.amber);
    for (final x in <double>[-112, -58, -4, 50, 104]) {
      canvas.drawCircle(
          Offset(x, 64), 20, Paint()..color = const Color(0xFF0B1214));
      canvas.drawCircle(
          Offset(x, 64), 9, Paint()..color = const Color(0xFF4A6667));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TankPreviewPainter oldDelegate) => false;
}
