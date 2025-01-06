import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';

int countTrees(Grid<String> trees, int xd, int yd) {
  int x = 0, y = 0, encounters = 0;
  while (!trees.outOfBounds(x, y)) {
    if (trees.at(x, y) == '#')
      encounters++;
    x = (x + xd) % trees.width;
    y += yd;
  }
  return encounters;
}

void main() async {
  Grid<String> trees = Grid.string(await aoc.getInputString(), (p0) => p0);
  List<int> slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)].map((e) => countTrees(trees, e.$1, e.$2)).toList();

  print('Part 1: ${slopes[1]}');
  print('Part 2: ${slopes.reduce((a, b) => a * b)}');
}
