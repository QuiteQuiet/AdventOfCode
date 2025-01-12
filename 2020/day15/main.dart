import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

int recite(List<int> numbers, int rounds) {
  List<int> firstTime = List.filled(rounds, -1), secondTime = List.filled(rounds, -1);

  numbers.indexed.forEach((e) => firstTime[e.$2] = e.$1);

  int lastNumber = numbers.last;
  for (int turn = numbers.length; turn < rounds; turn++) {
    int say = 0;
    if (secondTime[lastNumber] != -1) {
      say = secondTime[lastNumber] - firstTime[lastNumber];
    }
    if (firstTime[say] != -1) {
      if (secondTime[say] != -1) {
        firstTime[say] = secondTime[say];
      }
      secondTime[say]= turn;
    } else {
      firstTime[say] = turn;
    }
    lastNumber = say;
  }
  return lastNumber;
}

void main() async {
  List<int> numbers = (await aoc.getInputString()).numbers();

  print('Part 1: ${recite(numbers, 2020)}');
  print('Part 1: ${recite(numbers, 30000000)}');
}
