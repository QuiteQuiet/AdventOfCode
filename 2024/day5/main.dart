import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';
import 'package:collection/collection.dart';

void main() async {
  List<String> lines = await aoc.getInput();
  List<List<int>> entries = lines.map((e) => e.numbers()).toList();

  int gap = lines.indexOf('');
  List<List<int>> rules = entries.sublist(0, gap);
  List<List<int>> updates = entries.sublist(gap + 1);

  Map<int, Set<int>> after = {}, before = {};
  for (final [int b, int a] in rules) {
    (after[b] ??= {}).add(a);
    (before[a] ??= {}).add(b);
  }

  int sorted(List<int> update) {
    for (final (int i, int v) in update.indexed) {
      if (after[v] != null && update.sublist(0, i).any((e) => after[v]!.contains(e)))
        return i;
      if (before[v] != null && update.sublist(i + 1).any((e) => before[v]!.contains(e)))
        return i;
    }
    return -1;
  }

  int sum = 0;
  List<List<int>> invalid = [];
  for (List<int> update in updates) {
    if (sorted(update) < 0) {
      sum += update[update.length ~/ 2];
    } else {
      invalid.add(update);
    }
  }
  print('Part 1: $sum');

  int corrections = 0;
  for (List<int> update in invalid) {
    List<int> attempts = List.filled(update.length, 0);
    int index = sorted(update);
    while (index >= 0) {
      index = sorted(update..swap(index, index + ++attempts[index]));
    }
    corrections += update[update.length ~/ 2];
  }
  print('Part 2: $corrections');
}