import 'dart:math' as math;

/// Small engine-agnostic 2D vector used by the gameplay simulation.
///
/// The MVP renders the X/Z battlefield as a tactical canvas. Keeping this
/// type independent from Flutter means the same movement and combat rules can
/// later drive a 3D scene adapter.
class GameVector {
  const GameVector(this.x, this.z);

  final double x;
  final double z;

  static const zero = GameVector(0, 0);

  GameVector operator +(GameVector other) =>
      GameVector(x + other.x, z + other.z);

  GameVector operator -(GameVector other) =>
      GameVector(x - other.x, z - other.z);

  GameVector operator *(double scalar) => GameVector(x * scalar, z * scalar);

  GameVector operator /(double scalar) => GameVector(x / scalar, z / scalar);

  double get length => math.sqrt(x * x + z * z);

  double get lengthSquared => x * x + z * z;

  GameVector get normalized {
    final magnitude = length;
    return magnitude < 0.0001 ? zero : this / magnitude;
  }

  double dot(GameVector other) => x * other.x + z * other.z;

  double distanceTo(GameVector other) => (this - other).length;

  GameVector clamp(double minX, double maxX, double minZ, double maxZ) {
    return GameVector(
      x.clamp(minX, maxX).toDouble(),
      z.clamp(minZ, maxZ).toDouble(),
    );
  }

  static GameVector fromHeading(double heading) {
    return GameVector(math.sin(heading), math.cos(heading));
  }

  static GameVector lerp(GameVector a, GameVector b, double t) {
    return a + (b - a) * t.clamp(0, 1);
  }

  @override
  String toString() => 'GameVector($x, $z)';
}

double moveTowards(double current, double target, double maxDelta) {
  if ((target - current).abs() <= maxDelta) return target;
  return current + (target > current ? maxDelta : -maxDelta);
}

double normalizeAngle(double angle) {
  const fullTurn = math.pi * 2;
  var result = angle % fullTurn;
  if (result > math.pi) result -= fullTurn;
  if (result < -math.pi) result += fullTurn;
  return result;
}

double headingTo(GameVector from, GameVector to) {
  final direction = to - from;
  return math.atan2(direction.x, direction.z);
}

/// Distance from [point] to the finite segment [start] → [end].
double distanceToSegment(GameVector point, GameVector start, GameVector end) {
  final segment = end - start;
  final lengthSquared = segment.lengthSquared;
  if (lengthSquared < 0.0001) return point.distanceTo(start);
  final t =
      ((point - start).dot(segment) / lengthSquared).clamp(0, 1).toDouble();
  return point.distanceTo(start + segment * t);
}
