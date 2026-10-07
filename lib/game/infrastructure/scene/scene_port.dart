import '../../../core/math/game_vector.dart';

typedef EntityId = String;

class WorldTransform {
  const WorldTransform({required this.position, this.heading = 0});

  final GameVector position;
  final double heading;
}

class VisualSpawnRequest {
  const VisualSpawnRequest({
    required this.entityId,
    required this.assetId,
    required this.transform,
  });

  final EntityId entityId;
  final String assetId;
  final WorldTransform transform;
}

/// Renderer boundary from the implementation plan. The playable MVP keeps a
/// Canvas renderer while the Flutter Scene adapter can be enabled after the
/// physical-device GPU gate passes.
abstract interface class ScenePort {
  Future<void> loadLevel(String levelId);

  void spawnVisual(VisualSpawnRequest request);

  void syncTransform(EntityId id, WorldTransform transform);

  void removeVisual(EntityId id);
}
