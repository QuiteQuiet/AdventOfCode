import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';

int next(int n) {
  n = (n ^ (n << 6)) % 16777216;
  n = (n ^ (n >> 5)) % 16777216;
  n = (n ^ (n << 11)) % 16777216;
  return n;
}

void main() async {
  List<int> lines = (await aoc.getInput()).map(int.parse).toList();

  Map<String, int> sequences = {};

  int sum = 0;
  for (int secret in lines) {
    List<int> buffer = [];
    Map<String, int> options = {};
    int prize = secret % 10;

    for (int i = 0; i < 1999; i++) {
      secret = next(secret);
      buffer.add((secret % 10) - prize);
      prize = secret % 10;

      if (buffer.length >= 4) {
        String change = buffer.skip(buffer.length - 4).join(',');
        options[change] ??= prize;
      }
    }
    sum += secret;

    for (final (String change) in options.keys) {
      sequences[change] = (sequences[change] ?? 0) + options[change]!;
    }
  }
  print('Part 1: $sum');
  print('Part 2: ${sequences.values.reduce((a, b) => a < b ? b : a)}');
}