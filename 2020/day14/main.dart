import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

Iterable<int> allAddresses(String mask) sync* {
  if (mask.contains('X')) {
    yield* allAddresses(mask.replaceFirst('X', '0'));
    yield* allAddresses(mask.replaceFirst('X', '1'));
  } else {
    yield int.parse(mask, radix: 2);
  }
}

(int, int) initialize(List<String> program) {
  Map<int, int> memory1 = {}, memory2 = {};

  String mask = '';
  int bitmaskSet = 0, bitmaskUnset = 0;
  for (String line in program) {
    if (line.startsWith('mask')) {
      mask = line.substring(7);
      bitmaskSet = int.parse(mask.replaceAll('X', '0'), radix: 2);
      bitmaskUnset = int.parse(mask.replaceAll('X', '1'), radix: 2);
    } else {
      List<int> values = line.numbers();
      memory1[values[0]] = (values[1] | bitmaskSet) & bitmaskUnset;

      String addr = values[0].toRadixString(2).padLeft(36, '0');
      List<String> newAddr = [];
      for (int i = 0; i < mask.length; i++)
        newAddr.add(mask[i] == '0' ? addr[i] : mask[i]);
      for (int addr in allAddresses(newAddr.join('')))
        memory2[addr] = values[1];
    }
  }
  return (memory1.values.reduce((a, b) => a + b), memory2.values.reduce((a, b) => a + b));
}

void main() async {
  List<String> lines = await aoc.getInput();

  Stopwatch time = Stopwatch()..start();
  (int, int) res = initialize(lines);
  print('Part 1: ${res.$1}');
  print('Part 2: ${res.$2}');
  print(time.elapsed);
}
