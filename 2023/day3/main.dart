import 'dart:io';

import 'package:AdventOfCode/string.dart';
import 'package:AdventOfCode/grid.dart';

bool isNumber(String s) => switch (s) {
  '0' || '1' || '2' || '3' || '4' || '5' || '6' || '7' || '8' || '9' => true,
  _ => false,
};

void main() async {
  Grid<String> input = Grid.string(await File('input.txt').readAsString(), (e) => e);
  Set<String> noise = {'.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

  int sum = 0, ratio = 0;
  input.every((int x, int y, String e) {
    if (!noise.contains(e)) {
      Set<int> foundNumbers = {};
      input.neighbours(x, y, (nx, ny, el) {
        if (isNumber(el)) {
          while (nx >= 0 && isNumber(input.at(nx - 1, ny)))
            nx--;
          foundNumbers.add(
            input.takeFromWhile(nx, ny, isNumber).join('').toInt());
        }
      });
      sum += foundNumbers.reduce((a, b) => a + b);
      if (foundNumbers.length == 2 && e == '*') {
        ratio += foundNumbers.first * foundNumbers.last;
      }
    }
  },);

  print('Part 1: $sum');
  print('Part 2: $ratio');
}