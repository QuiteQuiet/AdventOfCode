import 'dart:io';
import 'package:collection/collection.dart';

import 'package:AdventOfCode/grid.dart';

class Node {
  int x, y, d, h, s;
  List<(int, int)> path = [];
  Node(this.x, this.y, this.d, this.h, this.s);
}

int run(Grid<int> input, int minSteps, int maxSteps) {
  HeapPriorityQueue<Node> toTest = HeapPriorityQueue<Node>((a, b) => a.h - b.h);
  Grid<Grid<int>> seen = Grid.generate(input.width, input.height,
    (_) => Grid.generate(4, maxSteps, (_) => 9999));

  toTest.add(Node(0, 0, 1, 0, 0));
  toTest.add(Node(0, 0, 3, 0, 0));

  List<(int, int)> directions = [(-1, 0), (1, 0), (0, -1), (0, 1)];
  List<List<int>> valid = [[0, 2, 3], [1, 2, 3], [2, 0, 1], [3, 0, 1]];

  while (toTest.isNotEmpty) {
    Node cur = toTest.removeFirst();
    if (seen.at(cur.x, cur.y).at(cur.d, cur.s) != 9999) continue;
    seen.at(cur.x, cur.y).put(cur.d, cur.s, cur.h);

    if (cur.x == input.width - 1 &&
        cur.y == input.height - 1 &&
        (cur.s >= minSteps || cur.s == 0 /*just turned*/)) {
      return cur.h;
    }

    (int, int) dir = directions[cur.d];
    int newx = cur.x + dir.$1, newy = cur.y + dir.$2;
    if (input.hasCoord(newx, newy)) continue;

    int loss = cur.h + input.at(newx, newy);
    if (cur.s >= minSteps - 1) {
      toTest.add(Node(newx, newy, valid[cur.d][1], loss, 0));
      toTest.add(Node(newx, newy, valid[cur.d][2], loss, 0));
    }
    if (cur.s < maxSteps - 1) {
      toTest.add(Node(newx, newy, valid[cur.d][0], loss, cur.s + 1));
    }
  }
  return -1;
}

void main() async {
  Grid<int> input = Grid.string(await File('input.txt').readAsString(), int.parse);

  print('Part 1: ${run(input, 0, 3)}');
  print('Part 2: ${run(input, 4, 10)}');
}