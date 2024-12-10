import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';


void main() async {
  Grid<int> map = Grid.string(await aoc.getInputString(), int.parse);

 List<(int, int)> findTrails(int x, int y) {
    if (map.at(x, y) == 9) {
      return [(x, y)];
    }
    List<(int, int)> trails = [];
    map.adjacent(x, y, (nx, ny, el) {
      if (el - map.at(x, y) == 1) {
        trails.addAll(findTrails(nx, ny));
      }
    });
    return trails;
  }

  int nines = 0, unique = 0;
  map.every((x, y, e) {
    if (e == 0) {
      List<(int, int)> trails = findTrails(x, y);
      nines += Set.from(trails).length;
      unique += trails.length;
    }
  });
  print('Part 1: $nines');
  print('Part 2: $unique');
}