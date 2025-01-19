import 'dart:collection';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

void main() async {
  List<String> lines = await aoc.getInput();

  List<Queue<int>> getDecks(List<String> input) {
    List<Queue<int>> players = [Queue(), Queue()];
    int cur = 0;
    for (String line in lines) {
      if (line.startsWith('Player')) {
        cur = line.numbers()[0] - 1;
      } else if (line.isNotEmpty) {
        players[cur].add(line.toInt());
      }
    }
    return players;
  }

  List<Queue<int>> players = getDecks(lines);
  while (!players.any((e) => e.isEmpty)) {
    int a = players[0].removeFirst(), b = players[1].removeFirst();
    if (a > b) {
      players[0]..addLast(a)..addLast(b);
    } else {
      players[1]..addLast(b)..addLast(a);
    }
  }

  int winner = players[0].length != 0 ? 0 : 1;
  int weight = players[winner].length;
  print('Part 1: ${players[winner].fold<int>(0, (s, e) => s + e * weight--)}');

  // The most efficient way to track state is BigInt bitshifted by card values
  BigInt toBits(Queue<int> deck) => deck.fold<BigInt>(BigInt.zero, (v, e) => v | BigInt.from(1 << e));

  int playGame(Queue<int> a, Queue<int> b) {
    Set<(BigInt, BigInt)> previousStates = {};

    while (a.isNotEmpty && b.isNotEmpty) {
      BigInt aDeck = toBits(a), bDeck = toBits(b);
      if (!previousStates.add((aDeck, bDeck))) {
        return 1;
      }

      int? winner;
      int aCard = a.removeFirst(), bCard = b.removeFirst();
      if (aCard > a.length || bCard > b.length)
        winner = aCard > bCard ? 1 : 2;
      else
        winner = playGame(Queue.from(a.take(aCard)), Queue.from(b.take(bCard)));

      if (winner == 1)
        a..addLast(aCard)..addLast(bCard);
      else
        b..addLast(bCard)..addLast(aCard);
    }
    return a.isNotEmpty ? 1 : 2;
  }

  players = getDecks(lines);
  winner = playGame(players[0], players[1]) - 1;
  weight = players[winner].length;
  print('Part 2: ${players[winner].fold<int>(0, (s, e) => s + e * weight--)}');
}
