import 'dart:io';
import 'package:AdventOfCode/grid.dart';

class Coord {
  int x, y;
  String c;
  Coord(this.x, this.y, [this.c = '']);
  Coord.invalid() : this(-1, -1, '');

  bool operator==(Object o) => o is Coord && x == o.x && y == o.y;
  int get hashCode => Object.hash(x, y);
  String toString() => '($x, $y, $c)';
}

void main() async {
  Grid<String> input = Grid.from(
    (await File('input.txt').readAsLines()).map((e) => e.split('')));

  Coord start = Coord.invalid();
  input.every((x, y, e) {
    if (e == 'S') {
      start = Coord(x, y, 'S');
    }
  });

  Coord dir = Coord.invalid();
  input.adjacent(start.x, start.y, (x, y, e) {
    if (('-J7'.contains(e) && start.x < x) ||
        ('-LF'.contains(e) && start.x > x) ||
        ('|JL'.contains(e) && start.y < y) ||
        ('|7F'.contains(e) && start.y > y)
    ) {
      dir = Coord(x - start.x, y - start.y);
    }
  });

  int steps = 0;
  Coord cur = start;
  List<Coord> corners = [];
  do {
    if ('SLJF7'.contains(cur.c))
      corners.add(cur);
    cur = Coord(cur.x + dir.x,
                cur.y + dir.y,
                input.at(cur.x + dir.x, cur.y + dir.y));
    steps++;
    dir = switch (cur.c) {
      '|' || '-' => dir,
      'L' || '7' => Coord(dir.y, dir.x),
      'J' || 'F' => Coord(-dir.y, -dir.x),
      _ => Coord.invalid(),
    };
  } while (start != cur);

  print('Part 1: ${steps ~/ 2}');

  corners.add(corners.first);
  int sum = 0;
  for (final (int i, Coord cur) in corners.sublist(0, corners.length - 1).indexed) {
    sum += cur.x * corners[i + 1].y - cur.y * corners[i + 1].x;
  }
  print('Part 2: ${(sum.abs() - steps) ~/ 2 + 1}');
}