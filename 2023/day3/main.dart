import 'dart:io';

import 'package:AdventOfCode/string.dart';
import 'package:AdventOfCode/grid.dart';

bool isNumber(String s) => switch (s) {
  '0' || '1' || '2' || '3' || '4' || '5' || '6' || '7' || '8' || '9' => true,
  _ => false,
};

void main() async {
  String input = await File('input.txt').readAsString();
  Grid<String> grid = Grid.from(input.split('\n').map((e) => e.trim().split('')));
  Set<String> symbols = Set.from(
    RegExp(r'[^0-9\.]').allMatches(input).map((e) => e.group(0)!));

  int sum = 0, ratio = 0;
  grid.every((int x, int y, String e) {
    if (symbols.contains(e)) {
      List<int> xDim = [if (x - 1 >= 0) x - 1,
                        x,
                        if (x + 1 < grid.width) x + 1];
      List<int> yDim = [if (y - 1 >= 0) y - 1,
                        y,
                        if (y + 1 < grid.height) y + 1];

      Set<int> foundNumbers = {};
      for (int newY in yDim) {
        for (int newX in xDim) {
          if (isNumber(grid.at(newX, newY))) {
            // Find first character of the number
            while (newX >= 0 && isNumber(grid.at(newX - 1, newY)))
              newX--;
            foundNumbers.add(
              grid.takeFromWhile(newX, newY, isNumber).join('').toInt());
          }
        }
      }
      sum += foundNumbers.reduce((a, b) => a + b);
      if (foundNumbers.length == 2 && e == '*') {
        ratio += foundNumbers.first * foundNumbers.last;
      }
    }
  },);

  print('Part 1: $sum');
  print('Part 2: $ratio');
}