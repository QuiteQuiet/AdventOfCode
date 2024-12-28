import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  int target = (await aoc.getInput()).map(int.parse).toList()[0];
  List<int> recipies = [3, 7], elves = [0, 1];

  while (recipies.length < target * 25) {
    int sum = recipies[elves[0]] + recipies[elves[1]];
    int first = sum ~/ 10;
    if (first > 0) {
      recipies.add(first);
    }
    recipies.add(sum % 10);
    elves = elves.map((i) => (i + recipies[i] + 1) % recipies.length).toList();
  }

  String result = recipies.join('');
  print('Part 1: ${result.substring(target, target + 10)}');
  print('Part 2: ${result.indexOf(target.toString())}');
}
