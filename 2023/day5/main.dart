import 'dart:io';

import 'package:AdventOfCode/string.dart';

class AoCMap {
  late int s, d, c;
  AoCMap(List<String> e) {
    d = e[0].toInt();
    s = e[1].toInt();
    c = e[2].toInt();
  }
  int inRange(int item) {
    if (s <= item && item < s + c) {
      return d + item - s;
    }
    return -1;
  }
}

int? getLoc(int? first, List<List<AoCMap>> maps, List<int> seeds) {
  for (int seed in seeds) {
    int dest = seed;
    for (int curMap = 0; curMap < maps.length; curMap++) {
      List<AoCMap> cur = maps[curMap];
      for (int i = 0; i < cur.length; i++) {
        int newDest = cur[i].inRange(dest);
        if (newDest != -1) {
          dest = newDest;
          break;
        }
      }
    }
    if (first == null || dest < first) {
      first = dest;
    }
  }
  return first;
}

List<AoCMap> unpack(List<String> input, String map) {
  return input.sublist(input.indexOf(map) + 1)
    .takeWhile((e) => e.length != 0)
    .map((e) => AoCMap(e.split(' '))).toList();
}

void main() async {
  List<String> lines = await File('input.txt').readAsLines();

  List<int> seeds = lines[0].split(' ').sublist(1).map(int.parse).toList();
  List<List<AoCMap>> maps = [
    unpack(lines, 'seed-to-soil map:'),
    unpack(lines, 'soil-to-fertilizer map:'),
    unpack(lines, 'fertilizer-to-water map:'),
    unpack(lines, 'water-to-light map:'),
    unpack(lines, 'light-to-temperature map:'),
    unpack(lines, 'temperature-to-humidity map:'),
    unpack(lines, 'humidity-to-location map:'),
  ];

  int? lowest;
  print('Part 1: ${getLoc(lowest, maps, seeds)}');
  for (int i = 0; i < seeds.length; i += 2) {
    lowest = getLoc(lowest,
                    maps,
                    List.generate(seeds[i + 1], (index) => seeds[i] + index));
  }
  print('Part 2: $lowest');
}