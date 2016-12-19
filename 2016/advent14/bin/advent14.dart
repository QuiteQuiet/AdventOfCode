class Disc {
  int positions, current;
  Disc(this.positions, this.current);
  int tick(int time) => (this.current + time) % this.positions;
}
void main() {
  // hardcoded input lul
  List<Disc> input = [new Disc(5, 2), new Disc(13, 7), new Disc(17, 10),
                      new Disc(3, 2), new Disc(19, 9), new Disc(7, 0), new Disc(11, 0)
  ];
  int time = 0, p1 = -1, step = 1, deepest = -1, iterations = 0;
  bool done;
  Stopwatch timer = new Stopwatch()..start();
  for (;; time += step) {
    iterations++;
    done = true; // assume valid
    for (int i = 0; i < input.length; i++) {
      if (input[i].tick(time + 1 + i) == 0 && i > deepest) {
        step *= input[i].positions;
        deepest = i;
        print('Aligns the first ${i + 1} disc${i == 0 ? "" : "s"}: $time + ${step}x');
      }
      if (input[i].tick(time + 1 + i) != 0) {
        done = false;
        // part 1
        if (p1 == -1 && i > 5) {
          p1 = time;
        }
        break;
      }
    }
    if (done) {
      break;
    } 
  }
  print('Part 1: $p1');
  print('Part 2: $time in ${timer.elapsed} with $iterations iterations');
}
