import 'dart:io';
import '../../intcode/computer.dart';

class Cleaner {
  int dir, x, y;
  Cleaner(this.x, this.y, this.dir);
}
class Grid<T> {
  List<T> cells;
  int w, h;
  T at(int x, int y) => this.cells[y * w + x];
  void put(int x, int y, T e) => this.cells[y * w + x] = e;
  void add(T e) => this.cells.add(e);
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
List sum(Grid<String> grid) {
  Cleaner cleaner;
  int sum = 0;
  for (int y = 0; y < grid.h; y++) {
    for (int x = 0; x < grid.w; x++) {
      if (grid.at(x, y) == '^')
        cleaner = Cleaner(x, y, 0);
      if (grid.at(x, y) == '>')
        cleaner = Cleaner(x, y, 1);
      if (grid.at(x, y) == 'v')
        cleaner = Cleaner(x, y, 2);
      if (grid.at(x, y) == '<')
        cleaner = Cleaner(x, y, 3);
      if (x == 0 || y == 0 || x + 1 == grid.w || y + 1 == grid.h) continue;
      if (grid.at(x, y) == '#' && grid.at(x + 1, y) == '#' && grid.at(x - 1, y) == '#' && grid.at(x, y + 1) == '#' && grid.at(x, y + 1) == '#')
        sum += x * y;
    }
  }
  return [sum, cleaner];
}
Grid<String> parseOutput(List<int> output) {
  Grid<String> out = Grid.initiate(0, 0, '');
  int w, index = 0;
  for (int char in output) {
    if (char == 10) {
      w ??= index;
    } else {
      out.add(String.fromCharCode(char));
      index++;
    }
  }
  out.w = w; out.h = out.cells.length ~/ w;
  int left = out.w * out.h - out.cells.length;
  if (left < 0) {
    out.cells.addAll(List.filled(out.w + left, ' '));
    out.h++;
  }
  return out;
}
List pathfinding(Grid ascii, Cleaner cleaner) {
  bool done = false;
  List steps = [];
  while (!done) {
    switch (cleaner.dir) {
      case 0: // up
        if (cleaner.y > 0 && ascii.at(cleaner.x, cleaner.y - 1) == '#') {
          if (steps.last.runtimeType == int) steps.last++;
          else steps.add(1);
          cleaner.y--;
        } else {
          if (cleaner.x + 1 < ascii.w && ascii.at(cleaner.x + 1, cleaner.y) == "#") {
            steps.add('R');
            cleaner.dir = 1;
          } else if (cleaner.x > 0 && ascii.at(cleaner.x - 1, cleaner.y) == "#") {
            steps.add('L');
            cleaner.dir = 3;
          } else {
            done = true;
          }
        }
      break;
      case 1: // right
        if (cleaner.x + 1 < ascii.w && ascii.at(cleaner.x + 1, cleaner.y) == '#') {
          if (steps.last.runtimeType == int) steps.last++;
          else steps.add(1);
          cleaner.x++;
        } else {
          if (cleaner.y + 1 < ascii.h && ascii.at(cleaner.x, cleaner.y + 1) == "#") {
            steps.add('R');
            cleaner.dir = 2;
          } else if (cleaner.y > 0 && ascii.at(cleaner.x, cleaner.y - 1) == "#") {
            steps.add('L');
            cleaner.dir = 0;
          } else {
            done = true;
          }
        }
      break;
      case 2: // down
        if (cleaner.y + 1 < ascii.h && ascii.at(cleaner.x, cleaner.y + 1) == '#') {
          if (steps.last.runtimeType == int) steps.last++;
          else steps.add(1);
          cleaner.y++;
        } else {
          if (cleaner.x > 0 && ascii.at(cleaner.x - 1, cleaner.y) == "#") {
            steps.add('R');
            cleaner.dir = 3;
          } else if (cleaner.x + 1 < ascii.w && ascii.at(cleaner.x + 1, cleaner.y) == "#") {
            steps.add('L');
            cleaner.dir = 1;
          } else {
            done = true;
          }
        }
      break;
      case 3: // left
        if (cleaner.x > 0 && ascii.at(cleaner.x - 1, cleaner.y) == '#') {
          if (steps.last.runtimeType == int) steps.last++;
          else steps.add(1);
          cleaner.x--;
        } else {
          if (cleaner.y > 0 && ascii.at(cleaner.x, cleaner.y - 1) == "#") {
            steps.add('R');
            cleaner.dir = 0;
          } else if (cleaner.y + 1 < ascii.h && ascii.at(cleaner.x, cleaner.y + 1) == "#") {
            steps.add('L');
            cleaner.dir = 2;
          } else {
            done = true;
          }
        }
      break;
    }
  }
  return steps;
}

void main() {
  List<String> input = File('input.txt').readAsStringSync().split(',');
  List<int> output = [];
  Cleaner cleaner;
  IntcodeComputer(input).run(output: output);
  Grid<String> ascii = parseOutput(output);

  List things = sum(ascii);
  cleaner = things[1];
  print('Part 1: ${things[0]}');
  // follow path
  List steps = pathfinding(ascii, cleaner);
  String path = steps.join(',');
  Map<String, String> functions = {};
  int letter = 65; // A
  // find functions (only works for some inputs (mine!))
  RegExp formula = RegExp(r'((?:[RL],\d+,){2,5}).*?(?:\1)');
  while (path.indexOf('L') >= 0 || path.indexOf('R') >= 0) {
    Match m = formula.firstMatch(path);
    String match = m.group(1).substring(0, m.group(1).length - 1);
    functions[String.fromCharCode(letter++)] = match;
    path = path.replaceAll(match, '');
  }
  path = steps.join(',');
  // map functions to path
  functions.forEach((letter, func) => path = path.replaceAll(func, letter));
  // encode for intcode
  List<int> enter = [];
  enter..addAll(path.runes)..add(10);
  for (String char in ['A', 'B', 'C']) {
    enter..addAll(functions[char].runes)..add(10);
  }
  //video feed
  enter.addAll([110, 10]);
  input[0] = '2';
  print('Part 2: ${IntcodeComputer(input).run(input: enter, output: [])}');
}