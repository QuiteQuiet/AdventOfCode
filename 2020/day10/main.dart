import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  List<int> adapters = (await aoc.getInput()).map(int.parse).toList()..sort();

  List<int> diff = [0, 1, 0, 1];
  adapters.indexed.skip(1).forEach((e) => diff[e.$2 - adapters[e.$1 - 1]]++);
  print('Part 1: ${diff[1] * diff[3]}');

  List<int> cache = List.filled(adapters.length + 2, -1);
  int compatible(int cur, List<int> adapters) {
    if (cache[cur] != -1) return cache[cur];
    if (adapters[cur] == adapters.last) return cache[cur] = 1;

    int options = 0, start = adapters[cur];
    while (cur < adapters.length - 1 && adapters[++cur] - start <= 3)
      options += cache[cur] = compatible(cur, adapters);
    return options;
  }
  print('Part 2: ${compatible(0, [0, ...adapters, adapters.last + 3])}');
}
