import 'dart:io';
import 'dart:math';

main() async {
  Map<String, Function> compare = {
    '>': (a, b) => a > b,
    '<': (a, b) => a < b,
    '<=': (a, b) => a <= b,
    '>=': (a, b) => a >= b,
    '==': (a, b) => a == b,
    '!=': (a, b) => a != b
  };
  Map<String, int> registers = new Map<String, int>();
  int inProcessMax = 0;
  await new File('advent8/input.txt').readAsLines()
  .then((List<String> file) => file.forEach((String line) {
    List<String> current = line.split(' ');
    String target = current[0], conditional = current[4], op = current[5];
    if (!registers.containsKey(target)) registers[target] = 0;
    if (!registers.containsKey(conditional)) registers[conditional] = 0;

    int value = int.parse(current[2]);
    if (compare[op](registers[conditional], int.parse(current[6]))) {
      registers[target] += current[1] == 'inc' ? value : -value;
      if (registers[target] > inProcessMax) {
        inProcessMax = registers[target];
      }
    }
  }));
  print('Part 1: ${registers.values.reduce(max)}');
  print('Part 2: $inProcessMax');
}