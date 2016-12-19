import 'package:priority_queue/priority_queue.dart';
class State {
  List<List<int>> f, s = new List();
  int m, e, g;
  State(this.f, this.e, this.m) {
    int val = 0;
    List<int> used = new List();
    for (int i = 0; i < this.f.length; i++) {
      val += f[i].length * i;
      for (int o in this.f[i]) {
        if (used.contains(o)) continue;
        int o2 = i;
        for (int j = i + 1; j < this.f.length; j++) {
          if (this.f[j].contains(-o)) {
            o2 = j;
          }
        }
        if (o > 0) {
          // microchip
          this.s.add([i, o2]);
        } else {
          // generator
          this.s.add([o2, i]);
        }
        used.addAll([o, -o]);
      }
    }
    this.g = val - this.m;
    this.s.sort((a, b) => a[0] == b[0] ? a[1] - b[1] : a[0] - b[0]);
  }
  int compareTo(State other) => this.g - other.g;
  String get hashmap => '${e}f $s';  
}
bool done(State n) {
  for (List<int> pair in n.s) {
    if (pair[0] != 3 || pair[1] != 3) return false;
  }
  return true;
}
bool correct(List<List<int>> floor) {
  for (int i = 0; i < floor.length; i++) {
    for (int j = 0; j < floor[i].length; j++) {
      if (floor[i][j] > 0 && floor[i].any((e) => e < 0) && !floor[i].contains(-floor[i][j])) {
        return false;
      }
    }
  }
  return true;
}
List<List> deepcopy(List<List> l) {
  List copy = new List.generate(l.length, (i) => new List.generate(l[i].length, (i) => i, growable: true));
  for (int i = 0; i < l.length; i++) {
    for (int j = 0; j < l[i].length; j++) {
      copy[i][j] = l[i][j];
    }
  }
  return copy;
}
State solve(List<List<int>> input) {
  Map<String, bool> seen = new Map();
  PriorityQueue<State> queue = new PriorityQueue();
  queue.add(new State(input, 0, 0));
  while (queue.length > 0) {
    State state = queue.removeMax();
    if (seen[state.hashmap]) {
      continue;
    }
    if (done(state)) {
      return state; // bail out
    }
    seen[state.hashmap] = true;
    // clone the list from the state
    List<List<int>> things = deepcopy(state.f);
    things.forEach((i) => i.sort());
    for (int dir in [1, -1]) {
      if (state.e == 0 && dir == -1) continue;
      if (state.e == 3 && dir == 1) continue;
      // everything on that floor
      List<int> options = things[state.e];
      for (int i = 0; i < options.length; i++) {
        int t1 = options[i];
        // try moving two things at once first
        for (int j = i + 1; j < options.length; j++) {
          int t2 = options[j];
          things[state.e + dir].addAll([t1, t2]);
          things[state.e + dir].sort();
          things[state.e].remove(t1);
          things[state.e].remove(t2);
          if (correct(things)) {
            List deep = deepcopy(things);
            State newState = new State(deep, state.e + dir, state.m + 1);
            if (!seen[newState.hashmap]) {
              queue.add(newState);
            }
          }
          things[state.e + dir].remove(t1);
          things[state.e + dir].remove(t2);
          things[state.e].addAll([t1, t2]);
          things[state.e].sort();
        }
        // try with just one item too
        things[state.e + dir].add(t1);
        things[state.e + dir].sort();
        things[state.e].remove(t1);
        if (correct(things)) {
          List deep = deepcopy(things);
          State newState = new State(deep, state.e + dir, state.m + 1);
          if (!seen[newState.hashmap]) {
            queue.add(newState);
          }
        }
        things[state.e + dir].remove(t1);
        things[state.e].add(t1);
        things[state.e].sort();
      }
    }
  }
  return null;
}
void main() {
  // prom 1, cob 2, cur 3, ruth 4, plut 5, eler 6, dilth 7
  // generators are negative of ^
  List<List<int>> input = [
    [1, -1],
    [-2, -3, -4, -5],
    [2, 3, 4, 5],
    []
  ];
  Stopwatch time = new Stopwatch()..start();
  print('Part 1: ${solve(input).m} in ${time.elapsed}');
  input[0].addAll([6, -6, 7, -7]);
  time.reset();
  print('Part 2: ${solve(input).m} in ${time.elapsed}');
}