import 'dart:io';
import '../../intcode/computer.dart';

void main() {
  Stopwatch time = Stopwatch()..start();
  String input = File('input.txt').readAsStringSync();
  IntcodeComputer computer = IntcodeComputer(input);

  print('Part 1: ${(computer..alloc(100)).run(input: [1], output: [])} ${time.elapsed}');
  print('Part 2: ${(computer..alloc(200)).run(input: [2], output: [])} ${time.elapsed}');
}