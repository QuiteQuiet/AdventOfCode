import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

Map<String, Set<String>> requirements(List<String> lines) {
  Map<String, Set<String>> required = {};

  RegExp step = new RegExp(r'Step (\w+) .+ step (\w+) ');
  for (String line in lines) {
    RegExpMatch match = step.firstMatch(line)!;
      String dep = match.group(1)!;
       String toDo = match.group(2)!;
      required[dep] ??= Set();
      (required[toDo] ??= Set()).add(dep);
  }
  return required;
}

void main() async {
  List<String> lines = await aoc.getInput();

  Map<String, Set<String>> required = requirements(lines);

  List<String> order = [];
  while (required.isNotEmpty) {
    List<String> left = required.keys.toList()..sort();
    String next = left.firstWhere((step) => required[step]!.isEmpty);
    order.add(next);
    required.remove(next);
    for (Set<String> deps in required.values) {
      deps.remove(next);
    }
  }
  print('Part 1: ${order.join("")}');
}