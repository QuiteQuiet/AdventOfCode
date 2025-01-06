import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

(int, int) sumNumbers(List<int> numbers) {
  int two = 0, three = 0;
  for (final (int i, int a) in numbers.indexed)
    for (final (int ii, int b) in numbers.skip(i + 1).indexed) {
      for (int c in numbers.skip(ii + 1))
        if (a + b + c == 2020)
          three = a * b * c;
      if (a + b == 2020)
        two = a * b;
    }
  return (two, three);
}

void main() async {
  (int, int) res = sumNumbers((await aoc.getInput()).map(int.parse).toList());
  print('Part 1: ${res.$1}');
  print('Part 2: ${res.$2}');
}