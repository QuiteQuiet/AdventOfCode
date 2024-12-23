import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void searchNetwork(Map<String, Set<String>> network, bool Function(List<String>) skip, void Function(List<String>) count) {
  List<List<String>> stack = network.keys.map((e) => [e]).toList();
  while (stack.isNotEmpty) {
    List<String> connected = stack.removeLast();
    if (skip(connected)) {
      continue;
    }
    count(connected);
    for (String next in network[connected.last]!) {
      if (connected.every((e) => network[next]!.contains(e))) {
          stack.add([...connected, next]);
      }
    }
  }
}

void main() async {
  List<String> lines = await aoc.getInput();

  Map<String, Set<String>> network = {};
  for (List<String> connection in lines.map((e) => e.split('-'))) {
    (network[connection[0]] ??= {}).add(connection[1]);
    (network[connection[1]] ??= {}).add(connection[0]);
  }

  Set<String> triplets = {};
  searchNetwork(network,
    (connected) => connected.length > 3,
    (connected) {
      if (connected.length == 3 && connected.any((e) => e.startsWith('t'))) {
        triplets.add((connected..sort()).join(','));
      }
    }
  );
  print('Part 1: ${triplets.length}');

  Set<String> checked = {};
  List<String> longest = [];
  searchNetwork(network,
    (connected) => !checked.add(connected.last),
    (connected) => connected.length > longest.length ? longest = connected : null);
  print('Part 2: ${(longest..sort()).join(',')}');
}