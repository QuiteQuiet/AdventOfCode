import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/space.dart';
import 'package:trotter/trotter.dart';

void main() async {
  Grid<String> grid = Grid.string(await aoc.getInputString(), (e) => e);

  // All antennas in the city
  Map<String, List<Point>> antennas = {};
  grid.every((x, y, e) {
    (antennas[e] ??= []).add(Point(x , y));
  });
  antennas.remove('.');

  Set<(int, int)> antinodes1 = {}, antinodes2 = {};
  for (String ant in antennas.keys) {
    for (final comb in Combinations(2, antennas[ant]!)()) {
      // Line equation for antenna pair
      Line line = Line(comb[0], comb[1]);

      // Find points on grid that are on the line
      for (int x = 0; x < grid.width; x++) {
        num y = line.findY(x) + 0.00001; // For .999... truncation errors
        int yi = y.toInt();
        if (grid.outOfBounds(x, yi)) {
          continue;
        }
        // Part 1 condition met if difference of distance is 2 or 1/2
        Point p = Point(x, yi);
        num diff = p.euclidianDist(comb[0]) / p.euclidianDist(comb[1]);
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