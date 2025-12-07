import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/space.dart';

void main() async {
  Grid<String> manifold = Grid.string(await aoc.getInputString(), (e) => e);

  Point? start;
  for (int i = 0; i < manifold.width; i++) {
    if (manifold.at(i, 0) == 'S') {
      start = Point(i, 0);
    }
  }

  Set<Point> splitters = {};
  List<Point> beams = [Point(start!.xi, start.yi + 1)];
  while (beams.isNotEmpty) {
    Point beam = beams.removeLast();
    if (manifold.outOfBounds(beam.xi, beam.yi)) {
      continue;
    }

    String state = manifold.at(beam.xi, beam.yi);
    if (state == '^') {
      beams.add(Point(beam.xi - 1, beam.yi));
      beams.add(Point(beam.xi + 1, beam.yi));
      splitters.add(beam);
    } else if (state == '.') {
      beams.add(Point(beam.xi, beam.yi + 1));
      manifold.put(beam.xi, beam.yi, '|');
    }
  }
  print('Part 1: ${splitters.length}');

  List<Point> reachableSplitters = splitters.toList()
    ..sort((p1, p2) => p2.yi == p1.yi ? p1.xi - p2.xi : p2.yi - p1.yi);

  Map<Point, int> splits = {};
  for (Point splitter in reachableSplitters) {
    int timelinesCreated = 0;
    for (int d in [-1, 1]) {
      int timelines = 1;
      for (int y = splitter.yi + 2; y < manifold.height; y++) {
        Point p = Point(splitter.xi + d, y);
        if (splits.containsKey(p)) {
          timelines = splits[p]!;
          break;
        }
      }
      timelinesCreated += timelines;
    }
    splits[splitter] = timelinesCreated;
  }
  print('Part 2: ${splits[Point(start.xi, 2)]}');
}
