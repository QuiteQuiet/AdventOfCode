import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/space.dart';
import 'package:AdventOfCode/string.dart';

void main() async {
  List<(String, int)> instructions = (await aoc.getInput()).map((e) => (e[0], e.substring(1).toInt())).toList();

  Point rotate(Point dir, int degrees) {
    for (int i = 0; i < degrees ~/ 90; i++)
      dir = Point(-dir.yi, dir.xi);
    return dir;
  }

  Point ferry = Point(0, 0), dir = Point(1, 0);
  for (final (String act, int value) in instructions) {
    switch (act) {
      case 'W': ferry += Point(-1, 0) * value;
      case 'E': ferry += Point(1, 0) * value;
      case 'N': ferry += Point(0, -1) * value;
      case 'S': ferry += Point(0, 1) * value;
      case 'F': ferry += dir * value;
      default: dir = rotate(dir, act == 'R' ? value : 360 - value);
    }
  }
  print('Part 1: ${ferry.manhattanDist(Point(0, 0))}');

  ferry = Point(0, 0);
  Point waypoint = Point(10, -1);
  for (final (String act, int value) in instructions) {
    switch (act) {
      case 'W': waypoint += Point(-1, 0) * value;
      case 'E': waypoint += Point(1, 0) * value;
      case 'N': waypoint += Point(0, -1) * value;
      case 'S': waypoint += Point(0, 1) * value;
      case 'F': ferry += waypoint * value;
      default: waypoint = rotate(waypoint, act == 'R' ? value : 360 - value);
    }
  }
  print('Part 2: ${ferry.manhattanDist(Point(0, 0))}');
}
