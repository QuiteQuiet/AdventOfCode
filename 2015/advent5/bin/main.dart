import 'dart:io';

main() async {
  int nice1 = 0, nice2 = 0;
  RegExp vowels = new RegExp(r'[aeiou]'),
        doubles = new RegExp(r'(.)\1'),
        banned = new RegExp(r'ab|cd|pq|xy'),
        pairs = new RegExp(r'(..).*?\1'),
        repeat = new RegExp(r'(.).\1');
  new File('input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      if (vowels.allMatches(line).length >= 3 && doubles.hasMatch(line) && !banned.hasMatch(line)) nice1++;
      if (pairs.hasMatch(line) && repeat.hasMatch(line)) nice2++;
    });
    print('Part 1: $nice1');
    print('Part 2: $nice2');
  });
}