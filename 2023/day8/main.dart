import 'dart:io';
import 'package:dart_numerics/dart_numerics.dart' as numerics;

void main() async {
  List<String> lines = await File('input.txt').readAsLines();
  String instructions = lines.first;

  Map<String, Map<String, String>> nodes = {};
  lines.sublist(2).forEach((e) {
    List<String> dir = RegExp(r'(\w+)').allMatches(e).map((e) => e.group(0)!).toList();
    nodes[dir[0]] = {'L': dir[1], 'R': dir[2]};
  });

  int find(String goal, String loc) {
    int steps = 0;
    while (!loc.endsWith(goal))
      loc = nodes[loc]![instructions[steps++ % instructions.length]]!;
    return steps;
  }
  print('Part 1: ${find("ZZZ", "AAA")}');

  Map<String, int> loc = Map.fromIterable(nodes.keys.where((e) => e.endsWith('A')),
    key: (e) => e, value: (_) => 0);

  int distance = 1;
  for (String pos in loc.keys) {
    distance = numerics.leastCommonMultiple(distance, find('Z', pos));
  }
  print('Part 2: $distance');
}