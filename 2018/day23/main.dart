import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';
import 'package:collection/collection.dart';

class Nanobot {
  int x, y, z, r;
  Nanobot(this.x, this.y, this.z, this.r);
  int distance(Nanobot o) => (x - o.x).abs() + (y - o.y).abs() + (z- o.z).abs();

  int _rd(int c, int low, int high) {
    if (c < low) return low - c;
    if (c > high) return c - high;
    return 0;
  }
  int inRange(Nanobot o) => _rd(o.x, x, x + r) + _rd(o.y, y, y + r) + _rd(o.z, z, z + r);
}

void main() async {
  List<Nanobot> nanobots = [];

  Nanobot? strongest;
  for (String line in await aoc.getInput()) {
    List<int> n = line.numbers();
    nanobots.add(Nanobot(n[0], n[1], n[2], n[3]));
    Nanobot c = nanobots.last;
    if (strongest == null || c.r > strongest.r) {
      strongest = c;
    }
  }
  int inRange(Nanobot n) => nanobots.where((e) => n.distance(e) <= n.r).length;
  print('Part 1: ${inRange(strongest!)}');

  Nanobot origin = Nanobot(0, 0, 0, 0);
  HeapPriorityQueue<(Nanobot, int)> queue = HeapPriorityQueue((a, b) {
    if (a.$2 != b.$2)
      return b.$2 - a.$2;
    else {
      int ad = a.$1.distance(origin), bd = b.$1.distance(origin);
      if (ad != bd)
        return bd - ad;
      else
        return b.$1.r - a.$1.r;
    }
  });

  int canReach(Nanobot n) => nanobots.where((e) => n.inRange(e) <= e.r).length;
  Nanobot space = Nanobot(-1000000000, -1000000000, -1000000000, 0x7FFFFFFF);

  Nanobot? answer;
  queue.add((space, canReach(space)));
  while (queue.isNotEmpty) {
    final (Nanobot cur, int _) = queue.removeFirst();
    if (cur.r == 1) {
      answer = cur;
      break;
    }

    int size = cur.r ~/ 2;
    for ((int, int, int) n in [(0, 0, 0),
                               (size, 0, 0), (0, size, 0), (0, 0, size),
                               (size, size, 0), (size, 0, size), (0, size, size),
                               (size, size, size)]) {
      Nanobot next = Nanobot(cur.x + n.$1, cur.y + n.$2, cur.z + n.$3, size);
      int bots = canReach(next);
      if (bots != 0)
        queue.add((next, bots));
    }
  }
  print('Part 2: ${answer!.distance(origin) + 1}');
}
