Iterable run(List instructions, Map heap) sync*{
  int pointer = 0;
  while (pointer < instructions.length) {
    String instr = instructions[pointer];
    switch (instr.substring(0, 3)) {
      case 'cpy':
        List<String> parts = instr.substring(4).split(' ');
        if (heap[parts[1]] != null) {
          heap[parts[1]] = int.parse(parts[0], onError: (s) => heap[s]);
        }
        break;
      case 'inc':
        heap[instr.substring(4)]++;
        break;
      case 'dec':
        heap[instr.substring(4)]--;
        break;
      case 'jnz':
        if (int.parse(instr.substring(4, 5), onError: (s) => heap[s]) != 0) {
          pointer += int.parse(instr.substring(6), onError: (s) => heap[s]) - 1;
        }
        break;
      case 'out':
        yield heap[instr.substring(4)];
      break;
      default:
        print('???');
        break;
    }
    pointer++;
  }
  yield heap['a'];
}
void main() {
  List<String> instructions = [
    'cpy a d',
    'cpy 11 c',
    'cpy 231 b',
    'inc d',
    'dec b',
    'jnz b -2',
    'dec c',
    'jnz c -5',
    'cpy d a',
    'jnz 0 0',
    'cpy a b',
    'cpy 0 a',
    'cpy 2 c',
    'jnz b 2',
    'jnz 1 6',
    'dec b',
    'dec c',
    'jnz c -4',
    'inc a',
    'jnz 1 -7',
    'cpy 2 b',
    'jnz c 2',
    'jnz 1 4',
    'dec b',
    'dec c',
    'jnz 1 -4',
    'jnz 0 0',
    'out b',
    'jnz a -19',
    'jnz 1 -21'
  ];
  for (int i = 0; true; i++) {
    String test = '';
    for (int next in run(instructions, {"a":i,"b":0,"c":0,"d":0})) {
      test += next.toString();
      if (test.startsWith('1') || (test.length > 1 && test[test.length - 2] == test[test.length - 1])) break;
      if (test.length >= 10) break;
    }
    if (test == '0101010101') {
      print('Part 1: $i');
      break;
    }
  }
}