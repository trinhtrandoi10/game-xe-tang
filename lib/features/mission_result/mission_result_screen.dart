import 'package:flutter/material.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../game/application/snapshots/game_snapshot.dart';
import '../../game/domain/save/save_game.dart';
import '../../shared/widgets/iron_widgets.dart';

class MissionResultScreen extends StatelessWidget {
  const MissionResultScreen(
      {super.key,
      required this.strings,
      required this.profile,
      required this.snapshot,
      required this.onRetry,
      required this.onGarage,
      required this.onMenu});

  final AppStrings strings;
  final GameProfile profile;
  final GameSnapshot snapshot;
  final VoidCallback onRetry;
  final VoidCallback onGarage;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final success = snapshot.phase == GamePhase.completed;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CustomPaint(painter: ResultBackdropPainter(success: success)),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: GorgePanel(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                            success
                                ? Icons.check_circle_outline
                                : Icons.warning_amber_rounded,
                            color: success
                                ? IronGorgeColors.green
                                : IronGorgeColors.red,
                            size: 56),
                        const SizedBox(height: 16),
                        Text(strings.text(success ? 'completed' : 'failed'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: success
                                    ? IronGorgeColors.green
                                    : IronGorgeColors.red,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.3)),
                        const SizedBox(height: 14),
                        Text(
                            strings.text(
                                success ? 'victoryMessage' : 'defeatMessage'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: IronGorgeColors.muted,
                                fontSize: 13,
                                height: 1.45)),
                        const SizedBox(height: 22),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: _ResultStat(
                                    label: strings.text('missionTime'),
                                    value: _formatTime(snapshot.elapsed))),
                            const SizedBox(width: 9),
                            Expanded(
                                child: _ResultStat(
                                    label: strings.text('enemies'),
                                    value:
                                        '${snapshot.enemies.where((enemy) => enemy.isDestroyed).length}')),
                            const SizedBox(width: 9),
                            Expanded(
                                child: _ResultStat(
                                    label: strings.text('reward'),
                                    value: success
                                        ? strings.text('missionReward')
                                        : '—')),
                          ],
                        ),
                        const SizedBox(height: 22),
                        if (success) ...<Widget>[
                          IronButton(
                              label: strings.text('garage'),
                              onPressed: onGarage,
                              filled: true,
                              icon: Icons.build_outlined),
                          const SizedBox(height: 9),
                        ],
                        IronButton(
                            label: strings.text('retry'),
                            onPressed: onRetry,
                            icon: Icons.restart_alt),
                        const SizedBox(height: 9),
                        IronButton(
                            label: strings.text('returnToMenu'),
                            onPressed: onMenu,
                            compact: true,
                            icon: Icons.home_outlined),
                        const SizedBox(height: 15),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${strings.text('parts')}: ${profile.parts}',
                                style: const TextStyle(
                                    color: IronGorgeColors.amber,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
      color: const Color(0xFF17232B),
      child: Column(children: <Widget>[
        Text(label,
            style: const TextStyle(
                color: IronGorgeColors.muted, fontSize: 9, letterSpacing: 1)),
        const SizedBox(height: 5),
        Text(value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: IronGorgeColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w800))
      ]),
    );
  }
}

class ResultBackdropPainter extends CustomPainter {
  const ResultBackdropPainter({required this.success});

  final bool success;

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
                Color(0xFF071217),
                Color(0xFF111417),
                Color(0xFF160F0D)
              ]).createShader(rect));
    final color = success ? IronGorgeColors.green : IronGorgeColors.red;
    final center = Offset(size.width * 0.78, size.height * 0.32);
    canvas.drawCircle(
        center,
        size.height * 0.36,
        Paint()
          ..shader = RadialGradient(
                  colors: <Color>[color.withAlpha(35), Colors.transparent])
              .createShader(
                  Rect.fromCircle(center: center, radius: size.height * 0.36)));
    final paint = Paint()
      ..color = color.withAlpha(42)
      ..strokeWidth = 1;
    for (var i = -5; i < 12; i++) {
      canvas.drawLine(Offset(i * 70.0, 0),
          Offset(i * 70.0 + size.height * 0.45, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ResultBackdropPainter oldDelegate) =>
      oldDelegate.success != success;
}

String _formatTime(double seconds) {
  final value = seconds.floor();
  return '${(value ~/ 60).toString().padLeft(2, '0')}:${(value % 60).toString().padLeft(2, '0')}';
}
