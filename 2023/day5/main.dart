import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

import 'package:AdventOfCode/int.dart';

class RelocationMap {
  late int sStart, sEnd, dStart, dEnd;
  RelocationMap(List<int> e) {
    int dest = e[0], source = e[1], len = e[2];
    dStart = dest;
    sStart = source;
    dEnd = dStart + len;
    sEnd = sStart + len;
  }
  int inRange(int item, [bool backwards=false]) {
    if (backwards) {
      if (dStart <= item && item < dEnd) {
        return sStart + item - dStart;
      }
    } else {
      if (sStart <= item && item < sEnd) {
        return dStart + item - sStart;
      }
    }
    return -1;
  }
}

int goToEnd(int? lowest, List<List<RelocationMap>> maps, int entry, [bool reversed=false]) {
  for (List<RelocationMap> cur in maps) {
    for (RelocationMap next in cur) {
      int newDest = next.inRange(entry, reversed);
      if (newDest != -1) {
        entry = newDest;
        break;
      }
    }
  }
  if (lowest == null || entry < lowest) {
    lowest = entry;
  }
  return lowest;
}

List<RelocationMap> unpack(List<String> input, String map) {
  return input.sublist(input.indexOf(map) + 1)
    .takeWhile((e) => e.length != 0)
    .map((e) => RelocationMap(e.split(' ').map(int.parse).toList())).toList();
}

void main() async {
  List<String> lines = await aoc.getInput();

  List<int> seeds = lines[0].split(' ').sublist(1).map(int.parse).toList();
  List<List<RelocationMap>> maps = [
    unpack(lines, 'seed-to-soil map:'),
    unpack(lines, 'soil-to-fertilizer map:'),
    unpack(lines, 'fertilizer-to-water map:'),
    unpack(lines, 'water-to-light map:'),
    unpack(lines, 'light-to-temperature map:'),
    unpack(lines, 'temperature-to-humidity map:'),
    unpack(lines, 'humidity-to-location map:'),
  ];
  print('Part 1: ${seeds.fold<int?>(null, (lowest, entry) => goToEnd(lowest, maps, entry))}');

  maps = maps.reversed.toList();
  List<RelocationMap> seedRanges = [];
  for (int i in 0.to(seeds.length - 1, step: 2)) {
    seedRanges.add(RelocationMap([seeds[i], seeds[i], seeds[i + 1]]));
  }
  // Yes, actually test 2 billion numbers. Why not?
  for (int i in 0.to(0xFFFFFFFF)) {
    int seed = goToEnd(null, maps, i, true);
    if (seedRanges.any((range) => range.inRange(seed) != -1)) {
      print('Part 2: $i');
      break;
    }
  }
}