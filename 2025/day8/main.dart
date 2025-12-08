import 'dart:math';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:collection/collection.dart';

class JunctionBox {
  int x, y, z;
  int? i;
  JunctionBox(this.x, this.y, this.z);
  num distance(JunctionBox o) => pow(o.x - x, 2) +  pow(o.y - y, 2) +  pow(o.z - z, 2);
}

void main() async {
  List<JunctionBox> boxes = (await aoc.getInput()).map((e) {
    List<int> it = e.split(',').map(int.parse).toList();
    return JunctionBox(it[0], it[1], it[2]);
    }).toList();

  HeapPriorityQueue<(int, int, num)> distances = HeapPriorityQueue((a, b) => b.$3 < a.$3 ? 1 : -1);
  for (final (int i, JunctionBox box) in boxes.indexed) {
    for (int ii = i + 1; ii < boxes.length; ii++) {
      distances.add((i, ii, box.distance(boxes[ii])));
    }
  }

  List<List<int>> circuits = [];
  int i = 0;
  while (true) {
    (int, int, num) pair = distances.removeFirst();
    JunctionBox box1 = boxes[pair.$1],
                box2 = boxes[pair.$2];

    if (box1.i == null && box2.i == null) {
      circuits.add([pair.$1, pair.$2]);
      box1.i = box2.i = circuits.length - 1;
    } else if (box1.i != null && box2.i == null) {
      circuits[box1.i!].add(pair.$2);
      box2.i = box1.i;
    } else if (box2.i != null && box1.i == null) {
      circuits[box2.i!].add(pair.$1);
      box1.i = box2.i;
    } else if (box1.i != box2.i) {
      int first = box1.i!, second = box2.i!;
      if (second < first) {
        first = box2.i!;
        second = box1.i!;
      }
      for (int b in circuits[second]) {
        circuits[first].add(b);
        boxes[b].i = first;
      }
      circuits[second].clear();
    }

    if (++i == 1000) {
      List<int> sizes = circuits.map((e) => e.length).toList()..sort((a, b) => b - a);
      print('Part 1: ${sizes[0] * sizes[1] * sizes[2]}');
    }

    if (circuits[0].length == boxes.length) {
      print('Part 2: ${box1.x * box2.x}');
      break;
    }
  }
}
