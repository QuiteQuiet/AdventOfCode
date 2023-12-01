import 'dart:io';
import 'dart:collection';

String process(String input) {
  ListQueue<String> stack = ListQueue();
  input.split('').forEach((c) {
    if (stack.isEmpty) {
      stack.add(c);
    } else if ((c.toLowerCase() == c && c.toUpperCase() == stack.last) ||
               (c.toUpperCase() == c && c.toLowerCase() == stack.last)) {
      stack.removeLast();
    } else {
      stack.add(c);
    }
  });
  return stack.toList().join('');
}

void main() {
  String input = File('input.txt').readAsStringSync();
  String output = process(input);
  print('Part 1: ${output.length}');

  String? shortest;
  'abcdefghijklmnopqrstuvwxyz'.split('').forEach((c) {
    String test = process(output.replaceAll(RegExp(c, caseSensitive: false), ''));
    shortest ??= test;
    if (test.length < (shortest?.length)!) {
      shortest = test;
    }
  });
  print('Part 2: ${shortest?.length}');
}