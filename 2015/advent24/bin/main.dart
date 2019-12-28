class Config {
  List<int> order;
  int bound;
  Config(this.order, this.bound);
}

int quantum(List<int> input, int containers) {
  List<Config> works = new List<Config>();
  int section = input.reduce((a,b) => a + b) ~/ containers, testing;
  for (int j = 0; j < 1000000; j++) {
    // We might be lucky!
    input.shuffle();
    testing = 0;
    for (int i = 0; i < input.length; i++) {
      testing += input[i];
      if (testing == section) {
        works.add(new Config(new List.from(input), i + 1));
        break;
      }
    }
  }
  Config best = new Config([], input.length + 1);
  works.forEach((element) {
    if (element.bound < best.bound) {
      best = element;
    } else if (element.bound == best.bound) {
      int qea = element.order.take(element.bound).reduce((x, y) => x * y);
      int qeb = best.order.take(best.bound).reduce((x, y) => x * y);
      if (qea < qeb) {
        best = element;
      }
    }
  });
  return best.order.take(best.bound).reduce((x, y) => x * y);
}
main() {
  List<int> input = [1,2,3,7,11,13,17,19,23,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113];
  print('Part 1: ${quantum(input, 3)}');
  print('Part 2: ${quantum(input, 4)}');
}