import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

class Gate {
  int? value;
  late String a, b, op;
  void Function(Map<String, Gate>)? tick;
  Gate([this.value]) {
    a = ''; b = ''; op = '';
  }
  void update(String gateA, String gateB, String operation) {
    a = gateA;
    b = gateB;
    op = operation;
    tick = (Map<String, Gate> gates) {
      if (gates[a]!.value == null || gates[b]!.value == null)
        return;
      switch (op) {
        case 'AND': value = gates[a]!.value! & gates[b]!.value!;
        case 'OR': value = gates[a]!.value! | gates[b]!.value!;
        case 'XOR': value = gates[a]!.value! ^ gates[b]!.value!;
      };
    };
  }
  String toString() => '$value';
}

int simulate(Map<String, Gate> gates) {
  List<String> zReg = gates.keys.where((e) => e.startsWith('z')).toList()..sort()..forEach((e) => gates[e]!.value = null);
  while (zReg.any((z) => gates[z]!.value == null)) {
    gates.values.where((e) => e.tick != null).forEach((e) => e.tick!(gates));
  }
  return int.parse(zReg.reversed.map((e) => gates[e]!.value).join(''), radix: 2);
}

void main() async {
  List<String> lines = await aoc.getInput(), xregs = [], yregs = [];

  Map<String, Gate> gates = {};
  for (String gate in lines.takeWhile((e) => e.isNotEmpty)) {
    List<String> parts = gate.split(': ');
    gates[parts[0]] = Gate(parts[1].toInt());
    if (parts[0].startsWith('x')) {
      xregs.add(parts[1]);
    } else {
      yregs.add(parts[1]);
    }
  }
  for (String connection in lines.skipWhile((e) => e.isNotEmpty).skip(1)) {
    List<String> parts = connection.split(' ');
    (gates[parts[4]] ??= Gate()).update(parts[0], parts[2], parts[1]);
  }

  int output = simulate(gates);
  print('Part 1: $output');

  // z registers except z45 have to result from an XOR gate, so any that doesn't
  // is wrong. XOR gates should only end in z so anythat doesn't are wrong.
  List<String> wrong = [];
  gates.forEach((String name, Gate g) {
    if (name.startsWith('z') && g.op != 'XOR' && name != 'z45') {
      wrong.add(name);
    } else  if (!name.startsWith('z') && !g.a.startsWith(RegExp(r'[xy]')) && g.op == 'XOR') {
      wrong.add(name);
    }
  });

  // It's not actually important to figure out the pairs, the last 2 to fix are
  // disconnected by enough that fixing them do not help. This may not be true for
  // all inputs but is for mine.
  int xval = int.parse(xregs.reversed.join(''), radix: 2);
  int yval = int.parse(yregs.reversed.join(''), radix: 2);
  int badBits = (xval + yval) ^ output;

  int lastBad = badBits.bitLength - 1;
  // Find gates with x{lastBad} and y{lastBad} as input. There should
  // be one AND and one XOR gate.
  for (String name in gates.keys) {
    if (gates[name]!.a.contains('$lastBad')) {
      wrong.add(name);
    }
  }
  print('Part 2: ${(wrong..sort()).join(',')}');
}