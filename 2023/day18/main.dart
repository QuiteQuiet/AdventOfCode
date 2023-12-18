import 'dart:io';

void main() async {
  List<String> input = await File('input.txt').readAsLines();

  (int, int) directions(String d) => switch (d) {
    'L' || '2' => (-1, 0),
    'R' || '0' => (1, 0),
    'U' || '3' => (0, -1),
    'D' || '1' => (0, 1),
    _ => (0, 0),
  };
  (int, int) prev = (0, 0), prevH = (0, 0);

  int circumference = 0, area = 0;
  int circumferenceH = 0, areaH = 0;
  for (String instr in input) {
    List<String> parts = instr.split(' ');

    // Part 1
    int steps = int.parse(parts[1]);
    circumference += steps;

    (int, int) dir = directions(parts[0]);
    (int, int) cur = (prev.$1 + dir.$1 * steps, prev.$2 + dir.$2 * steps);
    area += prev.$1 * cur.$2 - prev.$2 * cur.$1;
    prev = cur;

    // Part 2
    int stepsH = int.parse(parts[2].substring(2, 7), radix: 16);
    circumferenceH += stepsH;

    (int, int) dirH = directions(parts[2].substring(7, 8));
    (int, int) curH = (prevH.$1 + dirH.$1 * stepsH, prevH.$2 + dirH.$2 * stepsH);
    areaH += prevH.$1 * curH.$2 - prevH.$2 * curH.$1;
    prevH = curH;
  }
  print('Part 1: ${(area + circumference) ~/ 2 + 1}');
  print('Part 2: ${(areaH + circumferenceH) ~/ 2 + 1}');
}