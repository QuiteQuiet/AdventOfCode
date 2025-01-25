import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

int transform(int v, int x) => (v * x) % 20201227;

void main() async {
  List<int> numbers = (await aoc.getInput()).map(int.parse).toList();

  int card = 1, loops = -1;
  for (int i = 1; loops == -1; i++) {
    card = transform(card, 7);
    if (numbers.contains(card))
      loops = i;
  }

  int secret = 1, other = numbers.indexOf(card) == 0 ? 1 : 0;
  for (int i = 0; i < loops; i++)
    secret = transform(secret, numbers[other]);

  print('Part 1: $secret');
}
