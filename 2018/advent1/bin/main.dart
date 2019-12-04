import 'dart:io';

void main() async {
  int freq = 0, first = null, repeat = null;
  Set<int> prev = new Set();
  await new File('input.txt').readAsLines()
  .then((List<String> file) {
    while (repeat == null) {
      file.forEach((String line) {
        if (prev.contains(freq) && repeat == null) {
          repeat = freq;
        }
        prev.add(freq);
        freq += int.tryParse(line);
      });
      if (first == null) first = freq;
    }

    print('Part 1: ${first}');
    print('Part 2: ${repeat}');
  });
}