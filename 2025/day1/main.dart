import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

void main() async {
  List<String> lines = await aoc.getInput();

  int dial = 50, zeros = 0, passes = 0;
  for (String op in lines) {
    int times = op.substring(1).toInt();

    int start = dial;
    dial = switch (op[0]) {
      'R' => dial + times,
      _ => dial - times,
    };
    passes += dial.abs() ~/ 100;
    if (dial <= 0 && start != 0) passes++;

    dial %= 100;
    if (dial == 0) {
      zeros++;
    }
  }
  print('Part 1: $zeros');
  print('Part 2: $passes');
}
