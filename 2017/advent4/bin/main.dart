import 'dart:io';

main() async {
  int valid1 = 0, valid2 = 0;
  RegExp bounds = new RegExp(r'(\b[^\s]+?\b).*?\b\1\b');
  await new File('advent4/input.txt').readAsLines()
  .then((List<String> file) => file.forEach((String line) {
    // part 1 
    if (!bounds.hasMatch(line)) valid1++;
    // part 2
    List<String> words = line.split(' ').map((e) => (e.split('')..sort()).join()).toList()..sort();
    bool valid = true;
    for (String word in words) {
      if (words.where((e) => word == e).length > 1) {
        valid = false;
        break;
      }
    }
    if (valid) valid2++;
  }));
  print('Part 1: $valid1');
  print('Part 2: $valid2');
}

