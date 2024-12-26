import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/string.dart';

void main() async {
  int serial = (await aoc.getInputString()).numbers()[0];

  int size = 300;
  Grid<int> fuelCells = Grid.generate(size, size, (i) {
    int x = i % size + 1, y = i ~/ size + 1;
    int id = x + 10;
    int power = (id * y + serial) * id;
    int digit = (power ~/ 100) % 10;
    return digit - 5;
  });

  List<Grid<int>> windows = [fuelCells];
  for (int windowSize = 1; windowSize < size; windowSize++) {
    int cells = size - windowSize;
    windows.add(Grid.generate(cells, cells, (idx) {
      int x = idx % cells, y = idx ~/ cells;
      int score = windows[windowSize - 1].at(x, y);
      for (int xi = 0; xi <= windowSize; xi++) {
        score += fuelCells.at(x + xi, y + windowSize);
      }
      for (int yi = 0; yi < windowSize; yi++) {
        score += fuelCells.at(x + windowSize, y + yi);
      }
      return score;
    }));
  }

  (int, int, int) biggestScore(Grid<int> cells) {
    (int, int, int) best = (0, 0, -1000);
    cells.every((x, y, e) {
      if (e > best.$3) {
        best = (x + 1, y + 1, e);
      }
    });
    return best;
  }

  (int, int, int) best = biggestScore(windows[2]);
  print('Part 1: ${best.$1},${best.$2}');

  (int, int, int, int) best2 = (0, 0, 0, -1000);
  for (final (int i, Grid<int> cur) in windows.indexed) {
    (int, int, int) next = biggestScore(cur);
    if (next.$3 > best2.$4) {
      best2 = (next.$1, next.$2, i + 1, next.$3);
    }
  }
  print('Part 2: ${best2.$1},${best2.$2},${best2.$3}');
}