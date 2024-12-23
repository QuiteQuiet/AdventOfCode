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

  List<HeapPriorityQueue<int>> open = List.generate(10, (index) => HeapPriorityQueue());
  holes.values.forEach((e) => open[e.$2].add(e.$1));

  for (; last >= 0; last--) {
    final (int cur, int size) = blocks[last]!;
    // Go through all spaces big enough for this and find the first index
    int gap = size;
    for (int i = size; i < open.length; i++) {
      if (open[gap].first > open[i].first) {
        gap = i;
      }
    }
    if (open[gap].first > cur) continue; // Don't move files backwards
    int dest = open[gap].removeFirst();
    blocks[last] = (dest, size);
    int spare = gap - size;
    if (spare > 0) {
      open[spare].add(dest + size);
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