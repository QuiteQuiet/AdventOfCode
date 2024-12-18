import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

class Computer {
  int p;
  List<int> program, reg;
  Computer(this.reg,  this.program, [this.p = 0]);

  void set a(int a) => reg[0] = a;

  int instruction(int i) => program[program.length - 1 - i];
  int rel(int operand) => switch (operand) {
    < 4 => operand,
    _ => reg[operand - 4],
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
        case 0: reg[0] = reg[0] >> rel(operand);
        case 1: reg[1] = reg[1] ^ operand;
        case 2: reg[1] = rel(operand) % 8;
        case 3: next = (reg[0] == 0 ? p + 2 : operand);
        case 4: reg[1] = reg[1] ^ reg[2];
        case 5: output.add(rel(operand) % 8);
        case 6: reg[1] = reg[0] >> rel(operand);
        case 7: reg[2] = reg[0] >> rel(operand);
      }
      p = next;
    }
    return output;
  }
}

void main() async {
  List<List<int>> input = (await aoc.getInput()).map((e) => e.numbers()).toList();

  Computer computer = Computer([input[0][0], input[1][0], input[2][0]], input[4]);

  print('Part 1: ${computer.run().join(",")}');

  List<(int, int)> stack = [(0, 0)];
  List<int> valid = [];
  while (stack.isNotEmpty) {
    final (int i, int start) = stack.removeLast();
    for (int a = start; a < start + 8 && i < 16; a++) {
      List<int> next = (computer..a = a).run();

      if (computer.validate(next)) {
        valid.add(a);
      }
      if (next.first == computer.instruction(i)) {
        stack.add((i + 1, a << 3));
      }
    }
  }
  print('Part 2: ${(valid..sort()).first}');
}