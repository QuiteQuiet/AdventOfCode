import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

int findJoltage(List<int> bank, int length) {
  (int, int, int) best = (-1, 0, 0);

  while (best.$2 != length) {
    final (int i, int l, int v) = best;

    int margin = length - 1 - l;
    (int, int) largest = (-1, -1);
    for (int ii = i + 1; ii < bank.length - margin; ii++) {
      if (bank[ii] > largest.$2) {
        largest = (ii, bank[ii]);
      }
    }
    best = (largest.$1, l + 1, v * 10 + largest.$2);
  }
  return best.$3;
}

void main() async {
  List<List<int>> lines = (await aoc.getInput()).map(
    (l) => l.runes.map((r) => r - 48).toList()).toList();

  int sumP1 = 0, sumP2 = 0;
  for (List<int> line in lines) {
    sumP1 += findJoltage(line, 2);
    sumP2 += findJoltage(line, 12);
  }
  print('Part 1: $sumP1');
  print('Part 2: $sumP2');
}
