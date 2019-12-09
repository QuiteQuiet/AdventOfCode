import 'dart:io';
import '../../intcode/computer.dart';

void main() {
  String input = File('input.txt').readAsStringSync();
  IntcodeComputer computer = IntcodeComputer(input);

  print('Part 1: ${(computer..alloc(2000)).run(input: [1], output: [])}');
  print('Part 2: ${(computer..alloc(2000)).run(input: [2], output: [])}');
}