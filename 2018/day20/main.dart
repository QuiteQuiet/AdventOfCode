import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/space.dart';

void main() async {
  String regex = await aoc.getInputString();
  List<Point> paths = [Point(0, 0)];

  Point current = paths.last;

  List<Point> stack = [];
  for (int ascii in regex.runes) {
    String char = String.fromCharCode(ascii);
    switch (char) {
      case 'W':
        paths.add(Point(current.xi - 1, current.yi));
        paths.add(Point(current.xi - 2, current.yi));
        current = paths.last;
      case 'E':
        paths.add(Point(current.xi + 1, current.yi));
        paths.add(Point(current.xi + 2, current.yi));
        current = paths.last;
      case 'N':
        paths.add(Point(current.xi, current.yi - 1));
        paths.add(Point(current.xi, current.yi - 2));
        current = paths.last;
      case 'S':
        paths.add(Point(current.xi, current.yi + 1));
        paths.add(Point(current.xi, current.yi + 2));
        current = paths.last;
      case '(':
        stack.add(current);
      case ')':
        stack.removeLast();
      case '|':
        current = stack.last;
      default:
    }
  }
  Point start = Point(105, 105);
  Grid<String> maze = Grid.filled(205, 205, ' ');
  for (Point p in paths) {
    maze.putPoint(p + start, '.');
  }

  int longest = 0, atLeast1000 = 0;
  List<(Point, int)> toDo = [(start, 0)];
  Set<Point> visited = {};
  while (toDo.isNotEmpty) {
    final (Point cur, int weight) = toDo.removeLast();
    if (!visited.add(cur)) {
      continue;
    }

    if (weight % 2 == 0) { // Odd counts are doors
      if (weight > longest) {
        longest = weight;
      }
      if (weight >= 2000) {
        atLeast1000++;
      }
    }

    maze.adjacent(cur.xi, cur.yi, (x, y, el) {
      if (el == '.') {
        toDo.add((Point(x, y), weight + 1));
      }
    });
  }

  print('Part 1: ${longest ~/ 2}');
  print('Part 2: $atLeast1000');
}
