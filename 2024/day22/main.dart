import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

int next(int n) {
  n = ((n << 6) ^ n) % 16777216;
  n = ((n >> 5) ^ n) % 16777216;
  n = ((n << 11) ^ n) % 16777216;
  return n;
}

void main() async {
  List<int> lines = (await aoc.getInput()).map(int.parse).toList();

  Map<int, int> sequences = {};

  int sum = 0;
  for (int secret in lines) {
    List<int> buffer = [];
    Set<int> seen = {};
    int prize = secret % 10;

    for (int i = 0; i < 1999; i++) {
      secret = next(secret);
      buffer.add((secret % 10) - prize);
      prize = secret % 10;

      if (buffer.length >= 4) {
        int start = buffer.length - 4, change = 0;
        for (int i = 0; i < 4; i++)
          change |= (buffer[start + i] + 10) << (20 * (3 - i));
        if (!seen.contains(change)) {
          sequences[change] = (sequences[change] ?? 0) + prize;
          seen.add(change);
        }
      }
    }
    sum += secret;

  }
  print('Part 1: $sum');
  print('Part 2: ${sequences.values.reduce((a, b) => a < b ? b : a)}');
}