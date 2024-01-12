import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/int.dart';

int energize(Grid<String> mirrors, ({int x, int y, int dx, int dy}) start) {
  Set<({int x, int y, int dx, int dy})> lights = {};
  List<({int x, int y, int dx, int dy})> toCheck = [start];

  Set<(int, int)> unique = {};
  while (toCheck.isNotEmpty) {
    final pos = toCheck.removeLast();
    if (pos.x < 0 || pos.x >= mirrors.width ||
        pos.y < 0 || pos.y >= mirrors.height ||
        lights.contains(pos)) continue;
    lights.add(pos);
    unique.add((pos.x, pos.y));

    switch (mirrors.at(pos.x, pos.y)) {
      case '/':
        toCheck.add((x: pos.x - pos.dy, y: pos.y - pos.dx, dx: -pos.dy, dy: -pos.dx));
      case r'\':
        toCheck.add((x: pos.x + pos.dy, y: pos.y + pos.dx, dx: pos.dy, dy: pos.dx));
      case '-':
        if (pos.dx != 0) continue empty;
        toCheck.add((x: pos.x - pos.dy, y: pos.y, dx: -pos.dy, dy: 0));
        toCheck.add((x: pos.x + pos.dy, y: pos.y, dx: pos.dy, dy: 0));
      case '|':
        if (pos.dy != 0) continue empty;
        toCheck.add((x: pos.x, y: pos.y - pos.dx, dx: 0, dy: -pos.dx));
        toCheck.add((x: pos.x, y: pos.y + pos.dx, dx: 0, dy: pos.dx));

      empty:
      case '.':
        toCheck.add((x: pos.x + pos.dx, y: pos.y + pos.dy, dx: pos.dx, dy: pos.dy));
    }
  }
  return unique.length;
}

void main() async {
  Grid<String> mirrors = Grid.string(await aoc.getInputString(), (e) => e);

  print('Part 1: ${energize(mirrors, (x: 0, y: 0, dx: 1, dy: 0))}');

  int best = 0;
  for (int i in 0.to(mirrors.width - 1)) {
    for ((int, int) d in [(0, 1), (mirrors.height - 1, -1)]) {
      int test = energize(mirrors, (x: i, y: d.$1, dx: 0, dy: d.$2));
      if (test > best) {
        best = test;
      }
    }
  }
  for (int i in 0.to(mirrors.height - 1)) {
    for ((int, int) d in [(0, 1), (mirrors.width - 1, -1)]) {
      int test = energize(mirrors, (x: d.$1, y: i, dx: d.$2, dy: 0));
      if (test > best) {
        best = test;
      }
    }
  }
  print('Part 2: $best');
}