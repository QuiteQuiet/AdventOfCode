import 'dart:io';
import 'dart:async';
import 'dart:collection';

Future<int> program(int id, List<List<String>> ops, Queue<int> into, Queue<int> outo) async {
  bool part1 = id == 0;
  int index = 0, sent = 0;
  Map<String, int> registers = {'a': 0, 'b': 0, 'f': 0, 'i': 0, 'p': id};
  while (index >= 0 && index < ops.length) {
    List<String> parts = ops[index];
    switch (parts[0]) {
      case 'snd':
        int t = int.tryParse(parts[1]) ?? registers[parts[1]]!;
        outo.add(t);
        sent++;
      break;
        case 'set':
          registers[parts[1]] = (int.tryParse(parts[2]) ?? registers[parts[2]])!;
        break;
        case 'add':
          registers[parts[1]] = registers[parts[1]]! + (int.tryParse(parts[2]) ?? registers[parts[2]])!;
        break;
        case 'mul':
          registers[parts[1]] = registers[parts[1]]! * (int.tryParse(parts[2]) ?? registers[parts[2]])!;
        break;
        case 'mod':
          registers[parts[1]] = registers[parts[1]]! % (int.tryParse(parts[2]) ?? registers[parts[2]])!;
        break;
      case 'rcv':
        if (part1) {
          print('Part 1: ${outo.last}');
          part1 = false;
        }
        int count = 0;
        while (into.length == 0) {
          await new Future.delayed(const Duration(milliseconds: 10));
          count++;
          if (count > 50) return sent;
        }
        registers[parts[1]] = into.removeFirst();
      break;
      case 'jgz':
        int test = int.tryParse(parts[1]) ?? registers[parts[1]]!;
        if (test > 0) {
          index += (int.tryParse(parts[2]) ?? registers[parts[2]])! - 1;
        }
      break;
    }
    index++;
  }
  return sent;
}

main() async {
  List<List<String>> ops = new List<List<String>>.empty(growable: true);
  new File('input.txt').readAsLinesSync().forEach((l) => ops.add(l.split(' ')));
  Queue<int> q1 = new Queue<int>(), q2 = new Queue<int>();

  program(0, ops, q1, q2);
  Future<int> i2 = program(1, ops, q2, q1);

  print('Part 2: ${await i2}');
}