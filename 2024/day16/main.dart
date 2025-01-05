import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:collection/collection.dart';

class Point {
  int x, y, d, s;
  List<(int, int)> path;
  Point(this.x, this.y, this.d, this.s, this.path);
}

void main() async {
  Grid<String> maze = Grid.string(await aoc.getInputString(), (e) => e);

  ({int x, int y}) start = (x: 0, y: 0), end = (x: 0, y: 0);
  maze.every((x, y, e) {
    if (e == 'S') {
      start = (x: x, y: y);
    } else if (e == 'E') {
      end = (x: x, y: y);
    }
  });

  Map<(int, int), int> directions = {(1, 0): 0, (0, 1): 1, (0, -1): 2, (-1, 0): 3};
  HeapPriorityQueue<Point> queue = HeapPriorityQueue((a, b) => a.s - b.s);
  queue.add(Point(start.x, start.y, 0, 0, []));

  Map<(int, int, int), int> visited = {};
  Point? best;
  List<Point> options = [];
  while (queue.isNotEmpty) {
    Point cur = queue.removeFirst();
    cur.path.add((cur.x, cur.y));
    (int, int, int) here = (cur.x, cur.y, cur.d);
    if (visited.containsKey(here)) {
      if (visited[here] == cur.s)
        options.add(cur); // A valid option for alternate path
      continue;
    }
    visited[here] = cur.s;
    if (end.x == cur.x && end.y == cur.y) {
      best = cur;
      break;
    }

    maze.adjacent(cur.x, cur.y, (x, y, el) {
      int d = directions[(x - cur.x, y - cur.y)]!;
      if (el == '#' || (cur.d == 0 && d == 3) || (cur.d == 1 && d == 2))
        return; // walls or 180 deg turns
      int score = cur.s + (d == cur.d ? 1 : 1001);
      queue.add(Point(x, y, d, score, List.from(cur.path)));
    });
  }
  print('Part 1: ${best!.s}');

  Set<(int, int)> path = Set.from(best.path),
                  bestPaths = Set.from(best.path);
  for (Point test in options) {
    if (path.contains(test.path.last)) {
      bestPaths.addAll(test.path);
    }
  }
  print('Part 2: ${bestPaths.length}');
}