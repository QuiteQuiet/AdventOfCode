import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/int.dart';
import 'package:AdventOfCode/string.dart';

bool valid(List<int> numbers) {
  bool increasing = numbers[0] < numbers[1];
  for (int i in 0.to(numbers.length - 2)) {
    if (numbers[i] == numbers[i + 1])
      return false;
    if (increasing && (numbers[i] > numbers[i + 1] || numbers[i + 1] - numbers[i] > 3))
      return false;
    if (!increasing && (numbers[i] < numbers[i + 1] || numbers[i] - numbers[i + 1] > 3))
      return false;
  }
  return true;
}

void main() async {
  List<String> lines = await aoc.getInput();
  List<List<int>> entries = lines.map((e) => e.numbers()).toList();

  int safe = entries.where(valid).length;
  int fixed = entries.where(
    (e) => e.indexed.any((el) => valid(List.from(e)..removeAt(el.$1)))).length;

  print('Part 1: $safe');
  print('Part 2: $fixed');
}