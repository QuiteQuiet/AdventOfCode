import 'dart:io';
import 'dart:collection';

import 'package:AdventOfCode/int.dart';

void rotate(Queue q, int n) {
  if (n > 0) {
    for (int _ in 1.to(n))
      q.addFirst(q.removeLast());
  } else {
    for (int _ in 1.to(n.abs()))
      q.addLast(q.removeFirst());
  }
}

int play(int playerNumber, int marbleNumber) {
  Queue<int> marbles = Queue()..add(0);
  List<int> players = List.generate(playerNumber, (_) => 0);

  for (int m in 1.to(marbleNumber - 1)) {
    if (m % 23 == 0) {
      rotate(marbles, 8);
      players[m % players.length] += m + marbles.removeFirst();
      rotate(marbles, -1);
    } else {
      rotate(marbles, -1);
      marbles.add(m);
    }
  }
  return players.reduce((a, b) => a < b ? b : a);
}

void main() async {
  List<int> input = RegExp(r'\d+').allMatches(await File('input.txt').readAsString()).map((e) => int.parse(e.group(0)!)).toList();

  print('Part 1: ${play(input[0], input[1])}');
  print('Part 2: ${play(input[0], input[1] * 100)}');
}