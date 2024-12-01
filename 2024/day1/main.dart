import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  List<String> lines = await aoc.getInput();

  List<int> left = [], right = [];
  for (String line in lines) {
    var [l, r] = line.split("   ").map(int.parse).toList();
    left..add(l)..sort();
    right..add(r)..sort();
  }
  Map<int, int> counter = Map.fromIterable(left, value: (l) => right.where((r) => l == r).length);

  int sum = 0;
  int similarity = 0;
  for (final (int i, int el) in left.indexed) {
    sum += (el - right[i]).abs();
    similarity += el * (counter[el] ?? 0);
  }

  print('Part 1: $sum');
  print('Part 2: $similarity');
}