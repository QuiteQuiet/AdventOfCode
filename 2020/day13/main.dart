import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

int chineeseReminderTheorem(List<(int, int)> busses) {
  int prod = busses.fold(1, (p, e) => p * e.$2);

  int result = 0;
  for (final (int rem, int bus) in busses) {
    int pp = prod ~/ bus;
    result += rem * pp.modInverse(bus) * pp;
  }
  return result % prod;
}

void main() async {
  List<String> lines = await aoc.getInput();

  int arrival = lines[0].toInt();
  List<(int, int)> soonest = lines[1].numbers()
    .map((e) => (e, e * (arrival / e).ceil())).toList()
    ..sort((a, b) => a.$2 - b.$2);
  print('Part 1: ${(soonest.first.$2 - arrival) * soonest.first.$1}');

  List<(int, int)> busses = lines[1].split(',').indexed
    .where((e) => e.$2 != 'x')
    .map((e) => ((e.$2.toInt() - e.$1) % e.$2.toInt(), e.$2.toInt())).toList();

  print('Part 2: ${chineeseReminderTheorem(busses)}');
}
