import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';

void main() async {
  Grid<String> input = Grid.string(await aoc.getInputString(), (e) => e);

  String goal = 'XMAS';
  List<(int, int)> directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)];

  int xmas = 0;
  input.every((x, y, e) {
    if (e != 'X') return;
    for (final (int dx, int dy) in directions) {
      int found = 1;
      for (int d in [1, 2, 3]) {
        int nx = x + dx * d, ny = y + dy * d;
        if (!input.outOfBounds(nx, ny) && input.at(nx, ny) == goal[d]) {
          found++;
        }
      }
      if (found == goal.length) {
        xmas++;
      }
    }
  });
  print('Part 1: $xmas');

  goal = 'MASSM';
  List<List<(int, int)>> cross = [[(-1, -1), (1, -1)], [(-1, -1), (-1, 1)], [(-1, 1), (1, 1)], [(1, -1), (1, 1)]];

  xmas = 0;
  input.every((x, y, e) {
    if (e != 'A') return;
    for (final direction in cross) {
      int found = 1;
      for (final (int dx, int dy) in direction) {
        for (int d in [1, -1]) {
          int nx = x + dx * d, ny = y + dy * d;
          if (!input.outOfBounds(nx, ny) && input.at(nx, ny) == goal[1 + d]) {
            found++;
          }
        }
      }
      if (found == goal.length) {
        xmas++;
      }
    }
  });
  print('Part 2: $xmas');
}