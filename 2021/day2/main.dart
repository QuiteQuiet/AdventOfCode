import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

void main() async {
  List<(String, int)> lines = (await aoc.getInput()).map((e) {
    List<String> instruction = e.split(' ');
    return (instruction[0], instruction[1].toInt());
  }).toList();

  int pos = 0, depth = 0, aim = 0;
  for (final (String instruction, int value) in lines) {
    switch (instruction) {
      case 'forward': pos += value;
      case 'up': depth -= value;
      case 'down': depth += value;
    }
  }
  print('Part 1: ${pos * depth}');

  pos = 0;  depth = 0;
  for (final (String instruction, int value) in lines) {
    switch (instruction) {
      case 'forward':
        pos += value;
        depth += aim * value;
      case 'up': aim -= value;
      case 'down': aim += value;
    }
  }
  print('Part 2: ${pos * depth}');
}
