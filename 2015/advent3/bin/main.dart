import 'dart:io';

void main() {
  int x = 0, y = 0;
  Map<String, int> houses = new Map<String, int>();
  String input = new File('input.txt').readAsStringSync();
  for (int i = 0; i < input.length; i++) {
    houses['$x,$y'] = 1;
    switch (input[i]) {
      case '^': x--; break;
      case 'v': x++; break;
      case '>': y++; break;
      case '<': y--; break;
    }
  }
  print('Part 1: ${houses.keys.length}');

  houses.clear();
  List<List<int>> partners = [[0, 0], [0, 0]];
  for (int i = 0; i < input.length; i++) {
    List<int> cur = partners[i % 2];
    houses['$cur'] = 1;
    switch (input[i]) {
      case '^': cur[0]--; break;
      case 'v': cur[0]++; break;
      case '>': cur[1]++; break;
      case '<': cur[1]--; break;
    }
  }
  print('Part 2: ${houses.keys.length}');
}

