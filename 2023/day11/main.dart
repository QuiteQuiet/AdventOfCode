import 'dart:io';
import 'package:AdventOfCode/grid.dart';
import "package:trotter/trotter.dart";

int distance(List<(int, int, int, int)> galaxies, int multiplier) {
  int real(int coord, int blanks) => coord + blanks * (multiplier - 1);
  // Manhattan distance
  int d = 0;
  for (final List<(int, int, int, int)> c in Combinations(2, galaxies)()) {
    d += (real(c.first.$1, c.first.$3) - real(c.last.$1, c.last.$3)).abs();
    d += (real(c.first.$2, c.first.$4) - real(c.last.$2, c.last.$4)).abs();
  }
  return d;
}

void main() async {
  Grid<String> input = Grid.string(await File('input.txt').readAsString(), (e) => e);

  List<(int, int)> galaxies = [];
  input.every((x, y, e) {
    if (e == '#') {
      galaxies.add((x, y));
    }
  });
  List<int> cols = List.generate(input.width, (i) => i);
  List<int> rows = List.generate(input.height, (i) => i);
  galaxies.forEach((e) {
    cols.remove(e.$1);
    rows.remove(e.$2);
  });

  List<(int, int, int, int)> newGalaxies = [];
  galaxies.forEach((g) {
    int ex = cols.where((e) => e < g.$1).length;
    int ey = rows.where((e) => e < g.$2).length;
    newGalaxies.add((g.$1, g.$2, ex, ey));
  });

  print('Part 1: ${distance(newGalaxies, 2)}');
  print('Part 2: ${distance(newGalaxies, 1000000)}');
}