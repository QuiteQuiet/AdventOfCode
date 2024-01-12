import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

import 'package:AdventOfCode/int.dart';

class Point {
  num x, y, z;
  Point(this.x, this.y, this.z);
}

class HailStone {
  late Point pos;
  late Point vel;
  HailStone(List<num> pos, List<num> vel) {
    this.pos = Point(pos[0], pos[1], pos[2]);
    this.vel = Point(vel[0], vel[1], vel[2]);
  }
  Point? intersects(HailStone o) {
    // Calculating an intersection of two vectors
    // Division by 0 => +/- Infinity
    final num det = vel.x * o.vel.y - vel.y * o.vel.x;
    final num t = (vel.x * (pos.y - o.pos.y) + vel.y * (o.pos.x - pos.x)) / det;

    num x = o.pos.x + o.vel.x * t;
    num y = o.pos.y + o.vel.y * t;
    if (!(
      // Lines are parallel
      x.isInfinite || y.isInfinite ||
      // If the intersection point happened in the past
      (x - pos.x) / vel.x < 0 ||
      (x - o.pos.x) / o.vel.x < 0
    ))
      return Point(x, y, 0);
    return null;
  }
  String toString() => '($pos, $vel)';
}

void promisingVelocity(num vel, num aP, num bP, Set<int> previous) {
  Set<int> promise = {};
  num diff = (aP - bP).abs();
  for (int v in (-1000).to(1000)) {
    if (v == vel) continue;
    if (diff % (v - vel) == 0) {
      promise.add(v);
    }
  }
  if (previous.isEmpty)
    previous.addAll(promise);
  else
    previous.removeWhere((e) => !promise.contains(e));
}

void main() async {
  List<String> input = await aoc.getInput();

  num start = 200000000000000, end = 400000000000000;
  num startX = start, endX = end,
      startY = start, endY = end;

  List<HailStone> hailstones = [];
  for (String line in input) {
    List<num> all = RegExp(r'-?\d+').allMatches(line).map((e) => int.parse(e.group(0)!)).toList();
    hailstones.add(HailStone([...all.sublist(0, 3)], [...all.sublist(3)]));
  }

  int valid = 0;
  Set<int> possibleX = {}, possibleY = {}, possibleZ = {};
  for (final (int index, HailStone h) in hailstones.indexed) {
    for (int i in (index + 1).to(hailstones.length - 1)) {
      HailStone h2 = hailstones[i];
      Point? inter = h.intersects(h2);
      if (inter != null && (
        // Did it intersect in bounds?
        startX < inter.x && inter.x < endX && startY < inter.y && inter.y < endY
      )) {
        valid++;
      }

      if (h.vel.x == h2.vel.x) {
        promisingVelocity(h.vel.x, h.pos.x, h2.pos.x, possibleX);
      }
      if (h.vel.y == h2.vel.y) {
        promisingVelocity(h.vel.y, h.pos.y, h2.pos.y, possibleY);
      }
      if (h.vel.z == h2.vel.z) {
        promisingVelocity(h.vel.z, h.pos.z, h2.pos.z, possibleZ);
      }
    }
  }
  print('Part 1: $valid');

  // Credit to https://www.reddit.com/r/adventofcode/comments/18pnycy/comment/keqf8uq/?utm_source=share&utm_medium=web2x&context=3
  // for this solution.

  // Basically, any stones with the same velocity in any dimension constrains the possible
  // speeds our rock can travel in to speeds that are (hail_a - hail_b) % (rock_v - hail_v) == 0.
  // Doing this for all rock pairs for all dimension actually ends up with only a single
  // velocity in each dimension. Then solve another linear equation set for the starting point.
  num dx = possibleX.first;
  num dy = possibleY.first;
  num dz = possibleZ.first;

  // Any two random stones work for this
  // I don't really understand why subtracting the stone vector from two hailstones
  // gives a linear equation for the position of the stone, but I assume there is some
  // trigonometry proof that this holds
  HailStone first = hailstones[0], second = hailstones[1];
  HailStone a = HailStone([first.pos.x, first.pos.y, first.pos.z],
                          [first.vel.x - dx, first.vel.y - dy, first.vel.z - dz]);
  HailStone b = HailStone([second.pos.x, second.pos.y, second.pos.z],
                          [second.vel.x - dx, second.vel.y - dy, second.vel.z - dz]);

  Point point = a.intersects(b)!;
  num t = (point.x - first.pos.x) / a.vel.x;
  point.z = first.pos.z + a.vel.z * t;
  print('Part 2: ${(point.x + point.y + point.z).round()}');
}