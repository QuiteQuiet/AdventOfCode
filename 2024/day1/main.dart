import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

void main() async {
  List<String> lines = await aoc.getInput();

  List<int> left = [], right = [];
  for (String line in lines) {
    var [l, r] = line.numbers();
    left..add(l)..sort();
    right..add(r)..sort();
  }

  int sum = 0;
  for (final (int i, int el) in left.indexed) {
    sum += (el - right[i]).abs();
  }
  print('Part 1: $sum');

  Set<int> s = Set.from(left);
  int similarity = right.where(s.contains).reduce((a, b) => a + b);
  print('Part 2: $similarity');
}