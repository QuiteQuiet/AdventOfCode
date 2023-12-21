import 'dart:collection';
import 'dart:io';

import 'package:AdventOfCode/grid.dart';

class Point {
  int x, y, s;
  Point(this.x, this.y, this.s);
  // Sorta-equality that skips steps for equality checks
  bool operator==(Object? o) => o is Point && x == o.x && y == o.y;
  int get hashCode => Object.hash(x, y);
}

void main() async {
  Grid<String> garden = Grid.string(await File('input.txt').readAsString(), (e) => e);

  Point start = Point(-1, -1, -1);
  garden.every((x, y, e) => e == 'S' ? start = Point(x, y, 0) : 0);


  Set<Point> seen = {};
  Queue<Point> options = Queue()..add(start);

  while (options.isNotEmpty) {
    Point now = options.removeFirst();
    if (seen.contains(now))
      continue;
    seen.add(now);

    garden.adjacent(now.x, now.y,
      (x, y, el) {
        Point next = Point(x, y, now.s + 1);
        if (el != '#') {
          options.add(next);
        }
    });
  }

  int steps = 64;
  print('Part 1: ${seen.where((e) => e.s % 2 == 0 && e.s <= steps).length}');

  // Number of whole gardens we can cross in 26501365 steps minus the one we start in
  int half = (garden.width ~/ 2);
  int n = (26501365 - half) ~/ garden.width;
  print(n);

  // Half the gardens it's only possible to step on odd tiles
  // and other half only even tiles. First garden is odd.
  int fullOdd = (n + 1) * (n + 1) * seen.where((e) => e.s % 2 == 1).length;
  int fullEven = n * n * seen.where((e) => e.s % 2 == 0).length;

  // Finally, because the steps expands in a diamond shape, there will be n
  // corners that are within reach inverse to the number of full gardens we
  // have passed through.
  int cornersOdd = (n + 1) * seen.where((e) => e.s % 2 == 1 && e.s > half).length;
  int cornersEven = n * seen.where((e) => e.s % 2 == 0 && e.s > half).length;

  print('Part 2: ${fullOdd + fullEven - cornersOdd + cornersEven}');

  /*
    Can also be solved by solving for f(x): ax^2 + bx + c through:

    1. Get step count for:
      y0 steps(131*0+65) -> ?
      y1 steps(131*1+65) -> ?
      y2 steps(131*2+65) -> ?

    2.Solve:
      a = (y0 - 2y1 + y2) / 2
      b = (-3y0 + 2y1 - y2) / 2
      c = y0

    3. 26501365 -> 131 * 202300 + 65

    4. f(202300) -> a * 202300^2 + b * 202300 + c -> answer
   */
}