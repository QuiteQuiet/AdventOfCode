import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  List<String> lines = await aoc.getInput();

  int valid1 = 0, valid2 = 0;
  for (String line in lines) {
    List<String> parts = line.split(' ');
    List<int> digits = parts[0].split('-').map(int.parse).toList();

    int matches = parts[1][0].allMatches(parts[2]).length;
    if (digits[0] <= matches && matches <= digits[1])
      valid1++;

    bool first = parts[2][digits[0] - 1] == parts[1][0],
         second = parts[2][digits[1] - 1] == parts[1][0];
    if ((first || second) && first != second)
      valid2++;
  }
  print('Part 1: $valid1');
  print('Part 2: $valid2');
}
