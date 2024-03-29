List copy(List l) {
  List nl = new List.empty(growable: true);
  for (Object o in l) {
    nl.add(o);
  }
  return nl;
}
int run(List instructions, Map heap) {
  int pointer = 0;
  while (pointer < instructions.length) {
    String instr = instructions[pointer];
    switch (instr.substring(0, 3)) {
      case 'cpy':
        List<String> parts = instr.substring(4).split(' ');
        if (heap[parts[1]] != null) {
          heap[parts[1]] = int.tryParse(parts[0]) ?? heap[parts[0]];
        }
        break;
      case 'inc':
        heap[instr.substring(4)]++;
        break;
      case 'dec':
        heap[instr.substring(4)]--;
        break;
      case 'jnz':
        String str = instr.substring(4, 5);
        if ((int.tryParse(str) ?? heap[str]) != 0) {
          str = instr.substring(6);
          pointer += (int.tryParse(str) ?? heap[str] as int) - 1;
        }
        break;
      case 'tgl':
        int index = pointer + heap[instr.substring(4)] as int;
        if (index > -1 && index < instructions.length) {
          String toggle = instructions[index];
          if (toggle.split(' ').length > 2) {
            toggle = toggle.startsWith('jnz') ? toggle.replaceAll('jnz', 'cpy') : 'jnz${toggle.substring(3)}';
          } else {
            toggle = toggle.startsWith('inc') ? toggle.replaceAll('inc', 'dec') : 'inc${toggle.substring(3)}';
          }
          instructions[index] = toggle;
        }
      break;
      default:
        print('???');
        break;
    }
    pointer++;
  }
  return heap['a'];
}
void main() {
  List<String> instructions = [
    'cpy a b',
    'dec b',
    'cpy a d',
    'cpy 0 a',
    'cpy b c',
    'inc a',
    'dec c',
    'jnz c -2',
    'dec d',
    'jnz d -5',
    'dec b',
    'cpy b c',
    'cpy c d',
    'dec d',
    'inc c',
    'jnz d -2',
    'tgl c',
    'cpy -16 c',
    'jnz 1 c',
    'cpy 94 c',
    'jnz 99 d',
    'inc a',
    'inc d',
    'jnz d -2',
    'inc c',
    'jnz c -5'
  ];
  Stopwatch time = new Stopwatch()..start();
  print('Part 1: ${run(copy(instructions), {"a":7,"b":0,"c":0,"d":0})} ${time.elapsed}');
  time.reset();
  print('Part 2: ${run(copy(instructions), {"a":12,"b":0,"c":0,"d":0})} ${time.elapsed}');
}