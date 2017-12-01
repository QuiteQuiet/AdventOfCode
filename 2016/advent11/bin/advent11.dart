import 'package:priority_queue/priority_queue.dart';
class State {
  List<List<int>> floors, id = new List();
  int moves, elevator, grade;
  State(this.floors, this.elevator, this.moves) {
    int val = 0;
    List<int> used = new List();
    for (int i = 0; i < this.floors.length; i++) {
      val += floors[i].length * i;
      for (int obj in this.floors[i]) {
        if (used.contains(obj)) continue;
        int obj2 = i;
        for (int j = i + 1; j < this.floors.length; j++) {
          if (this.floors[j].contains(-obj)) {
            obj2 = j;
          }
        }
        if (obj > 0) {
          // microchip
          this.id.add([i, obj2]);
        } else {
          // generator
          this.id.add([obj2, i]);
        }
        used.addAll([obj, -obj]);
      }
    }
    this.grade = val - this.moves;
    this.id.sort((a, b) => a[0] == b[0] ? a[1] - b[1] : a[0] - b[0]);
  }
  int compareTo(State other) => this.grade - other.grade;
  String get hashmap => '${elevator}f $id';  
}
bool done(State n) {
  for (List<int> pair in n.id) {
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
    List<List<int>> things = deepcopy(state.floors);
    things.forEach((i) => i.sort());
    for (int dir in [1, -1]) {
      if (state.elevator == 0 && dir == -1) continue;
      if (state.elevator == 3 && dir == 1) continue;
      // everything on that floor
      List<int> options = things[state.elevator];
      for (int i = 0; i < options.length; i++) {
        int t1 = options[i];
        // try moving two things at once first
        for (int j = i + 1; j < options.length; j++) {
          int t2 = options[j];
          things[state.elevator + dir]..addAll([t1, t2])..sort();
          things[state.elevator]..remove(t1)..remove(t2);
          if (correct(things)) {
            List deep = deepcopy(things);
            State newState = new State(deep, state.elevator + dir, state.moves + 1);
            if (!seen[newState.hashmap]) {
              queue.add(newState);
            }
          }
          things[state.elevator + dir]..remove(t1)..remove(t2);
          things[state.elevator]..addAll([t1, t2])..sort();
        }
        // try with just one item too
        things[state.elevator + dir]..add(t1)..sort();
        things[state.elevator].remove(t1);
        if (correct(things)) {
          List deep = deepcopy(things);
          State newState = new State(deep, state.elevator + dir, state.moves + 1);
          if (!seen[newState.hashmap]) {
            queue.add(newState);
          }
        }
        things[state.elevator + dir].remove(t1);
        things[state.elevator]..add(t1)..sort();
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
  print('Part 1: ${solve(input).moves} in ${time.elapsed}');
  input[0].addAll([6, -6, 7, -7]);
  time.reset();
  print('Part 2: ${solve(input).moves} in ${time.elapsed}');
}