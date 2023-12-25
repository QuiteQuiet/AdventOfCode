import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';

int stepsToGoal(String start, String end, Map<String, Set<String>> wires) {
  Set<String> seen = {};
  Queue<(String, int)> toVisit = Queue()..add((start, 0));

  while (toVisit.isNotEmpty) {
    final (String cur, int s) = toVisit.removeFirst();
    if (seen.contains(cur)) continue;
    seen.add(cur);

    if (cur == end) {
      return s;
    }
    wires[cur]!.forEach((e) => toVisit.add((e, s + 1)));
  }
  return 0;
}

void main() async {
  List<String> input = await File('input.txt').readAsLines();

  Map<String, Set<String>> wires = {};
  for (String line in input) {
    List<String> components = RegExp(r'\w+').allMatches(line).map((e) => e.group(0)!).toList();

    wires[components[0]] ??= {};
    for (String comp in components.sublist(1)) {
      wires[components[0]]!.add(comp);
      (wires[comp] ??= {}).add(components[0]);
    }
  }
  Map<int, List<(String, String)>> costs = {};
  Map<String, Set<String>> lookedAt = {};
  for (String start in wires.keys) {
    Set<String> tmp = Set.from(wires[start]!); // To avoid changing the iterated list
    for (String end in tmp) {
      // Already tested this in the other direction
      if ((lookedAt[end] ?? {}).contains(start)) continue;
      (lookedAt[start] ??= {}).add(end);

      wires[start]!.remove(end);
      int stepsNow = stepsToGoal(start, end, wires);
      wires[start]!.add(end);

      (costs[stepsNow] ??= []).add((start, end));
    }
  }
  List<(String, String)> toRemove = [];
  for (int c in costs.keys.sorted((a, b) => b - a)) {
    if (toRemove.length >= 3) break; // Can only remove 3
    toRemove.addAll(costs[c]!);
  }
  for (final (String s, String e) in toRemove) {
    wires[s]!.remove(e);
    wires[e]!.remove(s);
  }

  List<List<String>> cycles = [];
  Set<String> seen = {};
  Queue<String> toVisit = Queue()..add(wires.keys.first);

  while (toVisit.isNotEmpty) {
    String next = toVisit.removeFirst();
    if (seen.contains(next)) continue;
    seen.add(next);

    wires[next]!.forEach(toVisit.add);
  }
  // We didn't find all wires going through this so there are two groups (probably)
  if (seen.length < wires.keys.length) {
    cycles.add(List.from(seen));
    cycles.add(List.from(wires.keys.where((e) => !seen.contains(e))));
  }
  print('Part 1: ${cycles.fold<int>(1, (p, e) => p * e.length)}');
}