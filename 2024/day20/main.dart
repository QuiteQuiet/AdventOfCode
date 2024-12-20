import 'dart:collection';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';

class Point {
  int x, y;
  List<Point> path;
  Point(this.x, this.y, this.path);
  bool operator==(Object o) => o is Point && x == o.x && y == o.y;
  int get hashCode => Object.hash(x, y);
  String toString() => '($x, $y)';
}

List<Point> bfs(Grid<String> race, Point start, Point goal) {
  Queue<Point> bfs = Queue()..add(start);
  Set<Point> visited = {};
  while (bfs.isNotEmpty) {
    Point cur = bfs.removeFirst();
    if (visited.contains(cur))
      continue;
    visited.add(cur);
    if (cur == goal)
      return cur.path;
    race.adjacent(cur.x, cur.y, (x, y, el) {
      if (el != '#') {
        bfs.add(Point(x, y, List.from(cur.path)..add(cur)));
      }
    });
  }
  return [];
}

int cheats(List<Point> steps, int moves) {
  int goodCheats = 0;
  for (final (int i, Point p) in steps.indexed) {
    for (final(int ii, Point pp) in steps.sublist(i + 1).indexed) {

      int distance = (pp.x - p.x).abs() + (pp.y - p.y).abs();
      int saves = ii - distance + 1;
      if (distance <= moves && saves >= 100) {
        goodCheats++;
      }
    }
  }
  return goodCheats;
}

void main() async {
  Grid<String> race = Grid.string(await aoc.getInputString(), (e) => e);
  Point? start, goal;
  race.every((x, y, e) {
    if (e == 'S') {
      start = Point(x, y, []);
    } else if (e == 'E') {
      goal = Point(x, y, []);
    }
  });

  List<Point> steps = bfs(race, start!, goal!)..add(goal!);

  print('Part 1: ${cheats(steps, 2)}');
  print('Part 2: ${cheats(steps, 20)}');
}