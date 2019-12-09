class IntcodeComputer {
  List<int> _program;
  String _base;
  int pointer = 0, base = 0;
  bool continous;
  bool done = false;

  IntcodeComputer(String this._base) { _program = _base.split(',').map(int.parse).toList(); }

  void reset() {
    _program = _base.split(',').map(int.parse).toList();
    pointer = 0;
    base = 0;
  }
  void alloc(int size) => _program.addAll(List.filled(size, 0, growable: true));
  int reads(int mode, int value) => _program[{0: _program[value], 1: value, 2: _program[value] + base}[mode]];
  int writes(int mode, int value) => _program[value] + {0: 0, 2: base}[mode];
  int run({int noun = null, int verb = null, List<int> input = null, List<int> output = null}) {
    int temp, opcode;

    _program[1] = noun ?? _program[1];
    _program[2] = verb ?? _program[2];
    do {
      temp = _program[pointer];
      opcode = temp % 100;
      int m1 = temp ~/ 100 % 10, m2 = temp ~/ 1000 % 10, m3 = temp ~/ 10000 % 10;
      switch(opcode) {
        case 1:
          _program[writes(m3, pointer + 3)] = reads(m1, pointer + 1) + reads(m2, pointer + 2);
          pointer += 4;
          break;
        case 2:
          _program[writes(m3, pointer + 3)] = reads(m1, pointer + 1) * reads(m2, pointer + 2);
          pointer += 4;
          break;
        case 3:
          if (input.length < 1) {
            return null;
          }
          _program[writes(m1, pointer + 1)] = input.removeAt(0);
          pointer += 2;
          break;
        case 4:
          output.add(reads(m1, pointer + 1));
          pointer += 2;
          break;
        case 5:
          pointer = reads(m1, pointer + 1) != 0 ? reads(m2,pointer + 2) : pointer + 3;
          break;
        case 6:
          pointer = reads(m1, pointer + 1) == 0 ? reads(m2, pointer + 2) : pointer + 3;
          break;
        case 7:
          _program[writes(m3, pointer + 3)] = reads(m1, pointer + 1) < reads(m2, pointer + 2) ? 1 : 0;
          pointer += 4;
          break;
        case 8:
          _program[writes(m3, pointer + 3)] = reads(m1, pointer + 1) == reads(m2, pointer + 2) ? 1 : 0;
          pointer += 4;
          break;
        case 9:
          base += reads(m1, pointer + 1);
          pointer += 2;
          break;
        case 99:
          done = true;
          break;
      }
    } while(opcode != 99);

    int result = _program[0];
    if (input != null) {
      result = output.last;
    }
    reset();
    return result;
  }
}