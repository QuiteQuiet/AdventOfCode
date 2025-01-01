import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

class Computer {
  late int ip = 0, bind;
  List<(String, int, int, int)> program;
  late List<int> reg;
  late Map<String, Function(int, int, int)> functions;
  Computer(this.program) {
    bind = program.removeAt(0).$2;
    reg = List.filled(6, 0);
    functions = {
      'addr': (int a, int b, int c) => reg[c] = reg[a] + reg[b],
      'addi': (int a, int b, int c) => reg[c] = reg[a] + b,
      'mulr': (int a, int b, int c) => reg[c] = reg[a] * reg[b],
      'muli': (int a, int b, int c) => reg[c] = reg[a] * b,
      'banr': (int a, int b, int c) => reg[c] = reg[a] & reg[b],
      'bani': (int a, int b, int c) => reg[c] = reg[a] & b,
      'borr': (int a, int b, int c) => reg[c] = reg[a] | reg[b],
      'bori': (int a, int b, int c) => reg[c] = reg[a] | b,
      'setr': (int a, int b, int c) => reg[c] = reg[a],
      'seti': (int a, int b, int c) => reg[c] = a,
      'gtir': (int a, int b, int c) => reg[c] = a > reg[b] ? 1 : 0,
      'gtri': (int a, int b, int c) => reg[c] = reg[a] > b ? 1 : 0,
      'gtrr': (int a, int b, int c) => reg[c] = reg[a] > reg[b] ? 1 : 0,
      'eqir': (int a, int b, int c) => reg[c] = a == reg[b] ? 1 : 0,
      'eqri': (int a, int b, int c) => reg[c] = reg[a] == b ? 1 : 0,
      'eqrr': (int a, int b, int c) => reg[c] = reg[a] == reg[b] ? 1 : 0,
    };
  }

 int execute() {
    int first = 0;
    ip = 0;
    while (ip < program.length) {
      final (String op, int a, int b, int c) = program[ip];
      reg[bind] = ip;
      functions[op]!(a, b, c);
      ip = reg[bind] + 1;
      if (ip == 28) {
        first = reg[3];
        break;
      }
    }
    return first;
  }
}

void main() async {
List<(String, int, int, int)> lines = (await aoc.getInput()).map((e) {
    List<String> parts = e.split(' ');
    if (parts.length < 4)
      return (parts[0], parts[1].toInt(), 0, 0);
    return (parts[0], parts[1].toInt(), parts[2].toInt(), parts[3].toInt());
  }).toList();

  Computer comp = Computer(lines);
  int first = comp.execute();
  print('Part 1: $first');

  // A faster implementation of the puzzle input to brute force
  // all valid values of reg[0]. There's a limited number of
  // valid inputs (0xFFFFF) so the longest program is the last
  // non-repeating value. Set.last do work for "last inserted".
  int r2 = 0, r3 = first;
  Set<int> options = {};
  while (options.add(r3)) {
    r2 = r3 | 65536;
    r3 = 10736359;
    while (r2 > 0) {
      r3 = ((r3 + (r2 & 255)) * 65899) & 16777215;
      r2 ~/= 256;
    }
  }
  print('Part 2: ${options.last}');
}
