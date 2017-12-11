import 'dart:io';
import 'dart:math';

main() async {
  int x = 0, y = 0, z = 0;
  List<int> distances = new List<int>();
  Stopwatch time = new Stopwatch()..start();
  await new File('advent11/input.txt').readAsLines()
  .then((List<String> file) {
    for (String dir in file[0].split(',')) {
      switch (dir) {
        case 's': x--; z++; break;
        case 'n': x++; z--; break;
        case 'sw': x--; y++; break;
        case 'se': y--; z++; break;
        case 'nw': y++; z--; break;
        case 'ne': y--; x++; break;
      }
      distances.add((x.abs() + y.abs() + z.abs()) ~/ 2);
    }
    });

    print('Part 1: ${distances.last}');
    print('Part 2: ${distances.reduce(max)}');
}