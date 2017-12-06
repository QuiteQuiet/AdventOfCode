import 'dart:io';
import 'dart:math';

main() async {
  int seen = 0;
  List<int> state = new List<int>();
  Map<String, int> visited = new Map<String, int>();
  await new File('advent6/input.txt').readAsLines()
  .then((List<String> file) =>
    state = file[0].split('\t').map(int.parse).toList()
  );
  while (visited[state.toString()] == null) {
    visited[state.toString()] = seen++;
    int consume = state.reduce(max), index = state.indexOf(consume);
    state[index] = 0;
    while (consume > 0) {
      index = (index + 1) % state.length;
      state[index]++;
      consume--;
    }
  }
  print('Part 1: $seen');
  print('Part 2: ${seen - visited[state.toString()]}');
}