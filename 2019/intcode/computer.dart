import 'dart:collection';

class GrowableList<E> extends ListBase<E> {
  final List<E> _l = [];
  GrowableList();
  GrowableList.from(Iterable<E> it) { _l.addAll(it); }
  void set length(int newLength) { _l.length = newLength; }
  int get length => _l.length;
  void clear() => _l.clear();
  E operator [](int index) {
    try {
       return _l[index];
    } catch (RangeError) {
      E e;
      if (index - _l.length > 10000) throw OutOfMemoryError();
      _l.addAll(List.filled(index - _l.length + 1, e ?? 0, growable: true));
      return _l[index];
    }
  }
  void operator []=(int index, E value) {
    try {
       _l[index] = value;
    } catch (RangeError) {
      E e;
      if (index - _l.length > 10000) throw OutOfMemoryError();
      _l.addAll(List.filled(index - _l.length + 1, e ?? 0, growable: true));
      _l[index] = value;
    }
  }
}

class IntcodeComputer {
  GrowableList<int> _program;
  List<String> _base;
  int pointer = 0, base = 0;
  bool done = false, resets;

  IntcodeComputer(this._base, {this.resets=true}) : _program = GrowableList.from(_base.map(int.parse));

  IntcodeComputer copy() {
    IntcodeComputer c = IntcodeComputer(_base, resets: resets);
    c._program = GrowableList.from(_program);
    c.base = base;
    c.pointer = pointer;
    c.done = done;
    return c;
  }
  void reset() {
    _program.clear();
    _program = GrowableList.from(_base.map(int.parse));
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