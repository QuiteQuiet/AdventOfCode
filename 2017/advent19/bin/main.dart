import 'dart:io';

enum Direction { Up, Down, Left, Right }

main() async {
  int x = 0, y = 0, steps = 0;
  Direction dir = Direction.Down;
  List<String> letters = new List<String>.empty(growable: true);
  List<List<String>> map = new List<List<String>>.empty(growable: true);
  new File('input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) => map.add(line.split('')));
    x = map[0].indexOf('|');
    while (map[y][x] != ' ') {
      steps++;
      if (!'|-+'.contains(map[y][x])) letters.add(map[y][x]);
      switch (dir) {
        case Direction.Down:
          y++;
          if (map[y][x] == '+') {
            if (map[y][x + 1] == '-') dir = Direction.Right;
            if (map[y][x - 1] == '-') dir = Direction.Left;
          }
        break;
        case Direction.Up:
          y--;
          if (map[y][x] == '+') {
            if (map[y][x + 1] == '-') dir = Direction.Right;
            if (map[y][x - 1] == '-') dir = Direction.Left;
          }
        break;
        case Direction.Left:
          x--;
          if (map[y][x] == '+') {
            if (map[y + 1][x] == '|') dir = Direction.Down;
            if (map[y - 1][x] == '|') dir = Direction.Up;
          }
        break;
        case Direction.Right:
          x++;
          if (map[y][x] == '+') {
            if (map[y + 1][x] == '|') dir = Direction.Down;
            if (map[y - 1][x] == '|') dir = Direction.Up;
          }
        break;
      }
    }
    print('Part 1: ${letters.join()}');
    print('Part 2: $steps');
  });
}