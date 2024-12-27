import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  List<String> lines = await aoc.getInput();

  String plantpots = '......${lines[0].split(': ')[1]}......';
  Map<String, String> rules = Map.fromIterable(lines.skip(2), key: (e) => e.split(' =>')[0], value: (e) => e.split('=> ')[1]);
  int center = 6;

  int score() {
    int sum = 0;
    for (int i = 0; i < plantpots.length; i++) {
      if (plantpots[i] == '#') {
        sum += (i - center);
      }
    }
    return sum;
  }

  int cur = score(), prev = cur;
  int diff = 0, toGo = 50000000000;
  // 150 is long enough to enter a steady-state increase
  for (int i = 0; i < 150; i++) {
    if (i == 20) {
      print('Part 1: ${score()}');
    }
    List<String> next = ['.', '.', '.'];
    for (int s = 2; s < plantpots.length - 2; s++) {
      next.add(rules[plantpots.substring(s - 2, s + 3)]!);
    }
    plantpots = [...next, '.', '.', '.'].join('');
    center += 1;
    toGo--;
    cur = score();
    diff = cur - prev;
    prev = cur;
  }
  print('Part 2: ${score() + diff * toGo}');
}
