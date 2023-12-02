void main() {
  List<String> parts = 'R3, L5, R2, L1, L2, R5, L2, R2, L2, L2, L1, R2, L2, R4, R4, R1, L2, L3, R3, L1, R2, L2, L4, R4, R5, L3, R3, L3, L3, R4, R5, L3, R3, L5, L1, L2, R2, L1, R3, R1, L1, R187, L1, R2, R47, L5, L1, L2, R4, R3, L3, R3, R4, R1, R3, L1, L4, L1, R2, L1, R4, R5, L1, R77, L5, L4, R3, L2, R4, R5, R5, L2, L2, R2, R5, L2, R194, R5, L2, R4, L5, L4, L2, R5, L3, L2, L5, R5, R2, L3, R3, R1, L4, R2, L1, R5, L1, R5, L1, L1, R3, L1, R5, R2, R5, R5, L4, L5, L5, L5, R3, L2, L5, L4, R3, R1, R1, R4, L2, L4, R5, R5, R4, L2, L2, R5, R5, L5, L2, R4, R4, L4, R1, L3, R1, L1, L1, L1, L4, R5, R4, L4, L4, R5, R3, L2, L2, R3, R1, R4, L3, R1, L4, R3, L3, L2, R2, R2, R2, L1, L4, R3, R2, R2, L3, R2, L3, L2, R4, L2, R3, L4, R5, R4, R1, R5, R3'.split(', ');
  Map<String, Map<String, String>> turns = {'n':{'R':'e','L':'w'},'e':{'R':'s','L':'n'},'s':{'R':'w','L':'e'},'w':{'R':'n','L':'s'}};
  Map<String, Map<String, int>> move = {'n':{'x':1,'y':0},'e':{'x':0,'y':1},'s':{'x':-1,'y':0},'w':{'x':0,'y':-1}};
  Map<String, int> loc = {'x':0, 'y':0};
  List<String> visited = new List.empty(growable: true);
  String dir = 'n';
  int part2Dist = -1;
  parts.forEach((String s) {
    dir = turns[dir]![s[0]]!;
    for (int i = 0, dist = int.parse(s.substring(1)); i < dist; i++) {
      loc['x'] = loc['x']! + move[dir]!['x']!;
      loc['y'] = loc['y']! + move[dir]!['y']!;
      // Part 2
      if (part2Dist < 0) {
        if (visited.contains('$loc')) {
          part2Dist = loc['x']!.abs() + loc['y']!.abs();
        }
        visited.add('$loc');
      }
    }
  });
  print('Part 1: ${loc['x']!.abs() + loc['y']!.abs()}');
  print('Part 2: $part2Dist');
}
