import 'dart:math';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

List<int> blink(int stone) {
  if (stone == 0) {
    return [1];
  }
  String s = stone.toString();
  if (s.length % 2 == 1) {
    return [stone * 2024];
  }
  return [stone ~/ pow(10, s.length ~/ 2),
          stone % pow(10, s.length ~/ 2).toInt()];
}

Map<int, int> blinkAll(Map<int, int> stones) {
  Map<int, int> next = {};
    for (final int stone in stones.keys) {
      for (int s in blink(stone)) {
        next[s] = (next[s] ?? 0) + stones[stone]!;
      }
    }
  return next;
}

Map<int, int> blinkN(Map<int, int> stones, int blinks) {
  for (int b = 0; b < blinks; b++) {
    stones = blinkAll(stones);
  }
  return stones;
}

void main() async {
  Map<int, int> input = Map.fromIterable(
    (await aoc.getInputString()).numbers(), key: (e) => e, value: (_) => 1);

  print('Part 1: ${blinkN(input, 25).values.reduce((a, b) => a + b)}');
  print('Part 2: ${blinkN(input, 75).values.reduce((a, b) => a + b)}');
}