import 'dart:io';

Function memoizeVariants() {
  Map<String, int> cache = {};
  int wrapped(List<String> springs, BigInt groups, bool lava) {
    String hash = '${springs.join()}:${groups.toRadixString(16)}:$lava';
    if (cache.containsKey(hash)) {
      int value = cache[hash]!;
      return value;
    }

    if (groups == 0)
      return cache[hash] = springs.contains('#') ? 0 : 1;
    else if (springs.isEmpty)
      return cache[hash] = groups > BigInt.zero ? 0 : 1;
    else if (groups & BigInt.from(0xF) == BigInt.zero)
      return cache[hash] = ['?', '.'].contains(springs.first) ?
        wrapped(springs.sublist(1), groups >> 4, false) : 0;
    else if (lava)
      return cache[hash] = ['?', '#'].contains(springs.first) ?
        wrapped(springs.sublist(1), groups - BigInt.one, true) : 0;
    else if (springs.first == '#')
      return cache[hash] = wrapped(springs.sublist(1), groups - BigInt.one, true);
    else if (springs.first == '.')
      return cache[hash] = wrapped(springs.sublist(1), groups, false);
    else
      return cache[hash] =
        wrapped(springs.sublist(1), groups, false) +
        wrapped(springs.sublist(1), groups - BigInt.one, true);
  }
  return wrapped;
}

void main() async {
  List<String> input = await File('input.txt').readAsLines();
  Function variants = memoizeVariants();

  int valid1 = 0, valid2 = 0;
  for (String line in input) {
    List<String> parts = line.split(' ');
    List<String> springs = parts[0].split('');
    List<int> numbers = parts[1].split(',').map(int.parse).toList();
    BigInt groups = BigInt.zero;
    for (final (int i, int e) in numbers.indexed) {
      groups |= BigInt.from(e << (i * 4));
    }
    valid1 += variants(springs, groups, false) as int;

    List<String> fiveSprings = [...springs, '?', ...springs, '?', ...springs, '?', ...springs, '?', ...springs];
    BigInt fiveGroups = BigInt.zero;
    for (int i = 0; i < 5; i++)
      fiveGroups |= groups << numbers.length * i * 4;
    valid2 += variants(fiveSprings, fiveGroups, false) as int;
  }
  print('Part 1: $valid1');
  print('Part 2: $valid2');
}
