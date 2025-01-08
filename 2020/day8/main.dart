import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

(int, bool) execute(List<(String, int)> instructions) {
  int global = 0, pointer = 0;
  Set<int> executed = {};
  while (executed.add(pointer) && pointer < instructions.length) {
    switch (instructions[pointer].$1) {
      case 'acc': global += instructions[pointer].$2;
      case 'jmp': pointer += instructions[pointer].$2 - 1;
    }
    pointer++;
  }
  return (global, pointer >= instructions.length);
}

void main() async {
  List<(String, int)> instructions = (await aoc.getInput()).map((e) {
    List<String> things = e.split(' ');
    return (things[0], things[1].toInt());
  }).toList();

  print('Part 1: ${execute(instructions).$1}');

  (int, bool)? result;
  for (final (int i, (String s, int v)) in instructions.indexed) {
    if (s == 'acc') continue;
    instructions[i] = ({'nop': 'jmp', 'jmp': 'nop'}[s]!, v);
    if ((result = execute(instructions)).$2)
      break;
    instructions[i] = ({'nop': 'jmp', 'jmp': 'nop'}[instructions[i].$1]!, v);
  }
  print('Part 2: ${result!.$1}');
}
