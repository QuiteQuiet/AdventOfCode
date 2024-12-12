import 'dart:collection';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/int.dart';


void main() async {
  Grid<String> garden = Grid.string(await aoc.getInputString(), (e) => e);
  int scale = 2;
  Grid<String> upscale = Grid.filled(garden.width * scale, garden.height * scale, ' ');

  garden.every((x, y, e) {
    for (int i in 0.to(1))
      for (int ii in 0.to(1))
        upscale.put(x * scale + i, y * scale + ii, e);
  });

  Set<(int, int)> visited = {};
  Map<(int, int), Map<String, int>> regions = {};
  upscale.every((x, y, plant) {
    final (int, int) pos = (x, y);
    if (visited.contains(pos))
      return;

    Map<String, int> here = regions[pos] = {'a': 0, 'p': 0};

    Queue<(int, int)> region = Queue()..add(pos);
    Map<(int, int), int> fence = {};
    Set<(int, int)> diagonals = {}, plot = {};
    while (region.isNotEmpty) {
      final (int, int) cur = region.removeFirst();
      if (visited.contains(cur))
        continue;
      visited.add(cur);
      plot.add(cur);
      here['a'] = here['a']! + 1;

      for (final (int x, int y) in [(-1, 0), (1, 0), (0, -1), (0, 1)]) {
        int nx = cur.$1 + x, ny = cur.$2 + y;
        (int, int) coord = (nx, ny);
        if (upscale.outOfBounds(nx, ny) || upscale.at(nx, ny) != plant) {
          fence[coord] = (fence[coord] ?? 0) + 1;
        } else {
          region.add((nx, ny));
        }
      }
      for (final (int x, int y) in [(-1, -1), (-1, 1), (1, -1), (1, 1)]) {
        diagonals.add((cur.$1 + x, cur.$2 + y));
      }
    }
    here['p'] = fence.values.reduce((a, b) => a + b) ~/ scale;
    here['a'] = here['a']! ~/ (scale * scale);
    here['s'] = diagonals.fold(0, (s, e) => s + (plot.contains(e) ? 0 : (fence[e] ?? 2) - 1));
  });
  print("Part 1: ${regions.values.fold(0, (s, e) => s + e['a']! * e['p']!)}");
  print("Part 2: ${regions.values.fold(0, (s, e) => s + e['a']! * e['s']!)}");
}