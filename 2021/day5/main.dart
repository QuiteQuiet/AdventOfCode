import 'dart:math';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/space.dart';
import 'package:AdventOfCode/string.dart';

void main() async {
  List<String> lines = await aoc.getInput();

  Map<Point, int> grid = {}, diag = {};

  for (String line in lines) {
    List<int> coords = line.numbers();
    Point a = Point(coords[0], coords[1]),
          b = Point(coords[2], coords[3]);

    num slope = (b.yi - a.yi) / (b.xi - a.xi);
    int dist = a.manhattanDist(b);
    if (slope.isInfinite) {
      for (int i = 0; i <= dist; i++) {
        Point p = Point(a.xi, min(a.yi, b.yi) + i);
        grid[p] = (grid[p] ?? 0) + 1;
      }
    } else if (slope == 0) {
      for (int i = 0; i <= dist; i++) {
        Point p = Point(min(a.xi, b.xi) + i, a.yi);
        grid[p] = (grid[p] ?? 0) + 1;
      }
    } else {
      for (int i = 0; i <= dist ~/ 2; i++) {
        Point? p;
        if (a.xi < b.xi) {
          p = Point(a.xi + i, a.yi + slope.toInt() * i);
        } else {
          p = Point(b.xi + i, b.yi + slope.toInt() * i);
        }
        diag[p] = (diag[p] ?? 0) + 1;
      }
    }
  }
  print('Part 1: ${grid.values.where((e) => e > 1).length}');

  for (Point p in diag.keys) {
    grid[p] = (grid[p] ?? 0) + diag[p]!;
  }
  print('Part 2: ${grid.values.where((e) => e > 1).length}');
}
