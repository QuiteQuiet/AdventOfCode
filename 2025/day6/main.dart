import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

int solve(List<List<String>> l, String op) {
  List<int> numbers = l.map((e) => e.join('').trim().toInt()).toList();
  return numbers.reduce((a, b) => op == '+' ? a + b : a * b);
}

void main() async {
  List<String> lines = await aoc.getInput();
  List<String> ops = lines.removeLast().trim().split(RegExp(r' +'));

  int t1 = 0, t2 = 0, index = 0;
  for (String op in ops) {
    int start = index, stop = index;
    while (start == stop) {
      bool empty = true;
      for (int i = 0; i < lines.length; i++) {
        if (index < lines[i].length && lines[i][index] != ' ') {
          empty = false;
          break;
        }
      }
      if (empty) {
        stop = index;
      }
      index++;
    }

    List<List<String>> numbers = [];
    for (int i = 0; i < lines.length; i++) {
      numbers.add([]);
      for (int ii = start; ii < stop; ii++) {
        numbers.last.add(lines[i][ii]);
      }
    }
    t1 += solve(numbers, op);

    numbers.clear();
    for (int i = start; i < stop; i++) {
      numbers.add([]);
      for (int ii = 0; ii < lines.length; ii++) {
        numbers.last.add(lines[ii][i]);
      }
    }
    t2 += solve(numbers, op);
  }
  print('Part 1: $t1');
  print('Part 2: $t2');
}
