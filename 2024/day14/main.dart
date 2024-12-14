import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/int.dart';
import 'package:AdventOfCode/string.dart';

class Robot {
  int x, y, vx, vy;
  Robot(this.x, this.y, this.vx, this.vy);
  void tick(int width, int height) {
    x = (x + vx) % width;
    y = (y + vy) % height;
  }
  String toString() => 'R($x $y -> $vx $vy)';
}

void main() async {
  List<Robot> robots = (await aoc.getInput()).map((e) {
    List<int> n = e.numbers();
    return Robot(n[0], n[1], n[2], n[3]);
  }).toList();

  int width = 101, height = 103;

  for (int _ in 0.to(99)) {
    robots.forEach((r) => r.tick(width, height));
  }

  Map<(int, int), int> quads = {(0, 0): 0, (0, 1): 0, (1, 0): 0, (1, 1): 0};
  for (Robot r in robots) {
    if (r.x != width ~/ 2 && r.y != height ~/ 2) {
      int x = r.x ~/ (width / 2).ceil();
      int y = r.y ~/ (height / 2).ceil();
      quads[(x, y)] = (quads[(x, y)] ?? 0) + 1;
    }
  }
  print('Part 1: ${quads.values.reduce((a, b) => a * b)}');

  int seconds = 101;
  for (int i in 0.to(10000)) {
    Map<int, List<int>> rows = {};
    robots.forEach((r) {
      r.tick(width, height);
      (rows[r.y] ??= []).add(r.x);;
    });

    int longest = 0;
    for (List<int> r in rows.values) {
      if (r.length < 25)
        continue;

      int count = 1, prev = (r..sort()).first;
      for (int i in r) {
        count = (prev + 1 == i ? count : 0) + 1;
        if (count >= longest) {
          longest = count;
        }
        prev = i;
      }
    }
    if (longest > 20) {
      seconds += i;
      break;
    }

    rows.clear();
  }
  Grid<String> room = Grid.filled(width, height, '.');
  robots.forEach((r) => room.put(r.x, r.y, '#'));
  print('$room\nPart 2: $seconds');
}