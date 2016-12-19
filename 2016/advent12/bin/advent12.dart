int run(List instructions, Map heap) {
  int pointer = 0;
  while (pointer < instructions.length) {
    String instr = instructions[pointer];
    switch (instr.substring(0, 3)) {
      case 'cpy':
        List<String> parts = instr.substring(4).split(' ');
        try {
          heap[parts[1]] = int.parse(parts[0]);
        } catch (e) {
          heap[parts[1]] = heap[parts[0]];
        }
        break;
      case 'inc':
        heap[instr.substring(4)]++;
        break;
      case 'dec':
        heap[instr.substring(4)]--;
        break;
      case 'jnz':
        if (heap[instr.substring(4, 5)] != 0) {
          pointer += int.parse(instr.substring(6)) - 1;
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
    'cpy 1 a',
    'cpy 1 b',
    'cpy 26 d',
    'jnz c 2',
    'jnz 1 5',
    'cpy 7 c',
    'inc d',
    'dec c',
    'jnz c -2',
    'cpy a c',
    'inc a',
    'dec b',
    'jnz b -2',
    'cpy c b',
    'dec d',
    'jnz d -6',
    'cpy 19 c',
    'cpy 14 d',
    'inc a',
    'dec d',
    'jnz d -2',
    'dec c',
    'jnz c -5'
  ];
  Stopwatch time = new Stopwatch()..start();
  print('Part 1: ${run(instructions, {"a":0,"b":0,"c":0,"d":0})} ${time.elapsed}');
  time.reset();
  print('Part 2: ${run(instructions, {"a":0,"b":0,"c":1,"d":0})} ${time.elapsed}');
}