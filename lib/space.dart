

import 'dart:math';

/// Package for helper classes relates to 2d and 3d calculations
/// like distance and relative positions.

class Point {
  num _x, _y;
  late int _hash;

  num get x => _x;
  num get y => _y;

  /// A point in space. Can be either be discrete point or floating
  /// points.
  Point(this._x, this._y) {
    _hash = Object.hash(_x, _y);
  }

  @override
  bool operator==(Object o) => o is Point && _x == o.x && _y == o.y;
  @override
  int get hashCode => _hash;
  @override
  String toString() => 'P($x, $y)';

  Point operator+(Point o) => Point(_x + o._x, _y + o._y);
  Point operator-(Point o) => Point(_x - o._x, _y - o._y);
  Point operator*(num o) => Point(_x * o, _y * o);

  /// Euclidian distance between two points
  num euclidianDist(Point o) => sqrt(pow(_x- o.x, 2) + pow(_y - o.y, 2));

  /// Manhattan distance between two points
  int manhattanDist(Point o) => ((_x - o.x).abs() + (_y - o.y).abs()).toInt();
}

class Line {
  Point _a, _b;

  /// The f(x) => y = mx + b function that defines the line.
  /// Call to get the y coordinate on the line for a given x.
  late num Function(num x) findY;

  Line(this._a, this._b) {
    num m = (_a.y - _b.y) / (_a.x - _b.x);
    num b = _a.y - m * _a.x;
    findY = (num x) => x * m + b;
  }

  /// Returns true if the point is on the line
  bool contains(Point p) => p.y == findY(p.x);
}

class Vector {
  late List<num> origin, direction;
  Vector(or, dir) {
    this.origin = List.from(or);
    this.direction = List.from(dir);
    assert(origin.length == direction.length);
  }

  Vector operator*(num t) {
    List<num> or = List.generate(origin.length, (i) => origin[i] + t * direction[i]);
    return Vector(or, direction);
  }

  Vector once() {
    List<num> or = List.generate(origin.length, (i) => origin[i] + direction[i]);
    return Vector(or, direction);
  }

  @override
  String toString() => 'V([${origin.join(', ')}] + t * [${direction.join(', ')}])';
}