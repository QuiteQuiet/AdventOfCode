import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:trotter/trotter.dart';

int conwaysCubes(List<String> lines, int usedDimensions) {
  Set<(int, int, int, int)> activeCubes = {};
  for (final (int i, String line) in lines.indexed)
    for (int ii = 0; ii < line.length; ii++)
      if (line[ii] == '#')
        activeCubes.add((ii, i, 0, 0));

  for (int rounds = 0; rounds < 6; rounds++) {
    Map<(int, int, int, int), int> neighbours = {};
    for (var pebble in activeCubes) {
      for (final amalg in Amalgams(usedDimensions, [-1, 0, 1])()) {
        if (amalg.every((e) => e == 0)) continue;
        (int, int, int, int) next = (pebble.$1 + amalg[0],
                                     pebble.$2 + amalg[1],
                                     pebble.$3 + amalg[2],
                                     usedDimensions == 4 ? pebble.$4 + amalg[3] : 0);
        neighbours.update(next, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    Set<(int, int, int, int)> next = {};
    for ((int, int, int, int) key in neighbours.keys) {
      int count = neighbours[key]!;
      if (activeCubes.contains(key)) {
        if (count == 2 || count == 3)
          next.add(key);
      } else if (count == 3) {
        next.add(key);
      }
    }
    activeCubes.clear();
    activeCubes = next;
  }
  return activeCubes.length;
}

void main() async {
  List<String> lines = await aoc.getInput();

  print('Part 1: ${conwaysCubes(lines, 3)}');
  print('Part 2: ${conwaysCubes(lines, 4)}');
}
