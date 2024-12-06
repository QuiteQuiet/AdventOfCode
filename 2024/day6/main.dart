import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';

void main() async {
  Grid<String> input = Grid.string(await aoc.getInputString(), (e) => e);

  List<({int x, int y})> directions = [(x: 0, y: -1), (x: 1, y: 0), (x: 0, y: 1), (x: -1, y: 0)];
  int startx = -1, starty = -1;
  input.every((x, y, e) {
    if (e == "^") {
      startx = x;
      starty = y;
    }
  });

  (({int x, int y}), int) move(({int x, int y}) g, int d) {
    int newx = g.x + directions[d].x, newy = g.y + directions[d].y;
    if (!input.outOfBounds(newx, newy) && input.at(newx, newy) == '#') {
      d = (d + 1) % directions.length;
    }
    newx = g.x + directions[d].x;
    newy = g.y + directions[d].y;
    if (input.outOfBounds(newx, newy) || input.at(newx, newy) != '#') {
      g = (x: newx, y: newy);
    }
    return (g, d);
  }

  Set<(int, int)> visited = {};
  ({int x, int y}) guard = (x: startx, y: starty);
  int direction = 0;

  while (!input.outOfBounds(guard.x, guard.y)) {
    visited.add((guard.x, guard.y));
    (guard, direction) = move(guard, direction);
  }
  print('Part 1: ${visited.length}');

  Set<(int, int)> loops = {};
  for (final (int x, int y) in visited.skip(1)) {
    Set<(int, int, int)> seen = {};
    guard = (x: startx, y: starty);
    direction = 0;
    input.put(x, y, '#');
    while (!input.outOfBounds(guard.x, guard.y)) {
      (int, int, int) next = (guard.x, guard.y, direction);
      if (seen.contains(next)) {
        loops.add((x, y));
        break;
      }
      seen.add(next);
      (guard, direction) = move(guard, direction);
    }
    input.put(x, y, '.');
  }
  print('Part 2: ${loops.length}');
}