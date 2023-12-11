import 'dart:io';
import 'package:AdventOfCode/grid.dart';
import "package:trotter/trotter.dart";

int distance(Grid<String> input, List<(int, int)> galaxies, int multiplier) {
  // Recalculate dimensions
  List<int> cols = List.generate(input.width, (i) => i)..sort();
  List<int> rows = List.generate(input.height, (i) => i)..sort();
  galaxies.forEach((e) {
    cols.remove(e.$1);
    rows.remove(e.$2);
  });

  List<(int, int)> newGalaxies = [];
  galaxies.forEach((e) {
    int x = e.$1, y = e.$2;
    x += cols.where((e) => e < x).length * (multiplier - 1);
    y += rows.where((e) => e < y).length * (multiplier - 1);
    newGalaxies.add((x, y));
  });

  // Manhattan distance
  int d = 0;
  for (final List<(int, int)> c in Combinations(2, newGalaxies)()) {
    d += (c[0].$1 - c[1].$1).abs() + (c[0].$2 - c[1].$2).abs();
  }
  return d;
}

void main() async {
  Grid<String> input = Grid.from(
    (await File('input.txt').readAsLines()).map((e) => e.split('')));

  List<(int, int)> galaxies = [];
  input.every((x, y, e) {
    if (e == '#') {
      galaxies.add((x, y));
    }
  });

  print('Part 1: ${distance(input, galaxies, 2)}');
  print('Part 2: ${distance(input, galaxies, 1000000)}');
}