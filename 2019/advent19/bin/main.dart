import 'dart:io';
import '../../intcode/computer.dart';

void main() {
  List<String> input = File('input.txt').readAsStringSync().split(',');
  IntcodeComputer beam = IntcodeComputer(input);
  int result = 0;
  for (int x = 0; x < 50; x++) {
    for (int y = 0; y < 50; y++) {
      result += (beam..reset()).run(input: [x, y], output: []);
    }
  }
  print('Part 1: $result');

  int sqx, sqy, xstart = 0;
  for (int y = 0; y < 1000 && sqx == null && sqy == null; y++) {
    int prev;
    for (int x = xstart; x < xstart + 300; x++) {
      int test1 = (beam..reset()).run(input: [x, y], output: []);
      int test2 = (beam..reset()).run(input: [x, y + 99], output: []);
      int test3 = (beam..reset()).run(input: [x + 99, y], output: []);
      int test4 = (beam..reset()).run(input: [x + 99, y + 99], output: []);
      if (prev == 0 && test1 == 1) {
        xstart = x + 1;
      }
      prev = test1;
      if (test1 == 1 && test3 == 0) break;
      if (test1 + test2 + test3 + test4 == 4) {
        sqx = x;
        sqy = y;
        break;
      }
    }
  }
  print('Part 2: ${sqx * 10000 + sqy}');
}
