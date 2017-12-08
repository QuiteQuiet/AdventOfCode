import 'dart:io';
import 'dart:math';

main() async {
  Map<String, int> registers = new Map<String, int>();
  int inProcessMax = 0;
  await new File('advent8/input.txt').readAsLines()
  .then((List<String> file) => file.forEach((String line) {
    List<String> current = line.split(' ');
    String target = current[0], condition = current[4];
    if (!registers.containsKey(target)) registers[target] = 0;
    if (!registers.containsKey(condition)) registers[condition] = 0;

    int value = int.parse(current[2]);
    switch(current[5]) {
      case '>': if (registers[condition] <= int.parse(current[6])) { return; } break;
      case '<': if (registers[condition] >= int.parse(current[6])) { return; } break;
      case '<=': if (registers[condition] > int.parse(current[6])) { return; } break;
      case '>=': if (registers[condition] < int.parse(current[6])) { return; } break;
      case '==': if (registers[condition] != int.parse(current[6])) { return; } break;
      case '!=': if (registers[condition] == int.parse(current[6])) { return; } break;
    }
    registers[target] += current[1] == 'inc' ? value : -value;
    int tempMax = registers.values.reduce(max);
    if (inProcessMax < tempMax) inProcessMax = tempMax;
  }));
  print('Part 1: ${registers.values.reduce(max)}');
  print('Part 2: $inProcessMax');
}