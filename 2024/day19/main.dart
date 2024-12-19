import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

int Function(String, List<String>) memoizedFunction() {
  Map<String, int> cache = {};

  int options(String pattern, List<String> patterns) {
    if (cache.containsKey(pattern)) {
      return cache[pattern]!;
    }
    if (pattern.length == 0)
      return 1;

    List<int> all = [0];
    for (String opt in patterns) {
      if (pattern.startsWith(opt)) {
        all.add(options(pattern.replaceFirst(opt, ''), patterns));
      }
    }
    return cache[pattern] = all.reduce((a, b) => a + b);
  }
  return options;
}


void main() async {
  List<String> lines = await aoc.getInput();
  int Function(String, List<String>) possible = memoizedFunction();

  List<String> patterns = lines[0].split(', ');
  List<String> desired = lines.sublist(2);
  int works = 0, all = 0;

  desired.map((d) => possible(d, patterns)).where((e) => e != 0).forEach((e) {
    works++;
    all += e;
  });
  print('Part 1: $works');
  print('Part 2: $all');
}