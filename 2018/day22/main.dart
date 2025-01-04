import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/int.dart';
import 'package:AdventOfCode/space.dart';
import 'package:AdventOfCode/string.dart';
import 'package:collection/collection.dart';

void main() async {
  List<List<int>> lines = (await aoc.getInput()).map((e) => e.numbers()).toList();

  int depth = lines[0][0];
  Point target = Point(lines[1][0], lines[1][1]);

  Grid<int> cave = Grid.generate(100, 1000, (i) => -1);
  cave.every((x, y, e) {
    int geoIndex = 0;
    if (!(x == 0 && y == 0) && !(x == target.xi && y == target.yi)) {
      geoIndex = switch (geoIndex) {
        _ when y == 0 => x * 16807,
        _ when x == 0 => y * 48271,
        _ => cave.at(x - 1, y) * cave.at(x, y - 1),
      };
    }
    int erosion = (geoIndex + depth) % 20183;
    cave.put(x, y, erosion);
  });

  int risk = 0;
  for (int x in 0.to(target.xi)) {
    for (int y in 0.to(target.yi)) {
      risk += cave.at(x, y) % 3;
    }
  }
  print('Part 1: $risk');

  HeapPriorityQueue<({Point p, int g, int t})> options = HeapPriorityQueue((a, b) => a.t - b.t);
  options.add((p: Point(0, 0), g: 1, t: 0));

  List<int> times = [];
  Grid<List<int>> visited = Grid.generate(cave.width, cave.height, (i) => [9999, 9999, 9999]);
  while (options.isNotEmpty) {
    var cur = options.removeFirst();
    if (visited.atPoint(cur.p)[cur.g] <= cur.t) {
      continue;
    }
    if (cur.p == target) {
      times.add(cur.t + (cur.g != 1 ? 7 : 0));
    }
    visited.atPoint(cur.p)[cur.g] = cur.t;

    // tools => 0: nothing, 1: torch, 2: climbing gear
    int currentType = cave.atPoint(cur.p) % 3;
    cave.adjacent(cur.p.xi, cur.p.yi, (x, y, e) {
      int type = e % 3, gear = cur.g, time = cur.t;
      if (type == 0 && gear == 0) {
        gear = [-1, 2, 1][currentType];
        time += 7;
      } else if (type == 1 && gear == 1) {
        gear = [2, -1, 0][currentType];
        time += 7;
      } else if (type == 2 && gear == 2) {
        gear = [1, 0, -1][currentType];
        time += 7;
      }
      options.add((p: Point(x, y), g: gear, t: time + 1));
    });
  }
  print('Part 2: ${(times..sort()).first}');
}
