import 'package:flutter/widgets.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

import 'scene_port.dart';

/// Procedural Flutter Scene adapter for the first mobile 3D spike.
///
/// The gameplay layer only knows [ScenePort]. This adapter deliberately uses
/// primitive meshes until the authored T-99/scout GLB assets are ready. That
/// keeps the adapter useful for validating Flutter GPU, camera framing and
/// transform synchronisation without coupling domain tests to a GPU backend.
class FlutterSceneRendererAdapter implements ScenePort {
  FlutterSceneRendererAdapter({Scene? scene}) : scene = scene ?? Scene();

  static const double _worldScale = 0.025;

  final Scene scene;
  final Map<EntityId, Node> _visuals = <EntityId, Node>{};
  final List<Node> _levelNodes = <Node>[];
  late PerspectiveCamera _camera;
  bool _ready = false;

  bool get isReady => _ready;

  /// Completes the scene setup and creates a small procedural Nam-1 test pad.
  @override
  Future<void> loadLevel(String levelId) async {
    _ready = false;
    for (final node in _visuals.values) {
      scene.remove(node);
    }
    _visuals.clear();
    for (final node in _levelNodes) {
      scene.remove(node);
    }
    _levelNodes.clear();

    await Scene.initializeStaticResources();

    final ground = Node(
      name: '$levelId/ground',
      mesh: Mesh(
        PlaneGeometry(width: 24, depth: 24),
        _material(vm.Vector4(0.045, 0.085, 0.09, 1)),
      ),
    )..castsShadows = false;
    scene.add(ground);
    _levelNodes.add(ground);

    _addCover(
      id: '$levelId/cover-a',
      position: vm.Vector3(-4.2, 0, -1.4),
      extents: vm.Vector3(2.2, 0.7, 1.1),
    );
    _addCover(
      id: '$levelId/cover-b',
      position: vm.Vector3(4.0, 0, 2.2),
      extents: vm.Vector3(1.5, 1.1, 1.5),
    );

    _camera = PerspectiveCamera(
      position: vm.Vector3(0, 13, 14),
      target: vm.Vector3.zero(),
      fovRadiansY: 0.82,
      fovNear: 0.1,
      fovFar: 100,
    );
    _ready = true;
  }

  /// Returns a Flutter widget that renders the adapter-owned scene.
  ///
  /// Call [loadLevel] first. The game screen can keep rendering its Canvas
  /// fallback while this widget is exercised from a mobile technical-spike
  /// surface.
  Widget buildView({Key? key}) {
    if (!_ready) return const SizedBox.shrink();
    return SceneView(scene, key: key, camera: _camera);
  }

  @override
  void spawnVisual(VisualSpawnRequest request) {
    _ensureReady();
    final previous = _visuals.remove(request.entityId);
    if (previous != null) scene.remove(previous);

    final node = request.assetId.contains('radar')
        ? _buildRadar(request.entityId)
        : _buildVehicle(request.entityId, request.assetId);
    _visuals[request.entityId] = node;
    scene.add(node);
    _applyTransform(node, request.transform);
  }

  @override
  void syncTransform(EntityId id, WorldTransform transform) {
    final node = _visuals[id];
    if (node == null) return;
    _applyTransform(node, transform);
  }

  @override
  void removeVisual(EntityId id) {
    final node = _visuals.remove(id);
    if (node != null) scene.remove(node);
  }

  void _ensureReady() {
    if (!_ready) {
      throw StateError('Call loadLevel before adding Flutter Scene visuals.');
    }
  }

  void _applyTransform(Node node, WorldTransform transform) {
    node.position = vm.Vector3(
      transform.position.x * _worldScale,
      0,
      transform.position.z * _worldScale,
    );
    node.rotation = vm.Quaternion.axisAngle(
      vm.Vector3(0, 1, 0),
      transform.heading,
    );
  }

