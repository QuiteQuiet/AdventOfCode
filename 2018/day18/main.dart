import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';

int score(Grid<String> map) {
  int trees = 0, lumberyards = 0;
  map.every((x, y, e) {
    switch (e) {
      case '|': trees++;
      case '#': lumberyards++;
      default:
    }
  });
  return trees * lumberyards;
}

void main() async {
  Grid<String> acres = Grid.string(await aoc.getInputString(), (p0) => p0);

  Map<int, int> counter = {};
  List<int> sequence = [];
  int maxTicks = 1000;
  for (int tick = 0; tick < maxTicks; tick++) {
    Grid<String> copy = Grid.copy(acres);

    acres.every((x, y, e) {
      int trees = 0, lumberyards = 0;
      acres.neighbours(x, y, (_1, _2, el) {
        switch (el) {
          case '|': trees++;
          case '#': lumberyards++;
          default:
        }
      });
      switch (e) {
        case '.': if (trees >= 3) copy.put(x, y, '|');
        case '|': if (lumberyards >= 3) copy.put(x, y, '#');
        case '#': if (trees < 1 || lumberyards < 1) copy.put(x, y, '.');
        default:
      }
    });
    sequence.add(score(acres));
    counter[sequence.last] = (counter[sequence.last] ?? 0) + 1;
    if (counter[sequence.last]! > 2) {
      break;
    }

    acres = copy;
  }
  print('Part 1: ${sequence[10]}');

  int cycleLength = 0, cycleStart = 0, toFind = counter[sequence.last]!;
  for (int i = sequence.length - 1; i >= 0; i--) {
    if (sequence[i] == sequence.last) {
      toFind--;
    }
    if (toFind == 0) {
      cycleStart = i;
      cycleLength = (sequence.length - i) ~/ (counter[sequence.last]! - 1);
      break;
    }
  }
  int goal = 1000000000 - cycleStart;
  print('Part 2: ${sequence[cycleStart + goal - (goal ~/ cycleLength) * cycleLength]}');
}
