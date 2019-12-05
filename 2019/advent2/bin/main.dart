import '../../advent5/bin/main.dart';

void main() {
  String input = '1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,19,9,23,1,23,6,27,1,9,27,31,1,31,10,35,2,13,35,39,1,39,10,43,1,43,9,47,1,47,13,51,1,51,13,55,2,55,6,59,1,59,5,63,2,10,63,67,1,67,9,71,1,71,13,75,1,6,75,79,1,10,79,83,2,9,83,87,1,87,5,91,2,91,9,95,1,6,95,99,1,99,5,103,2,103,10,107,1,107,6,111,2,9,111,115,2,9,115,119,2,13,119,123,1,123,9,127,1,5,127,131,1,131,2,135,1,135,6,0,99,2,0,14,0';
  int goal = 19690720, noun, verb;
  IntcodeComputer computer = IntcodeComputer(input);

  // part 2
  for (int n = 0; n < 100; n++) {
    for (int v = 0; v < 100; v++) {
      int result = computer.run(noun: n, verb: v);
      if (result == goal) {
        noun = n;
        verb = v;
      }
    }
  }

  print('Part 1: ${computer.run(noun: 12, verb: 2)}');
  print('Part 2: ${100 * noun + verb}');
}