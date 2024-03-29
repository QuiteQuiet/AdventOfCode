import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

import 'dart:math';

dynamic convert(String s) => int.tryParse(s) ?? s;

void main() async {
  List<String> lines = await aoc.getInput();
  int possibleSum = 0, powerSum = 0;
  for (String line in lines) {
    List<List<dynamic>> pulls = RegExp(r'(\w+) (\w+)').allMatches(line).map(
      (e) => [convert(e.group(1)!), convert(e.group(2)!)]).toList();

    int red = 0, green = 0, blue = 0, game = 0;
    pulls.forEach((element) => switch (element) {
        [int c, 'red'] => red = max(c, red),
        [int c, 'green'] => green = max(c, green),
        [int c, 'blue'] => blue = max(c, blue),
        _ => game = element[1],
    });
    if (red <= 12 && green <= 13 && blue <= 14) {
      possibleSum += game;
    }
    powerSum += red * green * blue;
  }
  print('Part 1: $possibleSum');
  print('Part 2: $powerSum');
}