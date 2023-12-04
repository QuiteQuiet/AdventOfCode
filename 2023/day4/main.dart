import 'dart:io';

void main() async {
  List<String> lines = await File('input.txt').readAsLines();
  int points = 0, cards = 0;
  List<int> stack = List.filled(lines.length, 1, growable: true);
  for (String line in lines) {
    List<String> everything = line.split(':')[1].split(RegExp(r' +'));
    int divider = everything.indexOf('|');
    Set<String> numbers = Set.from(everything.sublist(0, divider))..remove('');
    Set<String> winningNumbers = Set.from(everything.sublist(divider));

    int cardCount = stack.removeAt(0);
    int matches = numbers.intersection(winningNumbers).length;
    for (int i = 0; i < matches; i++) {
        stack[i] += cardCount;
    }
    cards += cardCount;
    points += matches > 0 ? 1 << matches - 1 : 0;
  }
  print('Part 1: $points');
  print('Part 2: $cards');
}