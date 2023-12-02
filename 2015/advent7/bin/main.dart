import 'dart:io';

Map gates = new Map<String, int>();
Map operations = new Map<String, List>();

int run(String op, List<String> parts) {
  switch (op) {
    case 'AND': return calc(parts[0]) & calc(parts[2]);
    case 'OR': return calc(parts[0]) | calc(parts[2]);
    case 'NOT': return ~calc(parts[1]) + 2.modPow(16, 1);
    case 'RSHIFT': return calc(parts[0]) >> calc(parts[2]);
    case 'LSHIFT': return calc(parts[0]) << calc(parts[2]);
  }
  return 0;
}

int onNull(String name) {
  if (!gates.containsKey(name)) {
    List<String> ops = operations[name];
    gates[name] = ((ops.length < 2) ? calc(ops[0]) : run(ops[ops.length - 2], ops));
  }
  return gates[name];
}

int calc(String name) => int.tryParse(name) ?? onNull(name);

main() async {
  List<String> lines = await new File('input.txt').readAsLines();
  lines.forEach((String s) {
    List<String> parts = s.split('->');
    operations[parts[1].trim()] = parts[0].trim().split(' ');
  });
  int val = calc('a');
  print('Part 1: a: $val');
  gates.clear();
  gates['b'] = val;
  print('Part 2: a: ${calc("a")}');
}