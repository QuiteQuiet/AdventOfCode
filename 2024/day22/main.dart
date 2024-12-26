import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

int next(int n) {
  n = ((n << 6) ^ n) % 16777216;
  n = ((n >> 5) ^ n) % 16777216;
  n = ((n << 11) ^ n) % 16777216;
  return n;
}

void main() async {
  List<int> lines = (await aoc.getInput()).map(int.parse).toList();
  List<int> sequences = List.generate(0xFFFFF, (index) => 0);

  int sum = 0;
  for (int secret in lines) {
    Set<int> seen = {};
    int register = 0, diff = 0, prize = secret % 10;

    for (int i = 0; i < 2000; i++) {
      secret = next(secret);
      diff = (secret % 10) - prize;
      prize = secret % 10;

      register = ((register << 5) | (diff + 9)) & 0xFFFFF;
      if (i >= 4 && seen.add(register)) {
        sequences[register] += prize;
      }
    }
    sum += secret;

  }
  print('Part 1: $sum');
  print('Part 2: ${sequences.reduce((a, b) => a < b ? b : a)}');
}