  void _addCover({
    required String id,
    required vm.Vector3 position,
    required vm.Vector3 extents,
  }) {
    final node =
        Node(
            name: id,
            mesh: Mesh(
              CuboidGeometry(extents),
              _material(vm.Vector4(0.11, 0.18, 0.19, 1)),
            ),
          )
          ..position = vm.Vector3(position.x, extents.y * 0.5, position.z)
          ..castsShadows = false;
    scene.add(node);
    _levelNodes.add(node);
  }

  Node _buildVehicle(String id, String assetId) {
    final bodyExtents = _bodyExtents(assetId);
    final body = Node(
      name: '$id/hull',
      mesh: Mesh(
        CuboidGeometry(bodyExtents),
        _material(_vehicleColor(assetId)),
      ),
    )..position = vm.Vector3(0, bodyExtents.y * 0.5, 0);

    final turretExtents = vm.Vector3(
      bodyExtents.x * 0.55,
      bodyExtents.y * 0.45,
      bodyExtents.z * 0.48,
    );
    final turret = Node(
      name: '$id/turret',
      mesh: Mesh(
        CuboidGeometry(turretExtents),
        _material(_turretColor(assetId)),
      ),
    )..position = vm.Vector3(0, bodyExtents.y + turretExtents.y * 0.5, 0);

    final gunLength = bodyExtents.z * 0.9;
    final gun = Node(
      name: '$id/gun',
      mesh: Mesh(
        CuboidGeometry(vm.Vector3(0.16, 0.16, gunLength)),
        _material(_turretColor(assetId)),
      ),
    )..position = vm.Vector3(0, 0, turretExtents.z * 0.5 + gunLength * 0.5);
    turret.add(gun);

    final root = Node(name: id);
    root.add(body);
    root.add(turret);
    return root;
  }

  Node _buildRadar(String id) {
    final base = Node(
      name: '$id/base',
      mesh: Mesh(
        CuboidGeometry(vm.Vector3(1.5, 0.3, 1.5)),
        _material(vm.Vector4(0.04, 0.32, 0.34, 1)),
      ),
    )..position = vm.Vector3(0, 0.15, 0);
    final mast = Node(
      name: '$id/mast',
      mesh: Mesh(
        CuboidGeometry(vm.Vector3(0.18, 2.0, 0.18)),
        _material(vm.Vector4(0.12, 0.7, 0.68, 1)),
      ),
    )..position = vm.Vector3(0, 1.3, 0);
    final dish = Node(
      name: '$id/dish',
      mesh: Mesh(
        CuboidGeometry(vm.Vector3(1.0, 0.12, 0.5)),
        _material(vm.Vector4(0.85, 0.58, 0.2, 1)),
      ),
    )..position = vm.Vector3(0, 2.2, 0);

    final root = Node(name: id);
    root.add(base);
    root.add(mast);
    root.add(dish);
    return root;
  }

  static vm.Vector3 _bodyExtents(String assetId) {
    if (assetId.contains('scout')) {
      return vm.Vector3(1.1, 0.45, 1.7);
    }
    if (assetId.contains('medium')) {
      return vm.Vector3(1.45, 0.62, 2.1);
    }
    return vm.Vector3(1.65, 0.7, 2.35);
  }

  static vm.Vector4 _vehicleColor(String assetId) {
    if (assetId.contains('scout')) {
      return vm.Vector4(0.62, 0.12, 0.1, 1);
    }
    if (assetId.contains('medium')) {
      return vm.Vector4(0.56, 0.32, 0.08, 1);
    }
    return vm.Vector4(0.1, 0.38, 0.4, 1);
  }

  static vm.Vector4 _turretColor(String assetId) {
    if (assetId.contains('scout')) {
      return vm.Vector4(0.78, 0.2, 0.14, 1);
    }
    if (assetId.contains('medium')) {
      return vm.Vector4(0.75, 0.46, 0.1, 1);
    }
    return vm.Vector4(0.16, 0.55, 0.56, 1);
  }

  static UnlitMaterial _material(vm.Vector4 color) {
    return UnlitMaterial()..baseColorFactor = color;
  }
}
