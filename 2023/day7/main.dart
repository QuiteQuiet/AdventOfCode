import 'dart:io';

import 'package:AdventOfCode/string.dart';

class Hand {
  late int bet, value = 0;
  Hand(List<String> mine, Map<String, int> suits) {
    Map<int, int> cards = {};
    for (final (int i, String c) in mine[0].split('').indexed) {
      int card = c.toInt(onError: (c) => suits[c]);
      cards[card] = (cards[card] ?? 0) + 1;
      value |= card << (16 - 4 * i);
    }

    List<int> cardCount = cards.values.toList()..sort((a, b) => b - a);
    int jokers = cards[1] ?? 0; // 1 = jokers
    if (0 < jokers && jokers < 5) {
      cardCount.remove(jokers);
      cardCount[0] += jokers;
    }
    value |= switch (cardCount) {
      [5] => 7,
      [4, ...] => 6,
      [3, 2] => 5,
      [3, ...] => 4,
      [2, 2, ...] => 3,
      [2, ...] => 2,
      _ => 1,
    } << 20;
    bet = mine[1].toInt();
  }
}

int calc(List<String> lines, Map<String, int> cardMap) {
  List<Hand> hands = lines.map<Hand>((e) => Hand(e.split(' '), cardMap))
    .toList()..sort((a, b) => a.value - b.value);

  int sum = 0;
  for (int i = 0; i < hands.length; i++) {
    sum += hands[i].bet * (i + 1);
  }
  return sum;
}

void main() async {
  List<String> lines = await File('input.txt').readAsLines();

  print("Part 1: ${calc(lines, {'T': 10, 'J': 11, 'Q': 12, 'K': 13, 'A': 14})}");
  print("Part 2: ${calc(lines, {'T': 10, 'J': 1, 'Q': 12, 'K': 13, 'A': 14})}");
}