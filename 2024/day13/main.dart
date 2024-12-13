import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

num rounding(num n, int decimals) => (n * decimals).round() / decimals;

int simulate(List<String> lines, int offset, bool Function(num, num) limits) {
  List<(({int x, int y}), ({int x, int y}), ({int x, int y}))> games = [];
  for (int i = 0; i < lines.length; i += 4) {
    List<int> a = lines[i].numbers(),
              b = lines[i + 1].numbers(),
              p = lines[i + 2].numbers();
    games.add(((x: a[0], y: a[1]),
               (x: b[0], y: b[1]),
               (x: p[0] + offset, y: p[1] + offset)));
  }

  int tokens = 0;
  for (final (a, b, prize) in games) {
    num facor = -(a.y / a.x);
    num y = (prize.y + prize.x * facor) / (b.y + b.x * facor);
    num x = (prize.x - b.x * y) / a.x;

    // Apparently rounding and applying the (x, y) covers floating point errors
    int rx = x.round(), ry = y.round();
    int px = a.x * rx + b.x * ry;
    int py = a.y * rx + b.y * ry;

    if (limits(x, y) && px == prize.x && py == prize.y) {
      tokens += rx * 3 + ry;
    }
  }
  return tokens;
}

void main() async {
  List<String> lines = await aoc.getInput();

  print('Part 1: ${simulate(lines, 0, (x, y) => 0 <= x && x < 100 && 0 <= y && y < 100)}');
  print('Part 2: ${simulate(lines, 10000000000000, (x, y) => true)}');
}