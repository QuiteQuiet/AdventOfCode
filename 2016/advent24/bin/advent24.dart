import 'dart:io';
import 'dart:collection';
class State {
  int x, y;
  List<State> path = new List.empty(growable: true);
  Map<String, List<State>> d = new Map();
  String c;
  State(this. x, this.y, this.path, this.c);
  bool operator==(covariant State o) => this.x == o.x && this.y == o.y;
  String get hash => '$x|$y';
}
class Grid<T> {
  late List _l;
  int x, y;
  Grid(this.x, this.y) { this._l = new List.generate(this.x, (i) => new List.filled(this.y, Object())); }
  T operator[](List<int> xy) => this._l[xy[0]][xy[1]];
  void operator[]=(List<int> xy, T e) { this._l[xy[0]][xy[1]] = e; }
  Iterable<T> get All sync* {
    for (int i = 0; i < this.x; i++) {
      for (int j = 0; j < this.y; j++) {
        yield this[[i, j]];
      }
    }
  }
  String toString() {
    String buf = '';
    for (int i = 0; i < this.x; i++) {
      for (int j = 0; j < this.y; j++) {
        buf += this[[i, j]].toString();
      }
      buf += '\n';
    }
    return buf;
  }
}
/// Returns a new lazy [Iterable] with every permutation of the list
Iterable<List> permutations(List l) sync* {
  if (l.length == 2) {
    yield l;
    yield [l[1], l[0]];
  } else {
    for (int i = 0; i < l.length; i++) {
      for (List perm in permutations(l.sublist(0, i)..addAll(l.sublist(i + 1)))) {
        yield [l[i]]..addAll(perm);
      }
    }
  }
}
late Grid<String> maze;
Map<String, bool> visited = new Map();
List<State> moves(State now) {
  List<State> move = new List.empty(growable: true);
  if (now.x > 0) {
    State next = new State(now.x - 1, now.y, [now]..addAll(now.path), maze[[now.x - 1, now.y]]);
    if (next.c != '#') {
      move.add(next);
    }
  }
  if (now.x < maze.x) {
    State next = new State(now.x + 1, now.y, [now]..addAll(now.path), maze[[now.x + 1, now.y]]);
    if (next.c != '#') {
      move.add(next);
    }
  }
  if (now.y > 0) {
    State next = new State(now.x, now.y - 1, [now]..addAll(now.path), maze[[now.x, now.y - 1]]);
    if (next.c != '#') {
      move.add(next);
    }
  }
  if (now.y < maze.y) {
    State next = new State(now.x, now.y + 1, [now]..addAll(now.path), maze[[now.x, now.y + 1]]);
    if (next.c != '#') {
      move.add(next);
    }
  }
  return move;
}
List<State>? bfs(State start, State end) {
  visited.clear();
  ListQueue<State> queue = new ListQueue()..add(start);
  while (queue.length > 0) {
    State next = queue.removeFirst();
    if (visited[next.hash] != null) continue;
    visited[next.hash] = true;
    queue.addAll(moves(next));
    if (queue.contains(end))
      return queue.firstWhere((e) => e == end).path.reversed.toList();
  }
  return null;
}
main() async {
  Map<String, State> nodes = new Map();
  await new File('input.txt').readAsLines()
  .then((List<String> file) {
    maze = new Grid(file.length, file[0].length);
    for (int i = 0; i < file.length; i++) {
      for (int j = 0; j < file[i].length; j++) {
        maze[[i, j]] = file[i][j];
        if (file[i][j] != '#' && file[i][j] != '.') {
          nodes[file[i][j]] = new State(i, j, [], file[i][j]);
        }
      }
    }
  });
  //nodes.sort((a, b) => int.parse(a.c) - int.parse(b.c));
  for (State n in nodes.values) {
    for (State n2 in nodes.values) {
      if (n == n2 || n.d.containsKey(n2.c)) continue;
      n.d[n2.c] = bfs(n, n2)!;
      n2.d[n.c] = n.d[n2.c]!.reversed.toList();
    }
  }
  int shortest = 0xFFFFFFFFFFF, shortest2 = 0xFFFFFFFFFFF, distance, distance2;
  for (List p in permutations('1234567'.split(''))) {
    String cur = '0';
    distance = 0;
    for (String now in p) {
      distance += nodes[cur]!.d[now]!.length;
      cur = now;
    }
    distance2 = distance + nodes[cur]!.d['0']!.length;
    if (distance < shortest) {
      shortest = distance;
    }
    if (distance2 < shortest2) {
      shortest2 = distance2;
    }
  }
  print('Part 1: $shortest');
  print('Part 2: $shortest2');
}