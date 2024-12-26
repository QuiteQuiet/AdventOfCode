import 'dart:math';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/space.dart';
import 'package:AdventOfCode/string.dart';

void main() async {
  List<Vector> stars = (await aoc.getInput()).map(
    (e) {
      List<int> numbers = e.numbers();
      return Vector([numbers[0], numbers[1]], [numbers[2], numbers[3]]);
  }).toList();

  int seconds = 0;
  bool ready = false;
  while (!ready) {
    int? low, high;
    for (final (int i, Vector star) in stars.indexed) {
      stars[i] = star.once();
      int h = stars[i].origin[1].toInt();
      low = min(low ??= h, h);
      high = max(high ??= h, h);
    }
    if ((low! - high!).abs() <= 10) {
      ready = true;
    }
    seconds++;
  }

  Grid<String> sky = Grid.filled(62, 10, ' ');
  int wz = 1000, hz = 1000;
  for (Vector star in stars) {
    wz = min(wz, star.origin[0].toInt());
    hz = min(hz, star.origin[1].toInt());
  }
  for (Vector star in stars) {
    int x = star.origin[0].toInt() - wz, y = star.origin[1].toInt() - hz;
    sky.put(x, y, '#');
  }
  print('Part 1:');
  print(sky);
  print('Part 2: $seconds');
}