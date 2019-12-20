import 'dart:io';
import 'dart:collection';

class Point {
  int x, y, steps, level;
  String side;
  Point(this.x, this.y, [this.steps = 0, this.level = 0, this.side = 'out']);
  bool operator== (covariant Point o) => x == o.x && y == o.y && level == o.level;
  bool matches(covariant Point o) => x == o.x && y == o.y;
  int get hashCode => '$x,$y $level'.hashCode;
  String toString() => '$x,$y $level';
}

class Grid<T> {
  List<T> cells;
  int w, h;
  T at(int x, int y) => this.cells[y * w + x];
  void put(int x, int y, T e) => this.cells[y * w + x] = e;
  void add(T e) => this.cells.add(e);
  Grid(this.w, this.h);
  Grid.initiate(this.w, this.h, T e) { this.cells = List.filled(this.h * this.w, e, growable: true); }
  String toString() {
    List<String> s = [];
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++)
        s.add(at(j, i).toString());
      s.add('\n');
    }
    return s.join('');
  }
}

int removeDeadEnds(Grid maze) {
  int tilesBlocked = 0;
  for (int y = 0; y < maze.h; y++) {
    for (int x = 0; x < maze.w; x++) {
      if (maze.at(x, y) == '.') {
        int walls = 0;
        if (maze.at(x + 1, y) == '#') walls++;
        if (maze.at(x - 1, y) == '#') walls++;
        if (maze.at(x, y + 1) == '#') walls++;
        if (maze.at(x, y - 1) == '#') walls++;
        if (walls == 3) {
          maze.put(x, y, '#');
          tilesBlocked++;
        }
      }
    }
  }
  return tilesBlocked;
}

int bfs(Grid maze, Map<String, List<Point>> portals, {bool recursive = false}) {
  RegExp letter = RegExp(r'[A-Z]');
  Set<Point> visited = {};
  Point dest = portals['ZZ'].first;
  Queue queue = Queue()..add(portals['AA'].first);
  while (queue.isNotEmpty) {
    Point cur = queue.removeFirst();
    if (visited.contains(cur)) continue;
    // done
    if (cur == dest) return cur.steps;
    // cuts time in half
    if (cur.level > portals.keys.length) continue;
    // avoid bug I cba fixing
    if (letter.hasMatch(maze.at(cur.x, cur.y))) continue;
    visited.add(cur);
    if (maze.at(cur.x - 1, cur.y) != '#') {
      Point toVisit = Point(cur.x - 1, cur.y, cur.steps + 1, cur.level);
      if (letter.hasMatch(maze.at(cur.x - 1, cur.y))) {
        String portal = '${maze.at(cur.x - 2, cur.y)}${maze.at(cur.x - 1, cur.y)}';
        if (portals[portal].length > 1) {
          Point dest, src;
          if (cur.matches(portals[portal].first)) {
            dest = portals[portal].last;
            src = portals[portal].first;
          } else {
            dest = portals[portal].first;
            src = portals[portal].last;
          }
          toVisit = Point(dest.x, dest.y, cur.steps + 1, cur.level);
          if (recursive) {
            toVisit.level += src.side == 'in' ? 1 : -1;
          }
        }
      }
      if (!visited.contains(toVisit) && toVisit.level >= 0) {
        queue.add(toVisit);
      }
    }
    if (maze.at(cur.x + 1, cur.y) != '#') {
      Point toVisit = Point(cur.x + 1, cur.y, cur.steps + 1, cur.level);
      if (letter.hasMatch(maze.at(cur.x + 1, cur.y))) {
        String portal = '${maze.at(cur.x + 1, cur.y)}${maze.at(cur.x + 2, cur.y)}';
        if (portals[portal].length > 1) {
          Point dest, src;
          if (cur.matches(portals[portal].first)) {
            dest = portals[portal].last;
            src = portals[portal].first;
          } else {
            dest = portals[portal].first;
            src = portals[portal].last;
          }
          toVisit = Point(dest.x, dest.y, cur.steps + 1, cur.level);
          if (recursive) {
            toVisit.level += src.side == 'in' ? 1 : -1;
          }
        }
      }
      if (!visited.contains(toVisit) && toVisit.level >= 0) {
        queue.add(toVisit);
      }
    }
    if (maze.at(cur.x, cur.y - 1) != '#') {
      Point toVisit = Point(cur.x, cur.y - 1, cur.steps + 1, cur.level);
      if (letter.hasMatch(maze.at(cur.x, cur.y - 1))) {
        String portal = '${maze.at(cur.x, cur.y - 2)}${maze.at(cur.x, cur.y - 1)}';
        if (portals[portal].length > 1) {
          Point dest, src;
          if (cur.matches(portals[portal].first)) {
            dest = portals[portal].last;
            src = portals[portal].first;
          } else {
            dest = portals[portal].first;
            src = portals[portal].last;
          }
          toVisit = Point(dest.x, dest.y, cur.steps + 1, cur.level);
          if (recursive) {
            toVisit.level += src.side == 'in' ? 1 : -1;
          }
        }
      }
      if (!visited.contains(toVisit) && toVisit.level >= 0) {
        queue.add(toVisit);
      }
    }
    if (maze.at(cur.x, cur.y + 1) != '#') {
      Point toVisit = Point(cur.x, cur.y + 1, cur.steps + 1, cur.level);
      if (letter.hasMatch(maze.at(cur.x, cur.y + 1))) {
        String portal = '${maze.at(cur.x, cur.y + 1)}${maze.at(cur.x, cur.y + 2)}';
        if (portals[portal].length > 1) {
          Point dest, src;
          if (cur.matches(portals[portal].first)) {
            dest = portals[portal].last;
            src = portals[portal].first;
          } else {
            dest = portals[portal].first;
            src = portals[portal].last;
          }
          toVisit = Point(dest.x, dest.y, cur.steps + 1, cur.level);
          if (recursive) {
            toVisit.level += src.side == 'in' ? 1 : -1;
          }
        }
      }
      if (!visited.contains(toVisit) && toVisit.level >= 0) {
        queue.add(toVisit);
      }
    }
  }
  return null;
}

