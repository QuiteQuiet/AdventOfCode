class Generator {
  late int start, seed, prev, mod = 1;
  Generator(this.start, this.seed) { this.prev = this.start; }
  void reset() => this.prev = this.start;
  int next() {
    do {
      this.prev = (this.prev * this.seed) % 2147483647;
    } while (this.prev % this.mod != 0);
    return this.prev & 0xFFFF;
  }
}

void main() {
  // input:
  // Generator A starts with 783
  // Generator B starts with 325
  Generator a = new Generator(783, 16807), b = new Generator(325, 48271);
  int pairs1 = 0, pairs2 = 0;

  // part 1
  for (int i = 0; i < 40000000; i++) {
    if (a.next() == b.next()) pairs1++;
  }
  print('Part 1: $pairs1');
  // part 2
  a..reset()..mod = 4;
  b..reset()..mod = 8;
  for (int i = 0; i < 5000000; i++) {
    if (a.next() == b.next()) pairs2++;
  }
  print('Part 2: $pairs2');
}