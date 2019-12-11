class IntcodeComputer {
  List<int> _program;
  List<String> _base;
  int pointer = 0, base = 0;
  bool done = false, resets;

  IntcodeComputer(this._base, {this.resets=true}) : _program = _base.map(int.parse).toList();

  void reset() {
    _program = _base.map(int.parse).toList();
    done = false;
    pointer = 0;
    base = 0;
  }
  void alloc(int size) => _program.addAll(List.filled(size, 0, growable: true));
  int reads(int mode, int value) {
    switch (mode) {
      case 0: return _program[_program[value]];
      case 1: return _program[value];
      case 2: return _program[_program[value] + base];
      default: throw Exception('Illegal mode');
    }
  }
  int writes(int mode, int value) {
    switch (mode) {
      case 0: return _program[value];
      case 2: return _program[value] + base;
      default: throw Exception('Illegal mode');
    }
  }
  int run({List<int> input, List<int> output}) {
    do {
      int temp = _program[pointer];
      int m1 = temp ~/ 100 % 10, m2 = temp ~/ 1000 % 10, m3 = temp ~/ 10000 % 10;
      switch(temp % 100) {
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
          pointer = reads(m1, pointer + 1) != 0 ? reads(m2, pointer + 2) : pointer + 3;
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
    } while(!done);
    int result = output?.last ?? _program[0];
    if (resets) reset();
    return result;
  }
}