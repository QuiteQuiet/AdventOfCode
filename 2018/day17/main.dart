import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/int.dart';
import 'package:AdventOfCode/space.dart';
import 'package:AdventOfCode/string.dart';

void main() async {
  List<String> lines = await aoc.getInput();

  int lowest = 0, highest = 2000;
  Grid reservoirs = Grid.filled(1000, 2000, '.');
  reservoirs.put(500, 0, '+');
  for (String line in lines) {
    List<int> numbers = line.numbers();
    for (int i in numbers[1].to(numbers[2])) {
      if (line[0] == 'x') {
        reservoirs.put(numbers[0], i, '#');
        lowest = lowest < i ? i : lowest;
        highest = highest > i ? i : highest;
      } else {
        reservoirs.put(i, numbers[0], '#');
        lowest = lowest < numbers[0] ? numbers[0] : lowest;
        highest = highest > numbers[0] ? numbers[0] : highest;
      }
    }
  }

  Point down = Point(0, 1), left = Point(-1, 0), right = Point(1, 0);
  Set<Point> waterTile = {};

  List<(Point, Point)> stack = [(Point(500, highest), down)];
  while (stack.isNotEmpty) {
    final (Point cur, Point dir) = stack.removeLast();
    if (cur.yi > lowest ||
        (dir.xi != 0 && '.v'.contains(reservoirs.atPoint(Point(cur.xi - dir.xi, cur.yi + 1)))) ||
        !waterTile.add(cur)) {
      continue;
    }
    reservoirs.putPoint(cur, 'v');

    int leftEdge = cur.xi, rightEdge = cur.xi;
    for (int i = leftEdge; i >= 0; i--) {
      if (reservoirs.at(i, cur.yi) == '#') {
        leftEdge = i;
        break;
      }
    }
    for (int i = rightEdge; i < reservoirs.width; i++) {
      if (reservoirs.at(i, cur.yi) == '#') {
        rightEdge = i;
        break;
      }
    }

    if (leftEdge != cur.xi && rightEdge != cur.xi) {
      bool floor = true;
      Point below = cur + down;
      for (int i = leftEdge; i < rightEdge; i++) {
        if ('.v'.contains(reservoirs.at(i, below.yi))) {
          floor = false;
        }
      }
      if (floor) {
        bool resting = true;
        for (int i = leftEdge + 1; i < rightEdge; i++) {
          if (reservoirs.at(i, cur.yi) != 'v') {
            resting = false;
          }
        }
        if (resting) {
          for (int i = leftEdge + 1; i < rightEdge; i++) {
            Point p = Point(i, cur.yi);
            reservoirs.putPoint(p, '~');
          }
          if (rightEdge - leftEdge == 2) {
            int y = cur.yi;
            while (reservoirs.at(leftEdge, y) == '#' && reservoirs.at(rightEdge, y) == '#') {
              reservoirs.put(leftEdge + 1, y--, '~');
            }
          }
        }
      }
    }

    for (Point move in [right, left, down]) {
      Point next = cur + move;
      if (reservoirs.atPoint(next) == '.') {
        stack.add((next, move));
      }
    }
  }

  int still = 0, flowing = 0;
  reservoirs.every((x, y, e) {
      if (e == '~')
        still++;
      if (e == 'v')
        flowing++;
  });
  print('Part 1: ${still + flowing}');
  print('Part 2: $still');
}
