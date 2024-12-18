import 'dart:collection';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/int.dart';
import 'package:AdventOfCode/string.dart';

int findPath(Grid<int> floor) {
  Queue<({int x, int y, int s})> options = Queue()..add((x: 0, y: 0, s: 0));
  Set<(int, int)> visited = {};
  int path = 0;
  while (options.isNotEmpty) {
    var cur = options.removeFirst();
    (int, int) pos = (cur.x, cur.y);
    if (visited.contains(pos)) continue;
    visited.add(pos);

    if (cur.x == floor.width - 1 && cur.y == floor.height - 1) {
      path = cur.s;
      break;
    }

    floor.adjacent(cur.x, cur.y, (x, y, el) {
      if (el == 0) {
        options.add((x: x, y: y, s: cur.s + 1));
      }
    });
  }
  return path;
}



void main() async {
  List<List<int>> bytes = (await aoc.getInput()).map((e) => e.numbers()).toList();

  int size = 71, base = 1024;
  Grid<int> floor = Grid<int>.filled(size, size, 0);

  for (int i in 0.to(base - 1)) {
    floor.put(bytes[i][0], bytes[i][1], 1);
  }

  int path = findPath(floor);
  print('Part 1: $path');

  int drop(Grid<int> floor, int n) {
    Grid<int> copy = Grid.copy(floor);
    for (int i in 0.to(n - 1)) {
      copy.put(bytes[base + i][0], bytes[base + i][1], 1);
    }
    return findPath(copy);
  }

  int extra = 0;
  while (path != 0) {
    extra += 100;
    path = drop(floor, extra);
  }

  while (path == 0) {
    extra -= 1;
    path = drop(floor, extra);
  }
  print('Part 2: ${bytes[base + extra].join(',')}');
}