import 'dart:io';

class Point {
  int x, y, steps;
  Point(this.x, this.y);
  bool operator==(covariant Point o) => x == o.x && y == o.y;
  int get hashCode => '$x x $y'.hashCode;
  int get distance => x.abs() + y.abs();
  String toString() => '${x}x$y';
}

Map<Point, int> walk(List<String> instructions) {
  Point cur = Point(0, 0);
  Map<Point, int> line = Map<Point, int>();
  int steps = 0;
  for (int i = 0; i < instructions.length; i++) {
    String c = instructions[i][0];
    int dist = int.parse(instructions[i].substring(1));
    int incX = c == 'R' ? 1 : c == 'L' ? -1 : 0, incY = c == 'D' ? 1 : c == 'U' ? -1 : 0;
    for (int j = 0; j < dist; j++) {
      Point next = Point(cur.x + incX, cur.y + incY);
      line[next] = ++steps;
      cur = next;
    }
  }
  return line;
}

void main() {
  List<String> file = File('input.txt').readAsLinesSync();
  List<String> instrA = file[0].split(',');
  List<String> instrB = file[1].split(',');
  Map<Point, int> lineA = walk(instrA);
  Map<Point, int> lineB = walk(instrB);

  Stopwatch time = Stopwatch()..start();
  List<Point> intersects = lineA.keys.where((p) => lineB.containsKey(p)).toList()..sort((p1, p2) => p1.distance - p2.distance);
  print('Part 1: ${intersects[0].distance} (Time: ${time.elapsed})');

  List<int> steps = List.from(intersects.map((p) => lineA[p] + lineB[p]))..sort((p1, p2) => p1 - p2);
  print('Part 2: ${steps[0]} (Time: ${time.elapsed})');

}