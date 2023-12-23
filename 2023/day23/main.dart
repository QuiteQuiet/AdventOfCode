import 'dart:collection';
import 'dart:io';

import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/int.dart';

class Node {
  int x, y;
  Map<Node, int> connections = {};
  Node(this.x, this.y);
  void add(Node n, int s) => x != n.x || y != n.y ? connections[n] = s : null;
  operator==(Object o) => o is Node && x == o.x && y == o.y;
  int? _hashCode;
  int get hashCode => _hashCode ??= Object.hash(x, y);
  String toString() => '$x:$y';
}

int findLongest(Map<Node, Node> nodes, Node start, Node end) {
  List<(int, Node, Set<Node>)> toTest = [(0, nodes[start]!, {nodes[start]!})];
  int longest = 0;
  while (toTest.isNotEmpty) {
    var (steps, cur, path) = toTest.removeLast();

    // There is only one node that is connected to end so even if it has
    // more connections than that any path that goes that way is doomed.
    if (cur.connections.containsKey(end)) {
      int total = steps + cur.connections[end]!;
      if (total > longest) {
        longest = total;
      }
    } else {
      cur.connections.forEach((node, s) {
        if (path.contains(node)) return;
        toTest.add((steps + s, nodes[node]!, Set.from(path)..add(nodes[node]!)));
      });
    }
  }
  return longest;
}

void main() async {
  Grid<String> maze = Grid.string(await File('input.txt').readAsString(), (e) => e);

  Node? start, end;
  for (int i in 0.to(maze.width - 1)) {
    if (maze.at(i, 0) != '#') {
      start = Node(i, 0);
    }
    if (maze.at(i, maze.height - 1) != '#') {
      end = Node(i, maze.height - 1);
    }
  }

  // Build a weighted graph of intersections from the maze
  Queue<(Node, Node, int)> options = Queue()..add((start!, start, 0));
  Set<Node> visited = {};
  Map<Node, Node> nodes = {start: start};
  while (options.isNotEmpty) {
    var (cur, prev, steps) = options.removeFirst();
    if (visited.contains(cur)) {
      // Found an alternative path to this node, connect them
      if (nodes.containsKey(cur)) {
        nodes[prev]!.add(cur, steps);
      }
      continue;
    }
    visited.add(cur);

    List<Node> possible = [];
    int walls = 0;
    maze.adjacent(cur.x, cur.y, (x, y, el) {
      Node next = Node(x, y);
      if (maze.at(x, y) == '#') walls++;
      if ((el == '>' && cur.x + 1 == x) || (el == '<' && cur.x - 1 == x) ||
          (el == 'v' && cur.y + 1 == y) || (el == '^' && cur.y - 1 == y)) {
        possible.add(next);
      } else if (el == '.') {
        possible.add(next);
      }
    });

    // This is an intersection or edge of map
    if (walls < 2 || cur == end) {
      nodes[cur] = cur;
      nodes[prev]!.add(cur, steps);
      steps = 0;
      prev = cur;
    }
    for (Node n in possible) {
      options.add((n, prev, steps + 1));
    }
  }

  print('Part 1: ${findLongest(nodes, start, end!)}');

  // Complete the graph to be bi-directional
  for (Node node in nodes.values) {
    for (Node connected in node.connections.keys) {
      nodes[connected]!.add(node, node.connections[connected]!);
    }
  }
  print('Part 2: ${findLongest(nodes, start, end)}');
}