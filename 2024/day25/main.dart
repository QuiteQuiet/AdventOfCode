import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  String input = (await aoc.getInputString()).replaceAll('#', '1').replaceAll('.', '0').replaceAllMapped(RegExp(r'([01])\n'), (m) => m.group(1)!);
  List<int> things = input.split('\n').map((n) => int.parse(n, radix: 2)).toList();

  int unique = 0;
  for (final (int i, int thing) in things.indexed) {
    for (int ii = i + 1; ii < things.length; ii++) {
      unique += thing & things[ii] == 0 ? 1 : 0;
    }
  }
  print('Part 1: $unique');
}