import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

import 'package:AdventOfCode/grid.dart';

Grid<String> tilt(Grid<String> rocks, Function(int, int) next) {
  bool movedAny;
  do {
    movedAny = false;
    rocks.every((x, y, e) {
      ({int x, int y}) newPos = next(x, y);
      if (e == 'O' &&
          newPos.x >= 0 && newPos.x < rocks.width &&
          newPos.y >= 0 && newPos.y < rocks.height &&
          rocks.at(newPos.x, newPos.y) == '.') {
        rocks.put(newPos.x, newPos.y, e);
        rocks.put(x, y, '.');
        movedAny = true;
      }
    },);
  } while (movedAny);
  return rocks;
}

void main() async {
  Grid<String> stones = Grid.string((await aoc.getInputString()), (e) => e);
  Grid<String> once;

  once = tilt(Grid.copy(stones), (x, y) => (x: x, y: y - 1));

  int load = 0;
  once.every((x, y, e) => load += e == 'O' ? once.height - y : 0);

  print('Part 1: $load');

  int iterations = 1000000000;
  // Find where the pattern stop changing
  List<String> seen = [];
  int cycleStart = 0;
  for (int i = 0; i < iterations; i++) {
    stones = tilt(stones, (x, y) => (x: x, y: y - 1)); // North
    stones = tilt(stones, (x, y) => (x: x - 1, y: y)); // West
    stones = tilt(stones, (x, y) => (x: x, y: y + 1)); // South
    stones = tilt(stones, (x, y) => (x: x + 1, y: y)); // East

    String hash = stones.toString();
    if (seen.contains(hash)) {
      cycleStart = seen.indexOf(hash);
      break;
    }
    seen.add(hash);
  }
  List<String> cycle = List.from(seen.sublist(cycleStart));
  load = 0;
  Grid.string(cycle[(iterations - cycleStart - 1) % cycle.length], (e) => e)
    .every((x, y, e) => load += e == 'O' ? stones.height - y : 0);

  print('Part 2: $load');
}