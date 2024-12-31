import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

import 'package:trotter/trotter.dart';

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

  void execute() {
    ip = 0;
    while (ip < program.length) {
      final (String op, int a, int b, int c) = program[ip];
      reg[bind] = ip;
      functions[op]!(a, b, c);
      ip = reg[bind] + 1;
      if (reg[1] == 1) {
        return;
      }
    }
  }
}


void main() async {
  List<(String, int, int, int)> lines = (await aoc.getInput()).map((e) {
    List<String> parts = e.split(' ');
    if (parts.length < 4)
      return (parts[0], parts[1].toInt(), 0, 0);
    return (parts[0], parts[1].toInt(), parts[2].toInt(), parts[3].toInt());
  }).toList();

  // The program given as input is calculating all divisors of a number.
  // Rather than letting it do its job we reimplement the same procedure
  // and just do the calculation ourselves much faster. The code above is
  // fixed to exit as soon as the number to work with is put into reg[2].
  List<int> primeFactors(int n) {
    List<int> r = [];
    int i = 1;
    while (n > 1) {
      i++;
      if (n % i == 0) {
        r.add(i);
        n = n ~/ i;
        i = 1;
      }
    }
    return r;
  }

  Computer comp = Computer(lines);
  int target = (comp..execute()).reg[2];
  print('Part 1: ${[1, ...primeFactors(target), target].reduce((a, b) => a + b)}');

  comp.reg = [1, 0, 0, 0, 0, 0];
  target = (comp..execute()).reg[2];
  List<int> primes = primeFactors(target);
  int sum =  primes.reduce((a, b) => a + b);
  for (int i = 2; i < primes.length; i++) {
    for (final comb in Combinations(i, primes)()) {
      sum += comb.reduce((a, b) => a * b);
    }
  }
  print('Part 2: ${1 + sum + target}');
}
