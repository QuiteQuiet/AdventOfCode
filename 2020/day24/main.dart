import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  List<String> lines = await aoc.getInput();

  Set<String> directions = {'e', 'se', 'sw', 'w', 'nw', 'ne'};

  Set<(int, int, int)> tiles = {};
  for (String line in lines) {
    int index = 0, x = 0, y = 0, z = 0;
    while (index < line.length) {
      String dir = line[index++];
      if (!directions.contains(dir)) {
        dir += line[index++];
      }

      switch (dir) {
        case 'e': x++; y--;
        case 'ne': x++; z--;
        case 'w': x--; y++;
        case 'sw': x--; z++;
        case 'nw': y++; z--;
        case 'se': y--; z++;
      }
    }
    (int, int, int) pos = (x, y, z);
    tiles.contains(pos) ? tiles.remove(pos) : tiles.add(pos);
  }
  print('Part 1: ${tiles.length}');

  for (int i = 0; i < 100; i++) {
    Map<(int, int, int), int> adjacent = {};
    for ((int, int, int) tile in tiles) {
      for ((int, int, int) dir in [(1, -1, 0), (1, 0, -1),
                                   (-1, 1, 0), (-1, 0, 1),
                                   (0, 1, -1), (0, -1, 1)]) {

        (int, int, int) next = (tile.$1 + dir.$1,
                                tile.$2 + dir.$2,
                                tile.$3 + dir.$3);
        adjacent.update(next, (v) => v + 1, ifAbsent: () => 1);
      }
    }

    Set<(int, int, int)> next = {};
    for (MapEntry entry in adjacent.entries) {
      if ((tiles.contains(entry.key) && (entry.value == 1 ||entry.value == 2)) ||
          entry.value == 2) {
        next.add(entry.key);
      }
    }
    tiles.clear();
    tiles = next;
  }
  print('Part 2: ${tiles.length}');
}
