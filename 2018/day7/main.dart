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

  required = requirements(lines);
  List<(String, int)> workers = List.filled(5, ('', 0));
  int seconds = 0;
  while (required.isNotEmpty) {
    List<String> left = required.keys.toList()..sort();
    Iterable<String> toDo = left.where((step) => required[step]!.isEmpty);
    for (String next in toDo) {
      for (final (int i, val) in workers.indexed) {
        final (String _, int remain) = val;
        if (remain <= 0) {
          workers[i] = (next, 60 + next.codeUnits[0] - 0x40);
          required.remove(next);
          break;
        }
      }
    }
    for (final (int i, worker) in workers.indexed) {
      int remain = worker.$2 - 1;
      if (remain <= 0) {
        for (Set<String> deps in required.values) {
          deps.remove(worker.$1);
        }
      }
      workers[i] = (worker.$1, remain);
    }
    seconds++;
  }
  print('Part 2: ${seconds + workers.where((e) => e.$2 > 0).fold(0, (a, b) => a + b.$2)}');
}