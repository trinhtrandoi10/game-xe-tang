import '../../../core/math/game_vector.dart';
import '../scene/scene_port.dart';

class RayQuery {
  const RayQuery(
      {required this.origin,
      required this.direction,
      required this.maxDistance});

  final GameVector origin;
  final GameVector direction;
  final double maxDistance;
}

class ShapeCastQuery {
  const ShapeCastQuery(
      {required this.origin, required this.destination, required this.radius});

  final GameVector origin;
  final GameVector destination;
  final double radius;
}

class SphereQuery {
  const SphereQuery({required this.center, required this.radius});

  final GameVector center;
  final double radius;
}

class PhysicsHit {
  const PhysicsHit(
      {required this.entityId,
      required this.point,
      required this.normal,
      required this.distance});

  final EntityId entityId;
  final GameVector point;
  final GameVector normal;
  final double distance;
}

class GroundHit {
  const GroundHit({required this.height, required this.normal});

  final double height;
  final GameVector normal;
}

abstract interface class PhysicsPort {
  PhysicsHit? raycast(RayQuery query);

  PhysicsHit? shapeCast(ShapeCastQuery query);

  List<EntityId> overlapSphere(SphereQuery query);

  GroundHit? queryGround(GameVector position);
}
