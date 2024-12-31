import 'dart:collection';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/space.dart';

List<Point> path(Grid<String> race, Point start, Point goal) {
  Queue<Point> queue = Queue()..add(start);
  Set<Point> visited = {};
  List<Point> path = []; // We know there's only a single path
  while (queue.isNotEmpty) {
    final Point cur = queue.removeFirst();
    if (visited.contains(cur))
      continue;
    visited.add(cur);
    path.add(cur);
    if (cur == goal)
      return path;
    race.adjacent(cur.xi, cur.yi, (x, y, el) {
      if (el != '#')
        queue.add(Point(x, y));
    });
  }
  return [];
}

int cheats(List<Point> steps, int move) {
  int goodCheats = 0;
  for (final (int i, Point p) in steps.indexed) {
    for (int ii = i + 1; ii < steps.length; ii++) {
      int distance = p.manhattanDist(steps[ii]);
      if (distance <= move && ii - i + 1 - distance >= 100)
        goodCheats++;
    }
  }
  return goodCheats;
}

void main() async {
  Grid<String> race = Grid.string(await aoc.getInputString(), (e) => e);
  Point? start, goal;

  race.every((x, y, e) {
    if (e == 'S') {
      start = Point(x, y);
    } else if (e == 'E') {
      goal = Point(x, y);
    }
  });

  List<Point> steps = path(race, start!, goal!);
  for (final (int i, int e) in [2, 20].indexed) {
    print('Part ${i + 1}: ${cheats(steps, e)}');
  }
}