import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../core/math/game_vector.dart';
import '../../game/infrastructure/scene/flutter_scene_renderer_adapter.dart';
import '../../game/infrastructure/scene/scene_port.dart';

/// Opt-in mobile surface for validating the Flutter Scene adapter.
///
/// Gameplay stays on the Canvas renderer until this primitive scene has been
/// checked on the target Android/iOS GPU. Keeping the spike behind a settings
/// entry makes the fallback playable even when a device lacks Flutter GPU
/// support.
class SceneSpikeScreen extends StatefulWidget {
  const SceneSpikeScreen({
    super.key,
    required this.strings,
    required this.onBack,
  });

  final AppStrings strings;
  final VoidCallback onBack;

  @override
  State<SceneSpikeScreen> createState() => _SceneSpikeScreenState();
}

class _SceneSpikeScreenState extends State<SceneSpikeScreen> {
  late final FlutterSceneRendererAdapter _renderer;
  Object? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _renderer = FlutterSceneRendererAdapter();
    _loadSpike();
  }

  Future<void> _loadSpike() async {
    try {
      await _renderer.loadLevel('mvp_nam1_spike');
      _renderer.spawnVisual(
        VisualSpawnRequest(
          entityId: 'spike/player',
          assetId: 't99_storm',
          transform: WorldTransform(
            position: GameVector(-170, 150),
            heading: 0,
          ),
        ),
      );
      _renderer.spawnVisual(
        VisualSpawnRequest(
          entityId: 'spike/scout-a',
          assetId: 'ares_scout',
          transform: WorldTransform(
            position: GameVector(250, 40),
            heading: math.pi * 0.7,
          ),
        ),
      );
      _renderer.spawnVisual(
        VisualSpawnRequest(
          entityId: 'spike/medium-a',
          assetId: 'ares_medium',
          transform: WorldTransform(
            position: GameVector(90, -330),
            heading: math.pi,
          ),
        ),
      );
      _renderer.spawnVisual(
        VisualSpawnRequest(
          entityId: 'spike/radar',
          assetId: 'radar_nam1',
          transform: WorldTransform(position: GameVector(300, 300), heading: 0),
        ),
      );
    } on Object catch (error) {
      if (mounted) setState(() => _error = error);
      return;
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IronGorgeColors.background,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (_error != null)
              _ErrorState(error: _error.toString())
            else if (_loading)
              const Center(
                child: CircularProgressIndicator(color: IronGorgeColors.cyan),
              )
            else
              _renderer.buildView(),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, color: IronGorgeColors.cyan),
                tooltip: widget.strings.text('returnToMenu'),
              ),
            ),
            Positioned(
              top: 18,
              right: 18,
              child: _StatusBadge(strings: widget.strings),
            ),
            Positioned(
              left: 24,
              bottom: 24,
              child: _OverlayPanel(strings: widget.strings),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: IronGorgeColors.panel.withAlpha(230),
        border: Border.all(color: IronGorgeColors.cyan.withAlpha(150)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(width: 7, height: 7, color: IronGorgeColors.green),
          const SizedBox(width: 8),
          Text(
            strings.text('sceneSpike'),
            style: const TextStyle(
              color: IronGorgeColors.cyan,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlayPanel extends StatelessWidget {
  const _OverlayPanel({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IronGorgeColors.panel.withAlpha(235),
        border: Border.all(color: IronGorgeColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            strings.text('sceneSpike'),
            style: const TextStyle(
              color: IronGorgeColors.amber,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            strings.text('sceneSpikeDescription'),
            style: const TextStyle(
              color: IronGorgeColors.muted,
              fontSize: 11,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'PROCEDURAL MESH // SCENE PORT // GPU READY',
            style: TextStyle(
              color: IronGorgeColors.line,
              fontSize: 9,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.warning_amber_rounded,
              color: IronGorgeColors.amber,
              size: 42,
            ),
            const SizedBox(height: 12),
            const Text(
              'FLUTTER GPU SPIKE FAILED',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: IronGorgeColors.amber,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: IronGorgeColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
