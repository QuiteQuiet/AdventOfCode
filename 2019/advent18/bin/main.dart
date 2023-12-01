import 'dart:io';
import 'dart:collection';
import 'package:trotter/trotter.dart';
import 'package:collection/collection.dart';

class Point {
  int x, y;
  Point(this.x, this.y);
  bool operator== (covariant Point o) => x == o.x && y == o.y;
  int get hashCode => '$x,$y'.hashCode;
  String toString() => '$x,$y';
}

class Grid<T> {
  late List<T> cells;
  int w, h;
  T at(int x, int y) => this.cells[y * w + x];
  void put(int x, int y, T e) => this.cells[y * w + x] = e;
  void add(T e) => this.cells.add(e);
  Grid(this.w, this.h);
  Grid.initiate(this.w, this.h, T e) { this.cells = List.filled(this.h * this.w, e, growable: true); }
  int count(T e) => cells.where((el) => el == e).length;
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

List bfs(Point start, Point end, Grid<String> maze) {
  Queue steps = Queue()..add([start, [0]]);
  Set<Point> visited = {};
  while (steps.isNotEmpty) {
    List things = steps.removeFirst();
    Point cur = things[0];
    List blocks = List.from(things[1]);
    if (maze.at(cur.x, cur.y) != ".")
      blocks.add(maze.at(cur.x, cur.y));
    blocks[0]++;
    if (cur == end) {
      return blocks;
    }
    visited.add(cur);
    Point up = Point(cur.x - 1, cur.y), down = Point(cur.x + 1, cur.y),
          left = Point(cur.x, cur.y - 1), right = Point(cur.x, cur.y + 1);
    if (maze.at(cur.x - 1, cur.y) != '#' && !visited.contains(up)) steps.add([up, blocks]);
    if (maze.at(cur.x + 1, cur.y) != '#' && !visited.contains(down)) steps.add([down, blocks]);
    if (maze.at(cur.x, cur.y - 1) != '#' && !visited.contains(left)) steps.add([left, blocks]);
    if (maze.at(cur.x, cur.y + 1) != '#' && !visited.contains(right)) steps.add([right, blocks]);
  }
  throw Exception('Should never happen');
}

int getShortestPath(List<String> input, {bool ignoreDoors = false}) {
  Grid<String> maze = Grid.initiate(input[0].length, input.length, ' ');
  RegExp lowercase = RegExp(r'[a-z]');
  Map<String, Point> pointsOfInterest = {};
  for (int y = 0; y < input.length; y++) {
    for (int x = 0; x < input[y].length; x++) {
      maze.put(x, y, input[y][x]);
      if (lowercase.hasMatch(input[y][x]) || input[y][x] == '@') {
        pointsOfInterest[input[y][x]] = Point(x, y);
      }
    }
  }
  Combinations comb = Combinations(2, pointsOfInterest.keys.toList());
  Map<String, int> edges = {};
  for (var pair in comb()) {
    List edge = bfs(pointsOfInterest[pair[0]]!, pointsOfInterest[pair[1]]!, maze);
    int weight = edge.removeAt(0);
    if (edge.last == '@') edge = edge.reversed.toList();
    edges[edge.join()] = weight - 1;
  }
  // edges is now a graph, traverse it
  int keysToFind = pointsOfInterest.keys.length;
  Set<String> explored = {};
  PriorityQueue search = PriorityQueue<List>((l1, l2) => l1.last - l2.last);
  List? shortest;
  search.add(['@', ['@'], 0]);
  while (search.isNotEmpty) {
    List things = search.removeFirst();
    String curPos = things[0];
    String repr = '$curPos: ${(things[1]..sort()).join()}';
    if (explored.contains(repr)) continue; // we already saw this earlier
    if (things[1].length == keysToFind) {
      shortest ??= things;
    }
    explored.add(repr);
    for (String edge in edges.keys.where((el) => el[0] == curPos || el[el.length - 1] == curPos)) {
      bool canReachEnd = true;
      String workingEdge = edge;
      List<String> keys = List.from(things[1]);
      if (workingEdge[0] != curPos) workingEdge = edge.split('').reversed.join();
      String dest = workingEdge[workingEdge.length - 1];
      canReachEnd = !keys.contains(dest);
      for (int i = 1; i < edge.length && canReachEnd; i++) {
        if (lowercase.hasMatch(workingEdge[i]) && !keys.contains(workingEdge[i])) {
          keys.add(workingEdge[i]);
        } else if (workingEdge[i] == '@') {
        } else if (!keys.contains(workingEdge[i].toLowerCase())) {
          canReachEnd = ignoreDoors;
        }
      }
      if (canReachEnd) {
        search.add([dest, keys, things[2] + edges[edge]]);
      }
    }
  }
  return shortest?[2];
}


void main() {
  Stopwatch time = Stopwatch()..start();
  List<String> input = File('input.txt').readAsLinesSync();
  print('Part 1: ${getShortestPath(input)} ${time.elapsed}');

  // fuck it, this works
  input[39] = (input[39].split('')..setRange(39, 42, ['@', '#', '@'])).join();
  input[40] = (input[40].split('')..fillRange(39, 42, '#')).join();
  input[41] = (input[41].split('')..setRange(39, 42, ['@', '#', '@'])).join();
  List<String> maze1 = [], maze2 = [], maze3 = [], maze4 = [];
  for (int i = 0, h = input.length ~/ 2 + 1; i < h; i++) {
      maze1.add(input[i].substring(0, input.length ~/ 2 + 1));
  }
  for (int i = input.length ~/ 2; i < input.length; i++) {
      maze2.add(input[i].substring(0, input.length ~/ 2 + 1));
  }
  for (int i = 0, h = input.length ~/ 2 + 1; i < h; i++) {
      maze3.add(input[i].substring(input.length ~/ 2, input.length));
  }
  for (int i = input.length ~/ 2; i < input.length; i++) {
      maze4.add(input[i].substring(input.length ~/ 2, input.length));
  }
  int shortestPathMult = getShortestPath(maze1, ignoreDoors: true) +
                         getShortestPath(maze2, ignoreDoors: true) +
                         getShortestPath(maze3, ignoreDoors: true) +
                         getShortestPath(maze4, ignoreDoors: true);
  print('Part 2: $shortestPathMult ${time.elapsed}');
}