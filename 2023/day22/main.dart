import 'dart:collection';
import 'dart:io';

import 'package:AdventOfCode/int.dart';

class Brick {
  int x1, y1, z1, x2, y2, z2;
  int? _hashCode;
  Set<(int, int)> _v = {};

  Brick(this.x1, this.y1, this.z1, this.x2, this.y2, this.z2);

  Set<(int, int)> get volume {
    if (_v.isNotEmpty) return _v;
    for (int x in x1.to(x2))
      for (int y in y1.to(y2))
          _v.add((x, y));
    return _v;
  }
  // If both bricks have any cube on the same position
  bool operator^(Brick o) => volume.intersection(o.volume).length != 0;
  bool operator==(Object o) => o is Brick && x1 == o.x1 && x2 == o.x2 && y1 == o.y1 && y2 == o.y2 && z1 == o.z1 && z2 == o.z2;
  int get hashCode => _hashCode ??= Object.hash(x1, y1, z1, x2, y2, z2);
}

void main() async {
  List<Brick> bricks = [];
  for (String line in await File('input.txt').readAsLines()) {
    List<int> c = RegExp(r'\d+').allMatches(line).map((e) => int.parse(e.group(0)!)).toList();
    bricks.add(Brick(c[0], c[1], c[2], c[3], c[4], c[5]));
  }
  // Sort bircks in z for simplicity
  bricks.sort((a, b) => a.z1 - b.z1);

  // Simulate block-fall until no block can fall any further
  // This is the slowest part of the solution, takes 0.8s to run
  for (Brick b in bricks.where((e) => e.z1 > 1)) {
    bool movedAny = false;
    do {
      movedAny = false;
      if (b.z1 > 1 && !bricks.where((e) => e.z2 == b.z1 - 1).any((e) => e ^ b)) {
        b.z1--; b.z2--;
        movedAny = true;
      }
    } while (movedAny);
  }

  // Find which bricks every brick is supported by and which brick every brick supports
  Map<Brick, Set<Brick>> supportedBy = {};
  Map<Brick, Set<Brick>> supports = {};
  for (int z in 1.to(bricks.last.z1)) {
    for (Brick b in bricks.where((e) => e.z1 == z)) {
      for (Brick supported in bricks.where((e) => e.z1 == b.z2 + 1 && e ^ b)) {
        (supportedBy[supported] ??= {}).add(b);
        (supports[b] ??= {}).add(supported);
      }
    }
  }

  int canRemove = 0;
  for (Brick b in bricks) {
    // If the brick we support has another brick supporting it, this one can be removed
    if (supportedBy.values.where((s) => s.contains(b)).every((s) => s.length > 1)) {
      canRemove++;
    }
  }
  print('Part 1: $canRemove');

  int wouldFall(Brick b) {
    Set<Brick> willFall = {b};
    Queue<Brick> chainReaction = Queue.from(supports[b] ?? {});

    while (chainReaction.isNotEmpty) {
      Brick next = chainReaction.removeFirst();
      if ((supportedBy[next] ?? {}).every((e) => willFall.contains(e))) {
        willFall.add(next);
        chainReaction.addAll(supports[next] ?? {});
      }
    }
    return willFall.length - 1;
  }
  print('Part 2: ${bricks.map(wouldFall).reduce((a, b) => a + b)}');
}