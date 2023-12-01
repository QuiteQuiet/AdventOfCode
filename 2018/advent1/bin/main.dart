import 'dart:io';

import '../../../lib/string.dart';

void main() async {
  int freq = 0;
  int? first = null, repeat = null;
  Set<int> prev = new Set();
  await new File('input.txt').readAsLines()
  .then((List<String> file) {
    while (repeat == null) {
      file.forEach((String line) {
        if (prev.contains(freq) && repeat == null) {
          repeat = freq;
        }
        prev.add(freq);
        freq += line.toInt();
      });
      first ??= freq;
    }

    print('Part 1: ${first}');
    print('Part 2: ${repeat}');
  });
}