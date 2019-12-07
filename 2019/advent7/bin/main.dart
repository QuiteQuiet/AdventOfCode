import 'package:trotter/trotter.dart';
import '../../intcode/computer.dart';

void main() {
  String input = '3,8,1001,8,10,8,105,1,0,0,21,38,55,64,81,106,187,268,349,430,99999,3,9,101,2,9,9,1002,9,2,9,101,5,9,9,4,9,99,3,9,102,2,9,9,101,3,9,9,1002,9,4,9,4,9,99,3,9,102,2,9,9,4,9,99,3,9,1002,9,5,9,1001,9,4,9,102,4,9,9,4,9,99,3,9,102,2,9,9,1001,9,5,9,102,3,9,9,1001,9,4,9,102,5,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,99';
  IntcodeComputer computer = IntcodeComputer(input);

  Permutations thrusters = Permutations(5, [0, 1, 2, 3, 4]);

  List<int>  outputA = List(), outputB = List(), outputC = List(), outputD = List(), outputE = List();
  for (List setting in thrusters()) {
    computer..run(input: [setting[0], 0], output: outputA)
            ..run(input: [setting[1], outputA.last], output: outputB)
            ..run(input: [setting[2], outputB.last], output: outputC)
            ..run(input: [setting[3], outputC.last], output: outputD)
            ..run(input: [setting[4], outputD.last], output: outputE);
  }
  print('Part 1: ${(outputE..sort()).last}');

  Permutations feedback = Permutations(5, [5, 6, 7, 8, 9]);
  List<int> signals = List<int>();
  for (List setting in feedback()) {
    outputA.clear(); outputB.clear(); outputC.clear(); outputD.clear(); outputE.clear();
    // prime interpreters
    IntcodeComputer
     A = IntcodeComputer(input)..run(input: [setting[0]], output: outputA),
     B = IntcodeComputer(input)..run(input: [setting[1]], output: outputB),
     C = IntcodeComputer(input)..run(input: [setting[2]], output: outputC),
     D = IntcodeComputer(input)..run(input: [setting[3]], output: outputD),
     E = IntcodeComputer(input)..run(input: [setting[4]], output: outputE);

    outputE.add(0);
    while (!A.done && !B.done && !C.done && !D.done && !E.done) {
      A.run(input: outputE, output: outputA);
      B.run(input: outputA, output: outputB);
      C.run(input: outputB, output: outputC);
      D.run(input: outputC, output: outputD);
      E.run(input: outputD, output: outputE);
    }
    signals.add(outputE.first);
  }
  print('Part 2: ${(signals..sort()).last}');
}