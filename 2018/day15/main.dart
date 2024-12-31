import 'dart:collection';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/space.dart';

int pointOrder(Point a, Point b) => a.yi != b.yi ? a.yi - b.yi : a.xi - b.xi;

class Unit {
  Point loc;
  String type;
  int hp;
  Unit(this.loc, this.type, [this.hp = 200]);
  static int order(Unit a, Unit b) => a.hp != b.hp ? a.hp - b.hp : pointOrder(a.loc, b.loc);
}

(Point, int) bfs(Grid<String> maze, List<Point> priority, Point start, Point end) {
  Queue<(Point, Point, int)> toDo = Queue();
  priority.forEach((p) => toDo.add((start + p, start + p, 1)));

  Set<Point> visited = {};
  while (toDo.isNotEmpty) {
    final (Point cur, Point first, int length) = toDo.removeFirst();
    if (!visited.add(cur)) {
      continue;
    }
    if (cur == end) {
      return (first, length);
    }

    for (Point p in priority) {
      if (maze.atPoint(cur) == '.') {
        toDo.add((cur + p, first, length + 1));
      }
    }
  }
  return (Point(-1, -1), -1);
}

(int, int) runSimulation(Grid<String> maze, List<Unit> units, int elfPower) {
  maze = Grid.copy(maze);
  units = List.generate(units.length, (i) => Unit(units[i].loc, units[i].type, units[i].hp));

  void replace(Point p, String s) => maze.put(p.xi, p.yi, s);

  List<Point> priority = [Point(0, -1), Point(-1, 0), Point(1, 0), Point(0, 1)];
  Map<String, String> enemies = {'G': 'E', 'E': 'G'};

  bool done = false;
  int rounds = 0, elfDeaths = 0;
  while (!done) {
    units.sort((a, b) => pointOrder(a.loc, b.loc));
    for (final (int i, Unit unit) in units.indexed) {
      if (unit.hp <= 0) continue;
      done = true;

      // Movement (optional)
      List<(Point, int)> reachable = [];
      int shortest = maze.width * maze.height;
      for (Unit enemy in units.where((e) => e.type == enemies[unit.type]! && e.hp > 0)) {
        done = false;
        for (Point p in priority) {
          Point next = enemy.loc + p;
          if (unit.loc == next) {
            reachable.add((unit.loc, 0));
            break;
          }
          if (maze.atPoint(next) != '.' || unit.loc.manhattanDist(next) > shortest) {
            continue;
          }
          final (Point move, int length) = bfs(maze, priority, unit.loc, next);
          if (length > 0) {
            reachable.add((move, length));
            if (length < shortest) {
              shortest = length;
            }
          }
        }
      }
      reachable.sort((a, b) => a.$2 != b.$2 ? a.$2 - b.$2 : pointOrder(a.$1, b.$1));

      Unit next = unit;
      if (reachable.length > 0 && reachable.first.$2 > 0) {
        next = Unit(reachable.first.$1, unit.type, unit.hp);
      }
      units[i] = next;
      replace(unit.loc, '.');
      replace(next.loc, next.type);

      // Attacking
      List<Unit> attackable = units.where((e) => e.type == enemies[unit.type]! && e.hp > 0 && e.loc.manhattanDist(next.loc) == 1)
                                   .toList()
                                   ..sort(Unit.order);
      if (attackable.isNotEmpty) {
        Unit target = attackable.first;
        target.hp -= {'E': elfPower, 'G': 3}[unit.type]!;
        if (target.hp <= 0) {
          replace(target.loc, '.');
          if (target.type == 'E') {
            elfDeaths++;
          }
        }
      }
    }
    units.removeWhere((e) => e.hp <= 0);
    rounds++;
  }
  return (units.fold(0, (sum, u) => sum + u.hp) * (rounds - 1), elfDeaths);
}

void main() async {
  Grid<String> maze = Grid.string(await aoc.getInputString(), (e) => e);

  List<Unit> units = [];
  maze.every((x, y, e) {
    if ('EG'.contains(e)) {
      units.add(Unit(Point(x, y), e));
    }
  });
  print('Part 1: ${runSimulation(maze, units, 3).$1}');
  print('Part 2: ${runSimulation(maze, units, 14).$1}'); // Trial and error
}
