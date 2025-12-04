import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/space.dart';

void main() async {
  Grid<String> papers = Grid.string(await aoc.getInputString(), (e) => e);

  int possible = 0;
  List<Point> coords = [Point(-1, -1)];
  while (coords.isNotEmpty) {
    coords.clear();
    papers.every((x, y, e) {
      if (e == '.') return;

      int count = 0;
      papers.neighbours(x, y, (_x, _y, ne) {
        if (ne == '@') {
          count++;
        }
      });
      if (count < 4) {
        coords.add(Point(x, y));
      }
    });
    if (possible == 0) {
      print('Part 1: ${coords.length}');
    }
    for (Point coord in coords) {
      papers.putPoint(coord, '.');
    }
    possible += coords.length;
  }
  print('Part 2: $possible');
}
