import 'dart:io';

main() async {
  int total1 = 0, total2 = 0;
  await new File('input.txt').readAsLines()
  .then((List<String> list) {
    list.forEach((String l) {
      total1 += l.length - l.substring(1, l.length - 1).replaceAll(new RegExp(r'\\x[0-9a-f]{2}|\\"|\\\\'), '#').length;
      total2 += '"${l.replaceAll(new RegExp(r'[\\"]'), r'##')}"'.length - l.length;
    });
    print('Part 1: $total1');
    print('Part 2: $total2');
  });
}