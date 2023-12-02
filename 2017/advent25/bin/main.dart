enum State { A, B, C, D, E, F}
class Machine {
  State s;
  late int cursor, offset;
  late List<int> tape;
  Machine(this.s, [this.cursor = 0]) {
    this.tape = new List.generate(10000, (i) => 0);
    this.offset = this.tape.length ~/ 2;
  }
  int get current => this.tape[this.cursor + this.offset];
  void set current(i) => this.tape[this.cursor + this.offset] = i;
  void step() {
    switch (this.s) {
      case State.A:
        if (this.current == 0) {
          this.current = 1;
          this.cursor++;
        }
        else {
          this.current = 0;
          this.cursor--;
        }
        this.s = State.B;
      break;
      case State.B:
        if (this.current == 0) {
          this.current = 0;
          this.cursor++;
          this.s = State.C;
        }
        else {
          this.current = 1;
          this.cursor--;
        }
      break;
      case State.C:
        if (this.current == 0) {
          this.current = 1;
          this.cursor++;
          this.s = State.D;
        }
        else {
          this.current = 0;
          this.cursor--;
          this.s = State.A;
        }
      break;
      case State.D:
        if (this.current == 0) {
          this.current = 1;
          this.cursor--;
          this.s = State.E;
        }
        else {
          this.current = 1;
          this.cursor--;
          this.s = State.F;
        }
      break;
      case State.E:
        if (this.current == 0) {
          this.current = 1;
          this.cursor--;
          this.s = State.A;
        }
        else {
          this.current = 0;
          this.cursor--;
          this.s = State.D;
        }
      break;
      case State.F:
        if (this.current == 0) {
          this.current = 1;
          this.cursor++;
          this.s = State.A;
        }
        else {
          this.current = 1;
          this.cursor--;
          this.s = State.E;
        }
      break;
    }
  }
  int get checksum => this.tape.reduce((a, b) => a + b);
}

void main() {
  Machine turing = new Machine(State.A);
  for (int i = 0; i < 12586542; i++) {
    turing.step();
  }
  print('Part 1: ${turing.checksum}');
}