void main() {
  Stopwatch time = Stopwatch()..start();
  List<String> input = File('input.txt').readAsLinesSync();
  Grid<String> maze = Grid.initiate(input[2].length, input.length, ' ');
  Map<String, List<Point>> portals = {};
  RegExp letter = RegExp(r'[A-Z]');
  for (int y = 0; y < input.length; y++) {
    for (int x = 0, w = input[y].length; x < w; x++) {
      maze.put(x, y, input[y][x]);
      if (letter.hasMatch(input[y][x])) {
        if (x + 1 < maze.w && input[y][x + 1] == '.') {
          String side = x - 1 == 0 ? 'out' : 'in';
          (portals['${input[y][x - 1]}${input[y][x]}'] ??= []).add(Point(x + 1, y, 0, 0, side));
        }
        if (x > 0 && input[y][x - 1] == '.') {
          String side = x + 2 == maze.w ? 'out' : 'in';
          (portals['${input[y][x]}${input[y][x + 1]}'] ??= []).add(Point(x - 1, y, 0, 0, side));
        }
        if (y + 1 < maze.h && input[y + 1][x] == '.') {
          String side = y - 1 == 0 ? 'out' : 'in';
          (portals['${input[y - 1][x]}${input[y][x]}'] ??= []).add(Point(x, y + 1, 0, 0, side));
        }
        if (y > 0 && input[y - 1][x] == '.') {
          String side = y + 2 == maze.h ? 'out' : 'in';
          (portals['${input[y][x]}${input[y + 1][x]}'] ??= []).add(Point(x, y - 1, 0, 0, side));
        }
      }
    }
  }
  // speeds up things massively
  while (removeDeadEnds(maze) > 0);
  print('Part 1: ${bfs(maze, portals)} ${time.elapsed}');
  print('Part 2: ${bfs(maze, portals, recursive: true)} ${time.elapsed}');
}