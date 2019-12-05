import 'dart:io';

class Point {
  int x, y, steps;
  Point(this.x, this.y, this.steps);
  bool operator==(covariant Point o) => x == o.x && y == o.y;
  int get hashCode => '$x x $y'.hashCode;
  int get distance => x.abs() + y.abs();
  String toString() => '${x}x$y';
}

Set<Point> walk(List<String> instructions) {
  Point cur = Point(0, 0, 0);
  Set<Point> line = Set<Point>();
  for (int i = 0; i < instructions.length; i++) {
    String c = instructions[i][0];
    int dist = int.parse(instructions[i].substring(1));
    int incX = c == 'R' ? 1 : c == 'L' ? -1 : 0, incY = c == 'D' ? 1 : c == 'U' ? -1 : 0;
    for (int j = 0; j < dist; j++) {
      Point next = Point(cur.x + incX, cur.y + incY, cur.steps + 1);
      line.add(next);
      cur = next;
    }
  }
  return line;
}

void main() {
  List<String> file = File('input.txt').readAsLinesSync();
  List<String> instrA = file[0].split(',');
  List<String> instrB = file[1].split(',');
  Set<Point> lineA = walk(instrA);
  Set<Point> lineB = walk(instrB);

  List<Point> intersects = lineA.where((p) => lineB.contains(p)).toList()..sort((p1, p2) => p1.distance - p2.distance);
  print('Part 1: ${intersects[0].distance}');

  List<int> points = lineB.where((p) => lineA.contains(p))
    .map((p) => intersects[intersects.indexOf(p)].steps + p.steps).toList()
    ..sort((p1, p2) => p1 - p2);
  print('Part 2: ${points[0]}');
}