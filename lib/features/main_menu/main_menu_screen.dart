import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../game/domain/save/save_game.dart';
import '../../shared/widgets/iron_widgets.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({
    super.key,
    required this.strings,
    required this.profile,
    required this.hasSave,
    required this.onContinue,
    required this.onNewMission,
    required this.onGarage,
    required this.onShop,
    required this.onSettings,
  });

  final AppStrings strings;
  final GameProfile profile;
  final bool hasSave;
  final VoidCallback onContinue;
  final VoidCallback onNewMission;
  final VoidCallback onGarage;
  final VoidCallback onShop;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const CustomPaint(painter: HangarBackdropPainter()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 800;
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: compact ? 22 : 54,
                          vertical: compact ? 18 : 34),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const CornerMark(),
                          const SizedBox(width: 12),
                          Text(strings.text('offline'),
                              style: const TextStyle(
                                  color: IronGorgeColors.green,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2)),
                          const Spacer(),
                          ResourceStrip(
                              parts: profile.parts,
                              data: profile.aresData,
                              titan: profile.titan,
                              dense: true),
                          const SizedBox(width: 18),
                          IconButton(
                              onPressed: onSettings,
                              icon: const Icon(Icons.tune,
                                  color: IronGorgeColors.muted),
                              tooltip: strings.text('settings')),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 620),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(strings.appSubtitle,
                                style: const TextStyle(
                                    color: IronGorgeColors.amber,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 3)),
                            const SizedBox(height: 12),
                            Text(
                              strings.appTitle,
                              style: TextStyle(
                                color: IronGorgeColors.text,
                                fontSize: compact ? 34 : 52,
                                fontWeight: FontWeight.w900,
                                height: 0.98,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(strings.text('missionBrief'),
                                style: const TextStyle(
                                    color: IronGorgeColors.muted,
                                    fontSize: 14,
                                    height: 1.5)),
                            const SizedBox(height: 24),
                            Row(
                              children: <Widget>[
                                if (hasSave &&
                                    profile.missionStage !=
                                        'complete') ...<Widget>[
                                  Expanded(
                                      child: IronButton(
                                          label:
                                              strings.text('continueCampaign'),
                                          onPressed: onContinue,
                                          filled: true,
                                          icon: Icons.play_arrow)),
                                  const SizedBox(width: 10),
                                ],
                                Expanded(
                                    child: IronButton(
                                        label: strings.text('newMission'),
                                        onPressed: onNewMission,
                                        icon: Icons.bolt)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: IronButton(
                                        label: strings.text('garage'),
                                        onPressed: onGarage,
                                        compact: true,
                                        icon: Icons.build_outlined)),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: IronButton(
                                        label: strings.text('shop'),
                                        onPressed: onShop,
                                        compact: true,
                                        icon: Icons.inventory_2_outlined)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                              width: 7, height: 7, color: IronGorgeColors.cyan),
                          const SizedBox(width: 8),
                          Text(strings.text('saveStatus'),
                              style: const TextStyle(
                                  color: IronGorgeColors.muted,
                                  fontSize: 10,
                                  letterSpacing: 1.5)),
                          const Spacer(),
                          const Text('BUILD 0.1 // MVP SPIKE',
                              style: TextStyle(
                                  color: IronGorgeColors.line,
                                  fontSize: 10,
                                  letterSpacing: 1.4)),
                        ],
                      ),
                      ],
                    ),
                  ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HangarBackdropPainter extends CustomPainter {
  const HangarBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
        rect,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFF09131A),
              IronGorgeColors.background,
              Color(0xFF10100D)
            ],
          ).createShader(rect));

    final gridPaint = Paint()
      ..color = const Color(0x163D6A71)
      ..strokeWidth = 1;
    const grid = 48.0;
    for (var x = 0.0; x < size.width + grid; x += grid) {
      canvas.drawLine(
          Offset(x, 0), Offset(x - size.height * 0.18, size.height), gridPaint);
    }
    for (var y = 0.0; y < size.height; y += grid) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final glow = Paint()
      ..shader = RadialGradient(
        colors: <Color>[IronGorgeColors.cyan.withAlpha(45), Colors.transparent],
      ).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.8, size.height * 0.32),
          radius: size.height * 0.72));
    canvas.drawRect(rect, glow);

    final tankCenter = Offset(size.width * 0.75, size.height * 0.64);
    canvas.save();
    canvas.translate(tankCenter.dx, tankCenter.dy);
    canvas.rotate(-0.12);
    final tank = Path()
      ..moveTo(-190, 72)
      ..lineTo(-130, -55)
      ..lineTo(105, -70)
      ..lineTo(190, 58)
      ..close();
    canvas.drawPath(tank, Paint()..color = const Color(0xFF1B2B30));
    canvas.drawPath(
        tank,
        Paint()
          ..color = IronGorgeColors.cyan.withAlpha(80)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    final turret = Path()
      ..moveTo(-58, 12)
      ..lineTo(-38, -47)
      ..lineTo(65, -45)
      ..lineTo(80, 15)
      ..lineTo(18, 42)
      ..close();
    canvas.drawPath(turret, Paint()..color = const Color(0xFF263E42));
    canvas.drawPath(
        turret,
        Paint()
          ..color = IronGorgeColors.amber.withAlpha(115)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    canvas.drawRect(Rect.fromLTWH(56, -12, 230, 18),
        Paint()..color = const Color(0xFF243A3E));
    canvas.drawRect(Rect.fromLTWH(56, -12, 230, 2),
        Paint()..color = IronGorgeColors.amber.withAlpha(180));
    for (var i = 0; i < 5; i++) {
      final wheelX = -132 + i * 64.0;
      canvas.drawCircle(
          Offset(wheelX, 58), 25, Paint()..color = const Color(0xFF0D171A));
      canvas.drawCircle(
          Offset(wheelX, 58), 12, Paint()..color = const Color(0xFF385058));
    }
    canvas.restore();

    final scanPaint = Paint()
      ..color = IronGorgeColors.cyan.withAlpha(85)
      ..strokeWidth = 1;
    final scanY = size.height *
        (0.2 +
            (math.sin(DateTime.now().millisecondsSinceEpoch / 900) + 1) * 0.15);
    canvas.drawLine(
        Offset(size.width * 0.52, scanY), Offset(size.width, scanY), scanPaint);
  }

  @override
  bool shouldRepaint(covariant HangarBackdropPainter oldDelegate) => true;
}
