class IntcodeComputer {
  List<int> _program;
  String _base;
  int pointer = 0;
  bool reboot;
  bool done = false;

  IntcodeComputer(String this._base, {this.reboot = null}) { _program = _base.split(',').map(int.parse).toList(); }

  void reset() {
    _program = _base.split(',').map(int.parse).toList();
    pointer = 0;
  }

  int resolve(int mode, int value) => mode == 0 ? _program[value] : value;

  int run({int noun = null, int verb = null, List<int> input = null, List<int> output = null, noReset: null}) {
    int temp, opcode;

    _program[1] = noun ?? _program[1];
    _program[2] = verb ?? _program[2];
    do {
      temp = _program[pointer];
      opcode = temp % 100;
      int m1 = temp ~/ 100 % 10, m2 = temp ~/ 1000 % 10;
      switch(opcode) {
        case 1:
          int a = resolve(m1, _program[pointer + 1]),
              b = resolve(m2, _program[pointer + 2]),
              c = _program[pointer + 3];
          _program[c] = a + b;
          pointer += 4;
          break;
        case 2:
          int a = resolve(m1, _program[pointer + 1]),
              b = resolve(m2, _program[pointer + 2]),
              c = _program[pointer + 3];
          _program[c] = a * b;
          pointer += 4;
          break;
        case 3:
          if (input.length < 1) {
            return -1;
          }
          _program[_program[pointer + 1]] = input.removeAt(0);
          pointer += 2;
          break;
        case 4:
          int a = resolve(m1, _program[pointer + 1]);
          output.add(a);
          pointer += 2;
          break;
        case 5:
          int a = resolve(m1, _program[pointer + 1]),
              b = resolve(m2, _program[pointer + 2]);
          if (a != 0) {
            pointer = b;
          } else {
            pointer += 3;
          }
          break;
        case 6:
          int a = resolve(m1, _program[pointer + 1]),
              b = resolve(m2, _program[pointer + 2]);
          if (a == 0) {
            pointer = b;
          } else {
            pointer += 3;
          }
          break;
        case 7:
          int a = resolve(m1, _program[pointer + 1]),
              b = resolve(m2, _program[pointer + 2]),
              c = _program[pointer + 3];
          _program[c] = a < b ? 1 : 0;
          pointer += 4;
          break;
        case 8:
          int a = resolve(m1, _program[pointer + 1]),
              b = resolve(m2, _program[pointer + 2]),
              c = _program[pointer + 3];
          _program[c] = a == b ? 1 : 0;
          pointer += 4;
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
    reboot ?? reset();
    return result;
  }
}