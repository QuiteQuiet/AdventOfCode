import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/space.dart';
import 'package:AdventOfCode/string.dart';

List<Point> asCoordinates(Grid<String> keypad, List<String> sequence) => sequence.map(
  (key) {
    Point? ret;
    keypad.every((x, y, e) {
      if (e == key)
        ret = Point(x, y);
    });
    return ret!;
  }).toList();

/// Calculate all possible methods for traveling from one number to another on the keypad.
/// It's harder to know which is best here so all options need to be considered.
List<String> pathForNumberKeys(List<Point> keycode, Grid<String> keypad) {
  List<String> options = [];
  List<(Point, int, List<String>)> stack = [(keycode[0], 1, [])];
  while (stack.isNotEmpty) {
    final (Point cur, int dest, List<String> path) = stack.removeLast();
    if (dest >= keycode.length) {
      options.add(path.join(''));
      continue;
    }
    if (keypad.atPoint(cur) == ' ' || keypad.outOfBounds(cur.xi, cur.yi)) {
      continue;
    }
    Point end = keycode[dest];
    int dx = end.xi - cur.xi, dy = end.yi - cur.yi;
    if (dx == 0 && dy == 0)
      stack.add((Point(cur.xi, cur.yi), dest + 1, [...path, 'A']));
    if (dy != 0)
      stack.add((Point(cur.xi, cur.yi + dy), dest, [...path, ...List.filled(dy.abs(), dy < 0 ? '^' : 'v')]));
    if (dx != 0)
      stack.add((Point(cur.xi + dx, cur.yi), dest, [...path, ...List.filled(dx.abs(), dx < 0 ? '<' : '>')]));
  }
  return options;
}

String pathForArrowKeys(List<Point> points, Grid<String> arrows) {
  List<String> moves = [];
  for (int i = 1; i < points.length; i++) {
    Point start = points[i - 1], end = points[i];
    num dx = end.xi - start.xi, dy = end.yi - start.yi;

    // Stacking < and v together saves the most time for recursive robots
    // so do that first if possible, which is always unless traveling to the
    // < itself, which would go over the empty tile.
    if (arrows.atPoint(end) == '<') {
      for (; 0 < dy; dy--) moves.add('v');
      for (; dx < 0; dx++) moves.add('<');
    } else {
      for (; dx < 0; dx++) moves.add('<');
      for (; 0 < dy; dy--) moves.add('v');
    }

    // Similarly, ^ and > in that order is the best unless going from <
    // where going up first goes over the empty square.
    if (arrows.atPoint(start) == '<') {
      for (; 0 < dx; dx--) moves.add('>');
      for (; dy < 0; dy++) moves.add('^');
    } else {
      for (; dy < 0; dy++) moves.add('^');
      for (; 0 < dx; dx--) moves.add('>');
    }
    moves.add('A');
  }
  return moves.join('');
}

/// This calculates the cost of moving between two buttons for the maximum recursion
/// depth (the number of robots). It can only handle a single movement at a time.
/// To calculate a sequence of moves like vA<A>>^AvAAA>A it needs to be split up
/// into individual moves that ends at A (vA, <A, >>^A, vA, A, A, >A).
int Function(String, int) memoizeFunction(Map costs, int maxDepth) {
  List<Map<String, int>> cache = List.generate(maxDepth + 1, (_) => {});

  int findPresses(String cur, int depth) {
    if (cache[depth].containsKey(cur))
      return cache[depth][cur]!;
    if (depth >= maxDepth)
      return cache[depth][cur] = cur.length;

    int presses = findPresses(costs['A']![cur[0]]!, depth + 1);
    for (int i = 1; i < cur.length; i++)
      presses += findPresses(costs[cur[i - 1]]![cur[i]]!, depth + 1);
    return cache[depth][cur] = presses;
  }
  return findPresses;
}

void main() async {
  List<String> lines = await aoc.getInput();

  Grid<String> numbers = Grid.from([['7', '8', '9'],
                                    ['4', '5', '6'],
                                    ['1', '2', '3'],
                                    [' ', '0', 'A']]),
              arrows = Grid.from([[' ', '^', 'A'],
                                  ['<', 'v', '>']]);

  // Pre-compute a cost array from going from one button to any other button
  Map<String, Map<String, String>> costs = {};
  for (String start in ['A', '^', '<', '>', 'v']) {
    costs[start] = {};
    for (String end in ['A', '^', '<', '>', 'v']) {
      costs[start]![end] = pathForArrowKeys(asCoordinates(arrows, [start, end]), arrows);
    }
  }
  int Function(String, int) part1 = memoizeFunction(costs, 2);
  int Function(String, int) part2 = memoizeFunction(costs, 25);

  // Calculate the best possible length of moves for a given list of button presses.
  int bestScore(int Function(String, int) scoreFunction, List<String> options) {
    int best = 0xFFFFFFFFFFFFFFF;
    for (String option in options) {
      int total = 0;
      // Split the moves according to the requirements for `findPresses`.
      List<String> parts = option.split('A');
      for (String part in parts) {
        if (part.isEmpty) continue;
        total += scoreFunction('${part}A', 0);
      }
      best = total < best ? total : best;
    }
    return best;
  }

  int complexity1 = 0, complexity2 = 0;
  for (final String seq in lines) {
    List<String> options = pathForNumberKeys(asCoordinates(numbers, ['A', ...seq.split('')]), numbers);
    int value = seq.substring(0, seq.length - 1).toInt();

    complexity1 += value * bestScore(part1, options);
    complexity2 += value * bestScore(part2, options);
  }
  print('Part 1: $complexity1');
  print('Part 2: $complexity2');
}