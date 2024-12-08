import 'dart:math';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:trotter/trotter.dart';

num distance(int x1, int y1, int x2, int y2) => sqrt(pow(x2- x1, 2) + pow(y2 - y1, 2));

void main() async {
  Grid<String> grid = Grid.string(await aoc.getInputString(), (e) => e);

  // All antennas in the city
  Map<String, List<(int, int)>> antennas = {};
  grid.every((x, y, e) {
    (antennas[e] ??= []).add((x , y));
  });
  antennas.remove('.');

  Set<(int, int)> antinodes1 = {}, antinodes2 = {};
  for (String ant in antennas.keys) {
    for (final comb in Combinations(2, antennas[ant]!)()) {
      // Line equation for antenna pair
      num m = (comb[0].$2 - comb[1].$2) / (comb[0].$1 - comb[1].$1);
      num b = comb[0].$2 - m * comb[0].$1;
      num Function(int) f = (int x) => x * m + b;

      // Find points on grid that are on the line
      for (int x = 0; x < grid.width; x++) {
        num y = f(x) + 0.00001; // For .999... truncation errors
        int yi = y.toInt();
        if (grid.outOfBounds(x, yi)) {
          continue;
        }
        // Part 1 condition met if difference of distance is 2 or 1/2
        num diff = distance(comb[0].$1, comb[0].$2, x, yi) / distance(comb[1].$1, comb[1].$2, x, yi);
        if (diff == 2.0 || diff == 0.5) {
          antinodes1.add((x, yi));
        }
        // Part 2 condition met as long as y is an integer value
        if ((y - yi).abs() < 0.01) {
          antinodes2.add((x, yi));
        }
      }
    }
  }
  print('Part 1: ${antinodes1.length}');
  print('Part 2: ${antinodes2.length}');
}