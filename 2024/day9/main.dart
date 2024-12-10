import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/int.dart';
import 'package:collection/collection.dart';

void main() async {
  String diskMap = await aoc.getInputString();

  List<int> disk = [];
  int id = 0;
  for (final (int i, int c) in diskMap.runes.indexed) {
    disk.addAll(List.generate(c - 48, (_) => i % 2 == 0 ? id : -id));
    if (i % 2 == 0) {
      id++;
    }
  }

  // Build a map of all blocks and open space so we don't need to
  // move through the array later.
  Map<int, (int, int)> blocks = {}, holes = {};
  int last = 0;
  for (final (int i, int s) in disk.indexed) {
    Map<int, (int, int)> either = s < 0 ? holes : blocks;
    if (either.containsKey(s)) {
      final (int, int) e = either[s]!;
      either[s] = (e.$1, e.$2 + 1);
    } else {
      either[s] = (i, 1);
    }
    if (s > last) {
      last = s;
    }
  }

  int index = 0, back = disk.length - 1;
  while (index < back) {
    if (disk[index] < 0) {
      int last = disk[back];
      while (last < 0) {
        last = disk[--back];
      }
      disk[back] = disk[index];
      disk[index] = last;
      back--;
    }
    index++;
  }
  print('Part 1: ${disk.foldIndexed(0, (i, s, e) => e < 0 ? s : s + i * e)}');


  Map<int, int> empty = Map.fromIterable(holes.values,
                                         key: (e) => e.$1,
                                         value: (e) => e.$2);
  for (; last >= 0; last--) {
    final (int cur, int size) = blocks[last]!;
    for (int to in empty.keys.toList()..sort()) {
      if (to > cur) break; // Don't move files backwards
      int space = empty[to]!;
      if (space >= size) {
        blocks[last] = (to, size);
        empty.remove(to);
        int left = space - size;
        if (left > 0) {
          empty[to + size] = left;
        }
        break;
      }
    }
  }

  int sum = 0;
  for (int b in blocks.keys) {
    final (int index, int size) = blocks[b]!;
    for (int i in 0.to(size - 1)) {
      sum += b * (index + i);
    }
  }
  print('Part 2: $sum');
}