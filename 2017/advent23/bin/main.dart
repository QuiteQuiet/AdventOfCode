import 'dart:io';
import 'dart:async';

Future<int> program(List<List<String>> ops) async {
  int index = 0, mul = 0;
  Map<String, int> registers = {'a': 0, 'b': 0, 'c': 0, 'd': 0, 'e': 0, 'f': 0, 'g': 0, 'h': 0};
  while (index >= 0 && index < ops.length) {
    List<String> parts = ops[index];
    switch (parts[0]) {
      case 'set':
        registers[parts[1]] = int.parse(parts[2], onError: (String s) => registers[s]);
      break;
      case 'sub':
        registers[parts[1]] -= int.parse(parts[2], onError: (String s) => registers[s]);
      break;
      case 'mul':
        registers[parts[1]] *= int.parse(parts[2], onError: (String s) => registers[s]);
        mul++;
      break;
      break;
      case 'jnz':
        int test = int.parse(parts[1], onError: (String s) => registers[s]);
        if (test != 0) {
          index += int.parse(parts[2], onError: (String s) => registers[s]) - 1;
        }
      break;
    }
    index++;
  }
  return mul;
}

Future<int> program_t(int initial) async {
  // translated code
  Map<String, int> r = {'a': 1, 'b': initial * 100 + 100000, 'c': initial * 100 + 100000 + 17000, 'd': 0, 'e': 0, 'f': 0, 'g': 0, 'h': 0};
  while (true) {
    r['f'] = 1;
    r['d'] = 2; 
    r['e'] = 2;
    while (true) {
      if (r['b'] % r['d'] == 0) r['f'] = 0;
      r['d']++;
      if (r['d'] != r['b']) continue;
      if (r['f'] == 0) r['h']++;
      if (r['b'] == r['c']) return r['h'];
      r['b'] += 17;
      break;
    }
  }
}

main() async {
  List<List<String>> ops = new List<List<String>>();
  new File('advent23/input.txt').readAsLines()
  .then((List<String> file) async {
    file.forEach((l) => ops.add(l.split(' ')));
    
    print('Part 1: ${await program(ops)}');
    print('Part 2: ${await program_t(int.parse(ops[0][2]))}');
  });
}