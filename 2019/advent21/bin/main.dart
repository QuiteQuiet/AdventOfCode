import 'dart:io';
import '../../intcode/computer.dart';

void main() {
  List<String> input = File('input.txt').readAsStringSync().split(',');
  List<int> output = [];
  IntcodeComputer robot = IntcodeComputer(input);
  String program = '''
OR A J
AND B J
AND C J
NOT J J
AND D J
WALK
''';
  robot.run(input: program.runes.toList(), output: output);
  print(output.where((c) => c < 255).map((c) => String.fromCharCode(c)).toList().join());
  print('Part 1: ${output.last}');
  output.clear();
  program = program.replaceFirst('WALK', '''
OR H T
OR E T
AND T J
RUN''');
  robot..reset()..run(input: program.runes.toList(), output: output);
  print(output.where((c) => c < 255).map((c) => String.fromCharCode(c)).toList().join());
  print('Part 2: ${output.last}');
}
