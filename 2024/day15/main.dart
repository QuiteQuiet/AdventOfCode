import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';

bool canMove(Grid<String> maze, ({int x, int y}) pos, ({int x, int y}) dir) {
  String next = maze.at(pos.x + dir.x, pos.y + dir.y);
  if (next == '.') {
    return true;
  } else if (next == 'O') {
    return canMove(maze, (x: pos.x + dir.x, y: pos.y + dir.y), dir);
  } else if (next == '[' || next == ']') {
    if (dir.x != 0) {
      return canMove(maze, (x: pos.x + dir.x, y: pos.y), dir);
    } else if (dir.y != 0) {
      int x = next == ']' ? -1 : 1;
      return canMove(maze, (x: pos.x, y: pos.y + dir.y), dir) &&
             canMove(maze, (x: pos.x + x, y: pos.y + dir.y), dir);
    }
  }
  return false;
}

void moveBoxes(Grid<String> maze, ({int x, int y}) pos, ({int x, int y}) dir, [bool robot = false]) {
  String next = maze.at(pos.x + dir.x, pos.y + dir.y);
  if (next == '.') {
    maze.put(pos.x + dir.x, pos.y + dir.y, maze.at(pos.x, pos.y));
    maze.put(pos.x, pos.y, '.');
  } else {
    moveBoxes(maze, (x: pos.x + dir.x, y: pos.y + dir.y), dir);
    if (next != 'O' && dir.y != 0) {
      moveBoxes(maze, (x: pos.x + (next == '[' ? 1 : -1), y: pos.y + dir.y), dir);
    }
    maze.put(pos.x + dir.x, pos.y + dir.y, maze.at(pos.x, pos.y));
    maze.put(pos.x, pos.y, '.');
  }
}

void main() async {
  List<String> input = (await aoc.getInputString()).split('\n\n');

  Grid<String> first = Grid.string(input[0], (e) => e);
  Grid<String> second = Grid.filled(first.width * 2, first.height, '.');
  String moves =  input[1].replaceAll('\n', '');

  ({int x, int y}) start = (x: 0, y: 0);
  first.every((x, y, e) {
    if (e == '@') {
      start = (x: x, y: y);
    } else if (e == '#') {
      second.put(2 * x, y, '#');
      second.put(2 * x + 1, y, '#');
    } else if (e == 'O') {
      second.put(2 * x, y, '[');
      second.put(2 * x + 1, y, ']');
    }
  });

  ({int x, int y}) r1 = start, r2 = (x: start.x * 2, y: start.y);
  second.put(r2.x, r2.y, '@');

  for (int act in moves.runes) {
    ({int x, int y}) dir = switch (act) {
      60 => (x: -1, y: 0), // <
      62 => (x: 1, y: 0),  // >
      94 => (x: 0, y: -1), // ^
      118 => (x: 0, y: 1), // v
      _ => (x: 0, y: 0),
    };
    if (canMove(first, r1, dir)) {
      moveBoxes(first, r1, dir);
      r1 = (x: r1.x + dir.x, y: r1.y + dir.y);
    }
    if (canMove(second, r2, dir)) {
      moveBoxes(second, r2, dir);
      r2 = (x: r2.x + dir.x, y: r2.y + dir.y);
    }
  }

  print('Part 1: ${first.fold(0, (s, x, y, e) => s + ({'O': 100 * y + x}[e] ?? 0))}');
  print('Part 2: ${second.fold(0, (s, x, y, e) => s + ({'[': 100 * y + x}[e] ?? 0))}');
}