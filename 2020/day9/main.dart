import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/int.dart';

void main() async {
  List<int> input = (await aoc.getInput()).map(int.parse).toList();
  List<int> preamble = input.sublist(0, 25);

  bool possible(int target) {
    for (final (int i, int a) in preamble.indexed)
      for (int b in preamble.skip(i + 1))
        if (a + b == target)
          return true;
    return false;
  }

  int replace = 0, invalid = 0;
  for (int index in preamble.length.to(input.length - 1)) {
    if (possible(input[index])) {
      preamble[replace] = input[index];
      replace = (replace + 1) % preamble.length;
    } else {
      invalid = input[index];
      break;
    }
  }
  print('Part 1: $invalid');

  int i = 0, ii = 0, sum = 0;
  while (sum != invalid) {
    ii = i++; sum = 0;
    while (sum < invalid) sum += input[ii++];
  }
  List<int> range = input.sublist(i - 1, ii)..sort();
  print('Part 2: ${range.first + range.last}');
}
