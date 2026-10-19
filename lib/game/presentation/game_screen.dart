import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../application/game_session.dart';
import '../application/snapshots/game_snapshot.dart';
import '../domain/ai/ai.dart';
import '../domain/combat/combat.dart';
import '../domain/mission/mission.dart';
import '../../core/math/game_vector.dart';
import '../../shared/widgets/iron_widgets.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.session,
    required this.strings,
    required this.onExit,
    required this.onResult,
  });

  final GameSession session;
  final AppStrings strings;
  final VoidCallback onExit;
  final VoidCallback onResult;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameSnapshot _snapshot;
  Offset _joystick = Offset.zero;
  Offset _joystickOrigin = Offset.zero;
  int _controlSide = 0;

  static const double _joystickTouchRadius = 62;
  static const double _joystickInputRadius = 102;
  static const double _joystickBottom = 26;
  static const double _joystickDeadZone = 0.08;

  @override
  void initState() {
    super.initState();
    _snapshot = widget.session.snapshot;
    widget.session.addListener(_onSessionChanged);
    widget.session.start();
  }

  @override
  void didUpdateWidget(covariant GameScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session != widget.session) {
      oldWidget.session.removeListener(_onSessionChanged);
      _snapshot = widget.session.snapshot;
      widget.session.addListener(_onSessionChanged);
      widget.session.start();
    }
  }

  @override
  void dispose() {
    widget.session.removeListener(_onSessionChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    if (!mounted) return;
    setState(() => _snapshot = widget.session.snapshot);
  }

  void _updateJoystick(Offset delta) {
    final value = Offset(
      delta.dx / _joystickInputRadius,
      delta.dy / _joystickInputRadius,
    );
    final magnitude = value.distance;
    final normalized = magnitude > 1 ? value / magnitude : value;
    final normalizedMagnitude = normalized.distance;
    final limited = normalizedMagnitude <= _joystickDeadZone
        ? Offset.zero
        : normalized *
              ((normalizedMagnitude - _joystickDeadZone) /
                  (1 - _joystickDeadZone));
    setState(() => _joystick = limited);
    widget.session.setDirectionalMovement(x: limited.dx, z: limited.dy);
  }

  void _endJoystick() {
    setState(() => _joystick = Offset.zero);
    widget.session.setDirectionalMovement(x: 0, z: 0);
  }

  void _aimAt(Offset position, Offset tankCenter) {
    final direction = position - tankCenter;
    if (direction.distanceSquared < 64) return;
    widget.session.aimAt(math.atan2(direction.dx, direction.dy));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (details) {
                    final joystickCenter = Offset(
                      16 + 85,
                      constraints.maxHeight - _joystickBottom - 85,
                    );
                    if ((details.localPosition - joystickCenter).distance <=
                        _joystickTouchRadius) {
                      _controlSide = 1;
                      _joystickOrigin = joystickCenter;
                      _updateJoystick(details.localPosition - _joystickOrigin);
                    } else {
                      final tankCenter = BattlefieldPainter.playerCenter(
                        constraints.biggest,
                      );
                      final aimDirection = GameVector.fromHeading(
                        _snapshot.turretHeading,
                      );
                      final reticle =
                          tankCenter +
                          Offset(aimDirection.x, aimDirection.z) *
                              BattlefieldPainter.aimRadius;
                      _controlSide =
                          (details.localPosition - reticle).distance <= 30
                          ? 2
                          : 0;
                    }
                  },
                  onPanUpdate: (details) {
                    if (_controlSide == 1) {
                      _updateJoystick(details.localPosition - _joystickOrigin);
                    } else if (_controlSide == 2) {
                      _aimAt(
                        details.localPosition,
                        BattlefieldPainter.playerCenter(constraints.biggest),
                      );
                    }
                  },
                  onPanEnd: (_) {
                    if (_controlSide == 1) _endJoystick();
                    _controlSide = 0;
                  },
                  onPanCancel: () {
                    if (_controlSide == 1) _endJoystick();
                    _controlSide = 0;
                  },
                  child: CustomPaint(painter: BattlefieldPainter(_snapshot)),
                ),
                _TopHud(
                  snapshot: _snapshot,
                  strings: widget.strings,
                  onPause: widget.session.pause,
                ),
                _MissionHud(snapshot: _snapshot, strings: widget.strings),
                if (_snapshot.eventMessage != null)
                  Positioned(
                    top: 126,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _EventBanner(message: _snapshot.eventMessage!),
                    ),
                  ),
                Positioned(
                  right: 18,
                  top: 74,
                  child: SizedBox(
                    width: 112,
                    height: 88,
                    child: CustomPaint(painter: MiniMapPainter(_snapshot)),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: _joystickBottom,
                  width: 170,
                  height: 170,
                  child: IgnorePointer(
                    ignoring: true,
                    child: CustomPaint(painter: JoystickPainter(_joystick)),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 18,
                  child: _ActionControls(
                    strings: widget.strings,
                    ammo: _snapshot.selectedAmmo,
                    reloadRatio:
                        _snapshot.reloadRemaining / _snapshot.reloadDuration,
                    onFire: widget.session.fire,
                    onSwitchAmmo: widget.session.switchAmmo,
                    onRepair: widget.session.repair,
                    onLock: widget.session.lockTarget,
                  ),
                ),
                Positioned(
                  left: 18,
                  bottom: 7,
                  child: Text(
                    widget.strings.text('touchHint'),
                    style: const TextStyle(
                      color: Color(0xAAE8EFF0),
                      fontSize: 9,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                if (_snapshot.phase == GamePhase.paused)
                  _PauseOverlay(
                    strings: widget.strings,
                    onResume: widget.session.resume,
                    onRestart: widget.session.restart,
                    onExit: widget.onExit,
                  ),
                if (_snapshot.phase == GamePhase.completed ||
                    _snapshot.phase == GamePhase.failed)
                  _ResultOverlay(
                    snapshot: _snapshot,
                    strings: widget.strings,
                    onResult: widget.onResult,
                    onRetry: widget.session.restart,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopHud extends StatelessWidget {
  const _TopHud({
    required this.snapshot,
    required this.strings,
    required this.onPause,
  });

  final GameSnapshot snapshot;
  final AppStrings strings;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final health = (snapshot.playerHealth / snapshot.playerMaxHealth)
        .clamp(0, 1)
        .toDouble();
    return Positioned(
      left: 16,
      right: 16,
      top: 12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 196,
            child: GorgePanel(
              padding: const EdgeInsets.all(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text(
                        'T-99',
                        style: TextStyle(
                          color: IronGorgeColors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${snapshot.playerHealth.round()} / ${snapshot.playerMaxHealth.round()}',
                        style: const TextStyle(
                          color: IronGorgeColors.text,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  GorgeProgressBar(
                    value: health,
                    color: health > 0.35
                        ? IronGorgeColors.green
                        : IronGorgeColors.red,
                    height: 7,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      _ModuleLight(
                        label: 'L',
                        disabled: snapshot.leftTrackDisabled,
                      ),
                      const SizedBox(width: 7),
                      _ModuleLight(
                        label: 'R',
                        disabled: snapshot.rightTrackDisabled,
                      ),
                      const SizedBox(width: 7),
                      _ModuleLight(
                        label: 'E',
                        disabled: snapshot.engineDisabled,
                      ),
                      const Spacer(),
                      Text(
                        strings.text('health'),
                        style: const TextStyle(
                          color: IronGorgeColors.muted,
                          fontSize: 9,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: <Widget>[
                      Text(
                        strings.text('ammo'),
                        style: const TextStyle(
                          color: IronGorgeColors.muted,
                          fontSize: 9,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        snapshot.selectedAmmo == AmmoType.ap
                            ? strings.text('ap')
                            : strings.text('he'),
                        style: const TextStyle(
                          color: IronGorgeColors.amber,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '${snapshot.ammo}',
                        style: const TextStyle(
                          color: IronGorgeColors.text,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        snapshot.reloadRemaining > 0
                            ? strings.text('reload')
                            : strings.text('ready'),
                        style: TextStyle(
                          color: snapshot.reloadRemaining > 0
                              ? IronGorgeColors.amber
                              : IronGorgeColors.green,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                  if (snapshot.reloadRemaining > 0) ...<Widget>[
                    const SizedBox(height: 5),
                    GorgeProgressBar(
                      value:
                          1 -
                          snapshot.reloadRemaining / snapshot.reloadDuration,
                      color: IronGorgeColors.amber,
                      height: 3,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 132,
            child: GorgePanel(
              padding: const EdgeInsets.all(9),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.radar,
                    color: IronGorgeColors.cyan,
                    size: 17,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${strings.text('enemies')}  ${snapshot.aliveEnemies}',
                      style: const TextStyle(
                        color: IronGorgeColors.text,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onPause,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 24,
                      height: 24,
                    ),
                    icon: const Icon(
                      Icons.pause,
                      color: IronGorgeColors.amber,
                      size: 19,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleLight extends StatelessWidget {
  const _ModuleLight({required this.label, required this.disabled});

  final String label;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 15,
      alignment: Alignment.center,
      color: disabled
          ? IronGorgeColors.red.withAlpha(50)
          : IronGorgeColors.green.withAlpha(40),
      child: Text(
        label,
        style: TextStyle(
          color: disabled ? IronGorgeColors.red : IronGorgeColors.green,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EventBanner extends StatelessWidget {
  const _EventBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xDD101820),
      child: Text(
        message,
        style: const TextStyle(
          color: IronGorgeColors.amber,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _MissionHud extends StatelessWidget {
  const _MissionHud({required this.snapshot, required this.strings});

  final GameSnapshot snapshot;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.missionStage == MissionStage.defendRadar
        ? 1 - snapshot.defendRemaining / 45
        : snapshot.objectiveProgress;
    final sub = switch (snapshot.missionStage) {
      MissionStage.reachTown =>
        '${_distance(snapshot.playerPosition, GameSession.townPosition)} M  //  ${strings.text('townBinhMinh')}',
      MissionStage.destroyScouts =>
        '${snapshot.destroyedScouts} / 2  //  ${strings.text('enemies')}',
      MissionStage.captureRadar =>
        '${(snapshot.captureProgress * 100).round()}%  //  ${strings.text('radarNam1')}',
      MissionStage.defendRadar =>
        '${snapshot.defendRemaining.ceil()} S  //  ${strings.text('radarNam1')}',
      MissionStage.complete || MissionStage.failed => '',
    };
    return Positioned(
      top: 14,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 310,
          child: GorgePanel(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Text(
                      'OBJECTIVE // 01',
                      style: TextStyle(
                        color: IronGorgeColors.cyan,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatTime(snapshot.elapsed),
                      style: const TextStyle(
                        color: IronGorgeColors.muted,
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  strings.text(_objectiveKey(snapshot.missionStage)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: IronGorgeColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                if (sub.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    sub,
                    style: const TextStyle(
                      color: IronGorgeColors.amber,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                GorgeProgressBar(
                  value: progress,
                  color: snapshot.missionStage == MissionStage.defendRadar
                      ? IronGorgeColors.amber
                      : IronGorgeColors.cyan,
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionControls extends StatelessWidget {
  const _ActionControls({
    required this.strings,
    required this.ammo,
    required this.reloadRatio,
    required this.onFire,
    required this.onSwitchAmmo,
    required this.onRepair,
    required this.onLock,
  });

  final AppStrings strings;
  final AmmoType ammo;
  final double reloadRatio;
  final VoidCallback onFire;
  final VoidCallback onSwitchAmmo;
  final VoidCallback onRepair;
  final VoidCallback onLock;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _GameButton(
              icon: Icons.gps_fixed,
              label: strings.text('lock'),
              color: IronGorgeColors.cyan,
              onTap: onLock,
            ),
            const SizedBox(height: 8),
            _GameButton(
              icon: Icons.build_outlined,
              label: strings.text('repair'),
              color: IronGorgeColors.green,
              onTap: onRepair,
            ),
          ],
        ),
        const SizedBox(width: 8),
        _GameButton(
          icon: Icons.swap_horiz,
          label:
              '${strings.text('switchAmmo')}  ${ammo == AmmoType.ap ? strings.text('he') : strings.text('ap')}',
          color: IronGorgeColors.amber,
          onTap: onSwitchAmmo,
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onFire,
          child: Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              color: IronGorgeColors.red.withAlpha(205),
              border: Border.all(color: IronGorgeColors.amber, width: 2),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  value: reloadRatio.clamp(0, 1).toDouble(),
                  color: IronGorgeColors.amber,
                  backgroundColor: Colors.transparent,
                  strokeWidth: 4,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.flash_on, color: Colors.white, size: 24),
                    Text(
                      strings.text('fire'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GameButton extends StatelessWidget {
  const _GameButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 66,
        height: 48,
        decoration: BoxDecoration(
          color: IronGorgeColors.panel.withAlpha(235),
          border: Border.all(color: color.withAlpha(170)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PauseOverlay extends StatelessWidget {
  const _PauseOverlay({
    required this.strings,
    required this.onResume,
    required this.onRestart,
    required this.onExit,
  });

  final AppStrings strings;
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xDD070B10),
        child: Center(
          child: SizedBox(
            width: 320,
            child: GorgePanel(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    strings.text('pause'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: IronGorgeColors.amber,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  IronButton(
                    label: strings.text('resumeMission'),
                    onPressed: onResume,
                    filled: true,
                    icon: Icons.play_arrow,
                  ),
                  const SizedBox(height: 9),
                  IronButton(
                    label: strings.text('restartMission'),
                    onPressed: onRestart,
                    icon: Icons.restart_alt,
                  ),
                  const SizedBox(height: 9),
                  IronButton(
                    label: strings.text('exitMission'),
                    onPressed: onExit,
                    danger: true,
                    icon: Icons.exit_to_app,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultOverlay extends StatelessWidget {
  const _ResultOverlay({
    required this.snapshot,
    required this.strings,
    required this.onResult,
    required this.onRetry,
  });

  final GameSnapshot snapshot;
  final AppStrings strings;
  final VoidCallback onResult;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final success = snapshot.phase == GamePhase.completed;
    return Positioned.fill(
      child: ColoredBox(
        color: const Color(0xDD070B10),
        child: Center(
          child: SizedBox(
            width: 380,
            child: GorgePanel(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    success
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_rounded,
                    color: success
                        ? IronGorgeColors.green
                        : IronGorgeColors.red,
                    size: 42,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    strings.text(success ? 'completed' : 'failed'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: success
                          ? IronGorgeColors.green
                          : IronGorgeColors.red,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    strings.text(success ? 'victoryMessage' : 'defeatMessage'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: IronGorgeColors.muted,
                      height: 1.45,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  IronButton(
                    label: success
                        ? strings.text('continueCampaign')
                        : strings.text('retry'),
                    onPressed: success ? onResult : onRetry,
                    filled: true,
                    icon: success ? Icons.arrow_forward : Icons.restart_alt,
                  ),
                  const SizedBox(height: 8),
                  IronButton(
                    label: strings.text('returnToMenu'),
                    onPressed: onResult,
                    compact: true,
                    icon: Icons.home_outlined,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JoystickPainter extends CustomPainter {
  const JoystickPainter(this.value);

  final Offset value;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.37;
    canvas.drawCircle(
      center,
      radius + 18,
      Paint()..color = const Color(0x55101820),
    );
    canvas.drawCircle(
      center,
      radius + 18,
      Paint()
        ..color = IronGorgeColors.cyan.withAlpha(90)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xAA17232B)
        ..style = PaintingStyle.fill,
    );
    final knobCenter =
        center +
        Offset(value.dx * (radius + 6) * 1.2, value.dy * (radius + 6) * 1.2);
    canvas.drawCircle(
      knobCenter,
      26,
      Paint()..color = IronGorgeColors.cyan.withAlpha(180),
    );
    canvas.drawCircle(
      knobCenter,
      26,
      Paint()
        ..color = IronGorgeColors.text.withAlpha(160)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final text = TextPainter(
      text: const TextSpan(
        text: 'MOVE',
        style: TextStyle(
          color: Color(0x99E8EFF0),
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, center - Offset(text.width / 2, text.height / 2));
  }

  @override
  bool shouldRepaint(covariant JoystickPainter oldDelegate) =>
      oldDelegate.value != value;
}

class BattlefieldPainter extends CustomPainter {
  BattlefieldPainter(this.snapshot);

  static const double aimRadius = 90;

  static Offset playerCenter(Size size) =>
      Offset(size.width * 0.5, size.height * 0.54);

  final GameSnapshot snapshot;

  late double scale;
  late Offset center;

  Offset worldToScreen(GameVector point) {
    return center +
        Offset(
          (point.x - snapshot.playerPosition.x) * scale,
          (point.z - snapshot.playerPosition.z) * scale,
        );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    center = playerCenter(size);
    scale = (size.shortestSide / 475).clamp(0.55, 1.05).toDouble();
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF162A2B),
            Color(0xFF0C1718),
            Color(0xFF11120F),
          ],
        ).createShader(rect),
    );
    _drawTerrain(canvas, size);
    _drawRoads(canvas);
    _drawLandmarks(canvas);
    for (final effect in snapshot.effects) {
      _drawEffect(canvas, effect);
    }
    for (final projectile in snapshot.projectiles) {
      _drawProjectile(canvas, projectile);
    }
    for (final enemy in snapshot.enemies) {
      if (!enemy.isDestroyed) _drawEnemy(canvas, enemy);
    }
    _drawPlayer(canvas);
    _drawAim(canvas);
  }

  void _drawTerrain(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0x263B6560)
      ..strokeWidth = 1;
    final worldLeft = snapshot.playerPosition.x - size.width / scale / 2 - 50;
    final worldTop = snapshot.playerPosition.z - size.height / scale / 2 - 50;
    for (
      var x = (worldLeft / 50).floor() * 50.0;
      x < worldLeft + size.width / scale + 100;
      x += 50
    ) {
      canvas.drawLine(
        worldToScreen(GameVector(x, worldTop)),
        worldToScreen(GameVector(x, worldTop + size.height / scale + 100)),
        grid,
      );
    }
    for (
      var z = (worldTop / 50).floor() * 50.0;
      z < worldTop + size.height / scale + 100;
      z += 50
    ) {
      canvas.drawLine(
        worldToScreen(GameVector(worldLeft, z)),
        worldToScreen(GameVector(worldLeft + size.width / scale + 100, z)),
        grid,
      );
    }
    final ridge = Paint()
      ..color = const Color(0x335D7560)
      ..style = PaintingStyle.fill;
    for (var i = -2; i < 5; i++) {
      final x = i * 170.0 - 120;
      final path = Path()
        ..moveTo(
          worldToScreen(GameVector(x, -500)).dx,
          worldToScreen(GameVector(x, -500)).dy,
        )
        ..lineTo(
          worldToScreen(GameVector(x + 62, -500)).dx,
          worldToScreen(GameVector(x + 62, -500)).dy,
        )
        ..lineTo(
          worldToScreen(GameVector(x + 128, 500)).dx,
          worldToScreen(GameVector(x + 128, 500)).dy,
        )
        ..lineTo(
          worldToScreen(GameVector(x + 64, 500)).dx,
          worldToScreen(GameVector(x + 64, 500)).dy,
        )
        ..close();
      canvas.drawPath(path, ridge);
    }
  }

  void _drawRoads(Canvas canvas) {
    final road = Paint()
      ..color = const Color(0x443B4540)
      ..strokeWidth = 25 * scale
      ..style = PaintingStyle.stroke;
    final edge = Paint()
      ..color = const Color(0x665C5B48)
      ..strokeWidth = 2 * scale
      ..style = PaintingStyle.stroke;
    final points = <GameVector>[
      const GameVector(-410, 280),
      const GameVector(-190, 170),
      const GameVector(-10, -10),
      const GameVector(150, -12),
      GameSession.radarPosition,
    ];
    final path = Path()
      ..moveTo(worldToScreen(points.first).dx, worldToScreen(points.first).dy);
    for (final point in points.skip(1)) {
      path.lineTo(worldToScreen(point).dx, worldToScreen(point).dy);
    }
    canvas.drawPath(path, road);
    canvas.drawPath(path, edge);
  }

  void _drawLandmarks(Canvas canvas) {
    final town = worldToScreen(GameSession.townPosition);
    final radar = worldToScreen(GameSession.radarPosition);
    final ringColor =
        snapshot.missionStage == MissionStage.captureRadar ||
            snapshot.missionStage == MissionStage.defendRadar
        ? IronGorgeColors.cyan
        : IronGorgeColors.muted;
    canvas.drawCircle(
      radar,
      GameSession.radarRadius * scale,
      Paint()..color = ringColor.withAlpha(22),
    );
    canvas.drawCircle(
      radar,
      GameSession.radarRadius * scale,
      Paint()
        ..color = ringColor.withAlpha(190)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(radar, 10, Paint()..color = ringColor);
    canvas.drawLine(
      radar + const Offset(-18, 0),
      radar + const Offset(18, 0),
      Paint()
        ..color = ringColor.withAlpha(150)
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      radar + const Offset(0, -18),
      radar + const Offset(0, 18),
      Paint()
        ..color = ringColor.withAlpha(150)
        ..strokeWidth = 1,
    );
    _drawLabel(
      canvas,
      'NAM-1',
      radar + const Offset(0, -GameSession.radarRadius * 0.9),
      color: ringColor,
    );

    final townPaint = Paint()..color = const Color(0xFF6D6652);
    for (var i = 0; i < 5; i++) {
      final offset = Offset(
        (i % 3 - 1) * 22 * scale,
        (i ~/ 3 - 1) * 20 * scale,
      );
      final building = Rect.fromCenter(
        center: town + offset,
        width: 20 * scale,
        height: 14 * scale,
      );
      canvas.drawRect(building, townPaint);
      canvas.drawRect(
        building,
        Paint()
          ..color = IronGorgeColors.amber.withAlpha(75)
          ..style = PaintingStyle.stroke,
      );
    }
    _drawLabel(
      canvas,
      'BINH MINH',
      town + Offset(0, 48 * scale),
      color: IronGorgeColors.amber,
    );

    final target = worldToScreen(snapshot.targetPosition);
    if (snapshot.missionStage != MissionStage.complete &&
        snapshot.missionStage != MissionStage.failed) {
      final pulse = 13 + math.sin(snapshot.elapsed * 4) * 3;
      canvas.drawCircle(
        target,
        pulse,
        Paint()
          ..color = IronGorgeColors.cyan.withAlpha(35)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        target,
        pulse,
        Paint()
          ..color = IronGorgeColors.cyan.withAlpha(210)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      canvas.drawLine(
        target + const Offset(-22, 0),
        target + const Offset(22, 0),
        Paint()
          ..color = IronGorgeColors.cyan.withAlpha(160)
          ..strokeWidth = 1,
      );
      canvas.drawLine(
        target + const Offset(0, -22),
        target + const Offset(0, 22),
        Paint()
          ..color = IronGorgeColors.cyan.withAlpha(160)
          ..strokeWidth = 1,
      );
    }
  }

  void _drawEnemy(Canvas canvas, EnemySnapshot enemy) {
    final color = enemy.archetype == EnemyArchetype.scout
        ? IronGorgeColors.red
        : const Color(0xFFC17F56);
    final position = worldToScreen(enemy.position);
    _drawTank(
      canvas,
      position,
      enemy.heading,
      enemy.turretHeading,
      color,
      enemy.archetype == EnemyArchetype.scout ? 0.72 : 0.92,
      false,
    );
    final barWidth = enemy.archetype == EnemyArchetype.scout ? 26.0 : 34.0;
    canvas.drawRect(
      Rect.fromCenter(
        center: position + const Offset(0, -22),
        width: barWidth,
        height: 3,
      ),
      Paint()..color = const Color(0xAA241A1B),
    );
    canvas.drawRect(
      Rect.fromLTWH(
        position.dx - barWidth / 2,
        position.dy - 23,
        barWidth * enemy.health.clamp(0, enemy.maxHealth) / enemy.maxHealth,
        3,
      ),
      Paint()..color = color,
    );
    _drawLabel(
      canvas,
      enemy.id.toUpperCase(),
      position + const Offset(0, 26),
      color: color,
      size: 8,
    );
  }

  void _drawPlayer(Canvas canvas) {
    final position = worldToScreen(snapshot.playerPosition);
    _drawTank(
      canvas,
      position,
      snapshot.playerHeading,
      snapshot.turretHeading,
      IronGorgeColors.cyan,
      1,
      true,
    );
    if (snapshot.lockedTargetId != null) {
      final target = snapshot.enemies
          .where((enemy) => enemy.id == snapshot.lockedTargetId)
          .firstOrNull;
      if (target != null && !target.isDestroyed) {
        final targetPoint = worldToScreen(target.position);
        canvas.drawCircle(
          targetPoint,
          23,
          Paint()
            ..color = IronGorgeColors.amber.withAlpha(220)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        canvas.drawLine(
          targetPoint + const Offset(-29, 0),
          targetPoint + const Offset(-18, 0),
          Paint()
            ..color = IronGorgeColors.amber
            ..strokeWidth = 2,
        );
        canvas.drawLine(
          targetPoint + const Offset(18, 0),
          targetPoint + const Offset(29, 0),
          Paint()
            ..color = IronGorgeColors.amber
            ..strokeWidth = 2,
        );
      }
    }
  }

  void _drawTank(
    Canvas canvas,
    Offset position,
    double heading,
    double turretHeading,
    Color color,
    double sizeFactor,
    bool player,
  ) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(math.pi - heading);
    final s = scale * 20 * sizeFactor;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, s * 0.8),
        width: s * 3.1,
        height: s * 1.25,
      ),
      Paint()..color = Colors.black.withAlpha(105),
    );
    final trackPaint = Paint()..color = const Color(0xFF121A1C);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-s * 1.45, -s * 0.98, s * 0.45, s * 2.05),
        Radius.circular(s * 0.25),
      ),
      trackPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s, -s * 0.98, s * 0.45, s * 2.05),
        Radius.circular(s * 0.25),
      ),
      trackPaint,
    );
    final hull = Path()
      ..moveTo(-s * 1.08, s * 0.78)
      ..lineTo(-s * 0.88, -s * 0.82)
      ..lineTo(s * 0.92, -s * 0.82)
      ..lineTo(s * 1.08, s * 0.78)
      ..close();
    canvas.drawPath(hull, Paint()..color = color.withAlpha(player ? 190 : 155));
    canvas.drawPath(
      hull,
      Paint()
        ..color = color.withAlpha(220)
        ..style = PaintingStyle.stroke
        ..strokeWidth = player ? 1.8 : 1.2,
    );
    canvas.save();
    canvas.rotate(heading - turretHeading);
    final turret = Path()
      ..moveTo(-s * 0.7, s * 0.28)
      ..lineTo(-s * 0.55, -s * 0.52)
      ..lineTo(s * 0.62, -s * 0.52)
      ..lineTo(s * 0.72, s * 0.28)
      ..close();
    canvas.drawPath(
      turret,
      Paint()..color = color.withAlpha(player ? 230 : 180),
    );
    canvas.drawPath(
      turret,
      Paint()
        ..color = Colors.white.withAlpha(110)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawRect(
      Rect.fromLTWH(-s * 0.08, -s * 2.12, s * 0.16, s * 1.72),
      Paint()..color = color,
    );
    canvas.restore();
    canvas.restore();
  }

  void _drawProjectile(Canvas canvas, ProjectileSnapshot projectile) {
    final start = worldToScreen(projectile.previousPosition);
    final end = worldToScreen(projectile.position);
    final color = projectile.fromPlayer
        ? (projectile.ammo == AmmoType.ap
              ? IronGorgeColors.amber
              : Colors.orange)
        : IronGorgeColors.red;
    canvas.drawLine(
      start,
      end,
      Paint()
        ..color = color.withAlpha(100)
        ..strokeWidth = 4,
    );
    canvas.drawLine(
      start,
      end,
      Paint()
        ..color = color
        ..strokeWidth = 1.4,
    );
    canvas.drawCircle(end, 2.5, Paint()..color = Colors.white);
  }

  void _drawEffect(Canvas canvas, EffectSnapshot effect) {
    final point = worldToScreen(effect.position);
    final color = switch (effect.colorSeed % 4) {
      0 => IronGorgeColors.amber,
      1 => IronGorgeColors.cyan,
      2 => Colors.orange,
      _ => IronGorgeColors.red,
    };
    final radius = (1 - effect.life.clamp(0, 1)) * 28 + 5;
    canvas.drawCircle(
      point,
      radius * scale,
      Paint()
        ..color = color.withAlpha((effect.life.clamp(0, 1) * 180).round())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      point,
      radius * 0.35 * scale,
      Paint()..color = color.withAlpha(100),
    );
  }

  void _drawAim(Canvas canvas) {
    final point =
        center +
        Offset(
          GameVector.fromHeading(snapshot.turretHeading).x * aimRadius,
          GameVector.fromHeading(snapshot.turretHeading).z * aimRadius,
        );
    final paint = Paint()
      ..color = IronGorgeColors.text.withAlpha(175)
      ..strokeWidth = 1;
    canvas.drawCircle(point, 13, paint..style = PaintingStyle.stroke);
    canvas.drawLine(
      point + const Offset(-21, 0),
      point + const Offset(-6, 0),
      paint..style = PaintingStyle.stroke,
    );
    canvas.drawLine(
      point + const Offset(6, 0),
      point + const Offset(21, 0),
      paint,
    );
    canvas.drawLine(
      point + const Offset(0, -21),
      point + const Offset(0, -6),
      paint,
    );
    canvas.drawLine(
      point + const Offset(0, 6),
      point + const Offset(0, 21),
      paint,
    );
  }

  void _drawLabel(
    Canvas canvas,
    String label,
    Offset center, {
    required Color color,
    double size = 9,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant BattlefieldPainter oldDelegate) =>
      oldDelegate.snapshot != snapshot;
}

class MiniMapPainter extends CustomPainter {
  const MiniMapPainter(this.snapshot);

  final GameSnapshot snapshot;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = const Color(0xD9101820));
    canvas.drawRect(
      rect,
      Paint()
        ..color = IronGorgeColors.cyan.withAlpha(120)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    Offset map(GameVector p) => Offset(
      (p.x + GameSession.worldHalfSize) /
          (GameSession.worldHalfSize * 2) *
          size.width,
      (p.z + GameSession.worldHalfSize) /
          (GameSession.worldHalfSize * 2) *
          size.height,
    );
    final line = Paint()
      ..color = const Color(0x665E746D)
      ..strokeWidth = 1;
    for (var i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(size.width * i / 4, 0),
        Offset(size.width * i / 4, size.height),
        line,
      );
      canvas.drawLine(
        Offset(0, size.height * i / 4),
        Offset(size.width, size.height * i / 4),
        line,
      );
    }
    final route = Path()
      ..moveTo(
        map(const GameVector(-410, 280)).dx,
        map(const GameVector(-410, 280)).dy,
      )
      ..lineTo(
        map(GameSession.townPosition).dx,
        map(GameSession.townPosition).dy,
      )
      ..lineTo(
        map(GameSession.radarPosition).dx,
        map(GameSession.radarPosition).dy,
      );
    canvas.drawPath(
      route,
      Paint()
        ..color = IronGorgeColors.amber.withAlpha(150)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawCircle(
      map(GameSession.radarPosition),
      6,
      Paint()..color = IronGorgeColors.cyan,
    );
    for (final enemy in snapshot.enemies.where((enemy) => !enemy.isDestroyed)) {
      canvas.drawCircle(
        map(enemy.position),
        3,
        Paint()..color = IronGorgeColors.red,
      );
    }
    canvas.drawCircle(
      map(snapshot.playerPosition),
      4,
      Paint()..color = IronGorgeColors.text,
    );
  }

  @override
  bool shouldRepaint(covariant MiniMapPainter oldDelegate) =>
      oldDelegate.snapshot != snapshot;
}

String _objectiveKey(MissionStage stage) => switch (stage) {
  MissionStage.reachTown => 'objectiveReach',
  MissionStage.destroyScouts => 'objectiveDestroy',
  MissionStage.captureRadar => 'objectiveCapture',
  MissionStage.defendRadar => 'objectiveDefend',
  MissionStage.complete => 'objectiveComplete',
  MissionStage.failed => 'objectiveFailure',
};

String _distance(GameVector a, GameVector b) =>
    a.distanceTo(b).round().toString().padLeft(3, '0');

String _formatTime(double seconds) {
  final value = seconds.floor();
  final minutes = (value ~/ 60).toString().padLeft(2, '0');
  final remainder = (value % 60).toString().padLeft(2, '0');
  return '$minutes:$remainder';
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
