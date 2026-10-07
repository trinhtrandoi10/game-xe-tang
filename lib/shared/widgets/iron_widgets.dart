import 'package:flutter/material.dart';

import '../../app/theme.dart';

class GorgePanel extends StatelessWidget {
  const GorgePanel(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(18),
      this.color});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? IronGorgeColors.panel.withAlpha(242),
        border: Border.all(color: IronGorgeColors.line),
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: Color(0x44000000), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class IronButton extends StatelessWidget {
  const IronButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = false,
    this.danger = false,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool filled;
  final bool danger;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = danger ? IronGorgeColors.red : IronGorgeColors.cyan;
    return SizedBox(
      height: compact ? 38 : 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon == null
            ? const SizedBox.shrink()
            : Icon(icon, size: compact ? 16 : 18),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          foregroundColor: filled ? IronGorgeColors.background : accent,
          backgroundColor: filled ? accent : Colors.transparent,
          side: BorderSide(
              color: onPressed == null ? IronGorgeColors.line : accent),
          padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 18),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(
      {super.key, required this.eyebrow, required this.title, this.trailing});

  final String eyebrow;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(eyebrow,
                  style: const TextStyle(
                      color: IronGorgeColors.cyan,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2)),
              const SizedBox(height: 5),
              Text(title,
                  style: const TextStyle(
                      color: IronGorgeColors.text,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class ResourceStrip extends StatelessWidget {
  const ResourceStrip(
      {super.key,
      required this.parts,
      required this.data,
      required this.titan,
      this.dense = false});

  final int parts;
  final int data;
  final int titan;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Resource(
            label: '◈',
            value: parts,
            color: IronGorgeColors.amber,
            dense: dense),
        SizedBox(width: dense ? 10 : 16),
        _Resource(
            label: '▣', value: data, color: IronGorgeColors.cyan, dense: dense),
        SizedBox(width: dense ? 10 : 16),
        _Resource(
            label: '◆',
            value: titan,
            color: const Color(0xFFD0D6D8),
            dense: dense),
      ],
    );
  }
}

class _Resource extends StatelessWidget {
  const _Resource(
      {required this.label,
      required this.value,
      required this.color,
      required this.dense});

  final String label;
  final int value;
  final Color color;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: dense ? 12 : 15,
                fontWeight: FontWeight.w900)),
        const SizedBox(width: 5),
        Text('$value',
            style: TextStyle(
                color: IronGorgeColors.text,
                fontSize: dense ? 12 : 14,
                fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class GorgeProgressBar extends StatelessWidget {
  const GorgeProgressBar(
      {super.key,
      required this.value,
      this.color = IronGorgeColors.cyan,
      this.height = 5});

  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ColoredBox(color: IronGorgeColors.line),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0, 1).toDouble(),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class CornerMark extends StatelessWidget {
  const CornerMark({super.key, this.color = IronGorgeColors.cyan});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _CornerMarkPainter(color)),
    );
  }
}

class _CornerMarkPainter extends CustomPainter {
  const _CornerMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(1, 8), const Offset(1, 1), paint);
    canvas.drawLine(const Offset(1, 1), const Offset(8, 1), paint);
    canvas.drawLine(Offset(size.width - 1, size.height - 8),
        Offset(size.width - 1, size.height - 1), paint);
    canvas.drawLine(Offset(size.width - 1, size.height - 1),
        Offset(size.width - 8, size.height - 1), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}
