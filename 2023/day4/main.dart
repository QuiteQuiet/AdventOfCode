import 'dart:io';

  // List<String> lines = await File('input.txt').readAsLines();
  // int points = 0, cards = 0;
  // List<int> stack = List.filled(lines.length, 1);
  // for (final (int index, String line) in lines.indexed) {
  //   List<String> numbers = RegExp(r'\d+').allMatches(line.split(':')[1]).map((e) => e.group(0)!).toList();
  //   int matches = numbers.length - Set.from(numbers).length;
  //   int cardCount = stack[index];
  //   for (int i = 0; i < matches; i++) {
  //       stack[index + 1 + i] += cardCount;
  //   }
  //   cards += cardCount;
  //   points += matches > 0 ? 1 << matches - 1 : 0;
  // }
  // print('Part 1: $points');
  // print('Part 2: $cards');

void main() async {
  List<String> lines = await File('input.txt').readAsLines();
  int points = 0, cards = 0;
  List<int> stack = List.filled(lines.length, 1, growable: true);
  for (final (int index, String line) in lines.indexed) {
    List<String> everything = line.split(':')[1].split(RegExp(r' +'));
    int divider = everything.indexOf('|');
    Set<String> numbers = Set.from(everything.sublist(0, divider))..remove('');
    Set<String> winningNumbers = Set.from(everything.sublist(divider));

    int cardCount = stack[index];
    int matches = numbers.intersection(winningNumbers).length;
    for (int i = 0; i < matches; i++) {
        stack[index + 1 + i] += cardCount;
    }
    cards += cardCount;
    points += matches > 0 ? 1 << matches - 1 : 0;
  }
  print('Part 1: $points');
  print('Part 2: $cards');
}