import 'dart:collection';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

final class CrabCup extends LinkedListEntry<CrabCup> {
  int id;
  CrabCup(this.id);
}

void simulateRounds(LinkedList<CrabCup> cups, List<CrabCup> lookupTable, int rounds) {
  int size = cups.length;
  CrabCup cur = cups.first;
  LinkedList<CrabCup> removed = LinkedList<CrabCup>();
  for (int i = 0; i < rounds; i++) {
    List<int> skips = [0, 0, 0];

    CrabCup toAdd = cur.next ?? cups.first;
    while (removed.length != 3) {
      CrabCup next = toAdd.next ?? cups.first;
      skips[removed.length] = toAdd.id;
      cups.remove(toAdd);
      removed.add(toAdd);
      toAdd = next;
    }

    int toFind = cur.id - 1;
    while (toFind < 1 || skips.contains(toFind)) toFind = toFind < 1 ? size : toFind - 1;

    CrabCup goal = lookupTable[toFind - 1];
    while (removed.isNotEmpty) {
      CrabCup tmp = removed.last;
      removed.remove(tmp);
      goal.insertAfter(tmp);
    }
    cur = cur.next ?? cups.first;
  }
}

void main() async {
  List<int> numbers = (await aoc.getInput()).first.split('').map(int.parse).toList();
  LinkedList<CrabCup> cups = LinkedList<CrabCup>();
  cups.addAll(numbers.map((e) => CrabCup(e)));

  List<CrabCup> lookupTable = List.from(cups)..sort((a, b) => a.id - b.id);

  simulateRounds(cups, lookupTable, 100);

  CrabCup next = lookupTable[0].next ?? cups.first;
  List<int> order = [];
  while (order.length < 8) {
    order.add(next.id);
    next = next.next ?? cups.first;
  }
  print('Part 1: ${order.join('')}');

  cups.clear();
  cups..addAll(numbers.map((e) => CrabCup(e)))..add(CrabCup(cups.length + 1));
  lookupTable = List.from(cups)..sort((a, b) => a.id - b.id);
  while (cups.last.id != 1000000) {
    cups.add(CrabCup(cups.last.id + 1));
    lookupTable.add(cups.last);
  }

  simulateRounds(cups, lookupTable, 10000000);

  CrabCup clockwise = lookupTable[0].next!; // no way the puzzle put 1 at the end
  print('Part 2: ${clockwise.id * clockwise.next!.id}');
}
