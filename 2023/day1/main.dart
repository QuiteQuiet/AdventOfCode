import 'dart:io';

import 'package:AdventOfCode/string.dart';

String normalize(String number) {
  return {
    '1': '1',
    '2': '2',
    '3': '3',
    '4': '4',
    '5': '5',
    '6': '6',
    '7': '7',
    '8': '8',
    '9': '9',
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
  }[number]!;
}

int findNumbers(String line, RegExp exp) {
    List<String> matches = List.from(exp.allMatches(line).map((e) => normalize(e.group(1)!)));
    return (matches.first + matches.last).toInt();
}

void main() async {
  List<String> lines = await File('input.txt').readAsLines();
  RegExp expPart1 = RegExp(r'(?=(\d))');
  RegExp expPart2 = RegExp(r'(?=(\d|one|two|three|four|five|six|seven|eight|nine))');
  int part1 = 0, part2 = 0;
  for (String line in lines) {
    part1 += findNumbers(line, expPart1);
    part2 += findNumbers(line, expPart2);;
  }
  print('Part 1: $part1');
  print('Part 2: $part2');
}