import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

void main() async {
  List<String> lines = await aoc.getInput();

  List<List<int>> freshRanges = [];
  for (String range in lines.takeWhile((e) => e.isNotEmpty)) {
    List<int> parts = range.split('-').map(int.parse).toList();
    freshRanges.add(parts);
  }
  freshRanges.sort((a, b) => a.first - b.first);
  int ingredientIndex = freshRanges.length + 1;

  List<List<int>> combinedRanges = [freshRanges.first];
  for (List<int> range in freshRanges.skip(1)) {
    int bound = combinedRanges.last.last + 1;
    if (range.first > bound) {
      combinedRanges.add(range);
    } else if (range.last >= bound) {
      combinedRanges.last.last = range.last;
    }
  }
  freshRanges = combinedRanges;

  int fresh = 0;
  for (String line in lines.skip(ingredientIndex)) {
    int ingredient = line.toInt();
    for (List<int> range in freshRanges) {
      if (range.first <= ingredient && ingredient <= range.last) {
        fresh++;
        break;
      }
    }
  }
  print('Part 1: $fresh');

  int ids = 0;
  for (List<int> range in freshRanges) {
    ids += range[1] - range[0] + 1;
  }
  print('Part 2: $ids');
}
