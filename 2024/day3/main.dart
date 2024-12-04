import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

void main() async {
  String line = await aoc.getInputString();

  RegExp mul = new RegExp(r'mul\((\d+),(\d+)\)');
  RegExp filter = new RegExp(r"don't\(\).*?(do\(\)|$)", dotAll: true);
  int sum(str) => mul.allMatches(str).fold(0, (s, e) => s + e.group(1)!.toInt() * e.group(2)!.toInt());

  print('Part 1: ${sum(line)}');
  print('Part 2: ${sum(line.replaceAll(filter, ""))}');
}