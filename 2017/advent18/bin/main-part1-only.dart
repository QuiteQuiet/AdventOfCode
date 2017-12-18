import 'dart:io';

main() async {
  int recovered, played, index = 0;
  Map<String, int> registers = {'a': 0, 'b': 0, 'f': 0, 'i': 0, 'p': 0};
  List<List<String>> ops = new List<List<String>>();
  new File('advent18/input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((l) => ops.add(l.split(' ')));
    while (recovered == null) {
      print(registers);
      List<String> parts = ops[index];
      switch (parts[0]) {
        case 'snd':
          played = int.parse(parts[1], onError: (String s) => registers[s]);
        break;
        case 'set':
          registers[parts[1]] = int.parse(parts[2], onError: (String s) => registers[s]);
        break;
        case 'add':
          registers[parts[1]] += int.parse(parts[2], onError: (String s) => registers[s]);
        break;
        case 'mul':
          registers[parts[1]] *= int.parse(parts[2], onError: (String s) => registers[s]);
        break;
        case 'mod':
          registers[parts[1]] %= int.parse(parts[2], onError: (String s) => registers[s]);
        break;
        case 'rcv':
          int test = int.parse(parts[1], onError: (String s) => registers[s]);
          if (test != 0) {
            // recover sound
            recovered = played;
          }
        break;
        case 'jgz':
          int test = int.parse(parts[1], onError: (String s) => registers[s]);
          if (test > 0) {
            index += int.parse(parts[2], onError: (String s) => registers[s]) - 1;
          }
        break;
      }
      index++;
    }
    print('Part 1: $recovered');
  });
}