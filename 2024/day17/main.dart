import 'dart:math';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

class Computer {
  int a, b, c, p;
  List<int> program;
  Computer(this.a, this.b, this.c,  this.program, [this.p = 0]);

  int instruction(int i) => program[program.length - 1 - i];
  int interpret(int operand) => switch (operand) {
    < 4 => operand,
    4 => a,
    5 => b,
    6 => c,
    _ => 0,
  };

  bool validate(List<int> test) {
    if (program.length != test.length) return false;
    for (final (int i, int e) in program.indexed) {
      if (e != test[i]) {
        return false;
      }
    }
    return true;
  }

  List<int> run() {
    p = 0;

    List<int> output = [];
    while (p < program.length) {
      int opcode = program[p], operand = program[p + 1];
      int next = p + 2;
      switch (opcode) {
        case 0: a = a ~/ pow(2, interpret(operand));
        case 1: b = b ^ operand;
        case 2: b = interpret(operand) % 8;
        case 3: next = (a == 0 ? p + 2 : operand);
        case 4: b = b ^ c;
        case 5: output.add(interpret(operand) % 8);
        case 6: b = a ~/ pow(2, interpret(operand));
        case 7: c = a ~/ pow(2, interpret(operand));
      }
      p = next;
    }
    return output;
  }
}

void main() async {
  List<List<int>> input = (await aoc.getInput()).map((e) => e.numbers()).toList();

  Computer computer = Computer(input[0][0], input[1][0], input[2][0], input[4]);

  print('Part 1: ${computer.run().join(",")}');

  List<(int, int)> stack = [(0, 0)];
  List<int> valid = [];
  while (stack.isNotEmpty) {
    final (int i, int start) = stack.removeLast();
    for (int a = start; a < start + (1 << 3); a++) {
      List<int> next = (computer..a = a).run();

      if (computer.validate(next)) {
        valid.add(a);
      }
      if (i < 16 && next[0] == computer.instruction(i)) {
        stack.add((i + 1, a << 3));
      }
    }
  }
  print('Part 2: ${(valid..sort()).first}');
}