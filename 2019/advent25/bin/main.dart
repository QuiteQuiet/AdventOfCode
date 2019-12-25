import 'dart:io';
import '../../intcode/computer.dart';

void main() {
  List<String> input = File('input.txt').readAsStringSync().split(',');
  IntcodeComputer robot = IntcodeComputer(input);
  // done manually
  String enter = '''
north
west
west
take spool of cat6
east
east
south
east
north
take sand
west
west
south
west
take fuel cell
east
north
east
north
take jam
south
west
north
west
south
''';
  List<int> exit = [];
  robot.run(input: enter.runes.toList(), output: exit);
  String output = String.fromCharCodes(exit);
  print(output);
  print('Part 1: ${RegExp(r'\d+').allMatches(output).last.group(0)}');
}