import 'dart:io';

main() async {
  int floor = 0, first = null;
  new File('advent1/input.txt').readAsString()
  .then((String path) {
    for (int i = 0; i < path.length; i++) {
      floor += path[i] == '(' ? 1 : -1;
      if (first == null && floor < 0) first = i + 1;
    }
    print('Part 1: $floor');
    print('Part 2: $first');
  });
}
