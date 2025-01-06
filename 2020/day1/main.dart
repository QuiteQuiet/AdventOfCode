import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  List<int> numbers = (await aoc.getInput()).map(int.parse).toList();

  int two = 0, three = 0;
  for (final (int i, int a) in numbers.indexed)
    for (final (int ii, int b) in numbers.skip(i + 1).indexed) {
      for (int c in numbers.skip(ii + 1))
        if (a + b + c == 2020)
          three = a * b * c;
      if (a + b == 2020)
        two = a * b;
    }

  print('Part 1: $two');
  print('Part 2: $three');
}