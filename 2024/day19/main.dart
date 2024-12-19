import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  List<String> input = await aoc.getInput();
  List<String> patterns = input[0].split(', ');
  List<String> towels = input.sublist(2);

  Map<String, int> cache = {};
  int options(String towel) {
    if (cache.containsKey(towel))
      return cache[towel]!;
    if (towel.length == 0)
      return 1;
    return cache[towel] = patterns.where(towel.startsWith)
                                  .map((opt) => options(towel.replaceFirst(opt, '')))
                                  .fold(0, (a, b) => a + b);
  }

  int works = 0, all = 0;
  towels.map(options).where((e) => e != 0).forEach((e) {
    works++;
    all += e;
  });
  print('Part 1: $works');
  print('Part 2: $all');
}