import 'dart:io';

main() async {
  int? recovered, played;
  int index = 0;
  Map<String, int> registers = {'a': 0, 'b': 0, 'f': 0, 'i': 0, 'p': 0};
  List<List<String>> ops = new List<List<String>>.empty(growable: true);
  new File('input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((l) => ops.add(l.split(' ')));
    while (recovered == null) {
      print(registers);
      List<String> parts = ops[index];
      switch (parts[0]) {
        case 'snd':
          played = int.tryParse(parts[1]) ?? registers[parts[1]];
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
          int test = int.tryParse(parts[1]) ?? registers[parts[1]]!;
          if (test != 0) {
            // recover sound
            recovered = played;
          }
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
    print('Part 1: $recovered');
  });
}