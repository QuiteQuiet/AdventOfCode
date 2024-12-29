import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

class Computer {
  late List<int> reg;
  late Map<String, Function(int, int, int)> operations;
  Computer() {
    reg = List.filled(4, 0);
    operations = {
      'addr': addr, 'addi': addi,
      'mulr': mulr, 'muli': muli,
      'banr': banr, 'bani': bani,
      'borr': borr, 'bori': bori,
      'setr': setr, 'seti': seti,
      'gtir': gtir, 'gtri': gtri, 'gtrr': gtrr,
      'eqir': eqir, 'eqri': eqri, 'eqrr': eqrr,
    };
  }
  void addr(int a, int b, int c) => reg[c] = reg[a] + reg[b];
  void addi(int a, int b, int c) => reg[c] = reg[a] + b;
  void mulr(int a, int b, int c) => reg[c] = reg[a] * reg[b];
  void muli(int a, int b, int c) => reg[c] = reg[a] * b;
  void banr(int a, int b, int c) => reg[c] = reg[a] & reg[b];
  void bani(int a, int b, int c) => reg[c] = reg[a] & b;
  void borr(int a, int b, int c) => reg[c] = reg[a] | reg[b];
  void bori(int a, int b, int c) => reg[c] = reg[a] | b;
  void setr(int a, int b, int c) => reg[c] = reg[a];
  void seti(int a, int b, int c) => reg[c] = a;
  void gtir(int a, int b, int c) => reg[c] = a > reg[b] ? 1 : 0;
  void gtri(int a, int b, int c) => reg[c] = reg[a] > b ? 1 : 0;
  void gtrr(int a, int b, int c) => reg[c] = reg[a] > reg[b] ? 1 : 0;
  void eqir(int a, int b, int c) => reg[c] = a == reg[b] ? 1 : 0;
  void eqri(int a, int b, int c) => reg[c] = reg[a] == b ? 1 : 0;
  void eqrr(int a, int b, int c) => reg[c] = reg[a] == reg[b] ? 1 : 0;

  bool equals(List<int> cmp) {
    for (int i = 0; i < reg.length; i++)
      if (reg[i] != cmp[i])
        return false;
    return true;
  }
}

void main() async {
  List<List<int>> instructions = (await aoc.getInput()).map((e) => e.numbers()).toList();

  Computer comp = Computer();
  List<Function(int, int, int)?> corrected = List.generate(comp.operations.length, (_) => null);
  Set<String> alreadyFixed = {};

  int atLeast3 = 0, programIdx = 0;;
  for (int i = 0; i < instructions.length; i += 3) {
    if (instructions[i].isEmpty) {
      programIdx = i + 2;
      break;
    }
    List<int> before = instructions[i], op = instructions[i + 1], after = instructions[i + 2];
    i++;

    Set<String> possible = {};
    for (final (func) in comp.operations.entries) {
      comp.reg = List.from(before);
      func.value(op[1], op[2], op[3]);
      if (comp.equals(after)) {
        possible.add(func.key);
      }
    }
    if (possible.length >= 3) {
      atLeast3++;
    }
    for (String n in alreadyFixed) {
      possible.remove(n);
    }
    if (possible.length == 1) {
      corrected[op[0]] = comp.operations[possible.first]!;
      alreadyFixed.add(possible.first);
    }
  }
  print('Part 1: $atLeast3');

  comp.reg = List.filled(4, 0);
  for (int i = programIdx; i < instructions.length; i++) {
    List<int> op = instructions[i];
    corrected[op[0]]!(op[1], op[2], op[3]);
  }
  print('Part 2: ${comp.reg[0]}');
}
