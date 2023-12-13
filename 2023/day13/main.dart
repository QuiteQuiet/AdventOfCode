import 'dart:io';

import 'package:AdventOfCode/grid.dart';

int isValid(Grid<String> ground, int xbound, int ybound, int prev, bool vertical) {
  int bound = vertical ? xbound : ybound;
  for (int start = 0; start < bound - 1; start++) {
    bool ok = true;
    int gap = 1;
    if (!vertical) {
      for (int r = start; r >= 0 && r + gap < ybound; r--) {
        ok = r != prev;
        for (int c = 0; c < xbound; c++) {
          if (ground.at(c, r) != ground.at(c, r + gap)) {
            ok = false;
          }
        }
        if (!ok) break;
        gap += 2;
      }
    } else {
      for (int c = start; c >= 0 && c + gap < xbound; c--) {
        ok = c != prev;
        for (int r = 0; r < ybound; r++) {
          if (ground.at(c, r) != ground.at(c + gap, r)) {
            ok = false;
          }
        }
        if (!ok)
          break;
        gap += 2;
      }
    }
    if (ok)
      return start + 1;
  }
  return 0;
}
void main() async {
  List<String> input = (await File('input.txt').readAsString()).split('\r\n\r\n');

  int sum = 0, sum2 = 0;
  for (String line in input) {
    Grid<String> ground = Grid.from(line.split('\r\n').map((e) => e.split('')));
    int vert = isValid(ground, ground.width, ground.height, -1, false);
    int horiz = isValid(ground, ground.width, ground.height, -1, true);
    sum += vert * 100 + horiz;

    bool found = false;
    ground.every((x, y, e) {
      if (found) return;

      ground.put(x, y, e == '.' ? '#' : '.');
      int vert2 = isValid(ground, ground.width, ground.height, vert - 1, false);
      int horiz2 = isValid(ground, ground.width, ground.height, horiz - 1, true);
      ground.put(x, y, e);

      sum2 += vert2 * 100 + horiz2;

      if (vert2 > 0 || horiz2 > 0) {
        found = true;
      }

    });
  }
  print('Part 1: $sum');
  print('Part 2: $sum2');
}