import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

int distance(List<int> a, List<int> b) => a.indexed.fold(0, (d, e) => d + (e.$2 - b[e.$1]).abs());

Set<int> findConstellationPoints(int point, List<List<int>> distances) {
  Set<int> points = {point};
  for (final (int i, int _) in distances[point].indexed.where((e) => e.$2 <= 3)) {
    points.addAll(findConstellationPoints(i + point + 1, distances));
  }
  return points;
}

void main() async {
  List<List<int>> points = (await aoc.getInput()).map((e) => e.numbers()).toList();

  List<List<int>> distances = List.generate(points.length, (_) => []);
  for (final (int i, List<int> p1) in points.indexed) {
    for (List<int> p2 in points.skip(i + 1)) {
      distances[i].add(distance(p1, p2));
    }
  }

  List<Set<int>> constellations = [];
  for (final (int i, _) in points.indexed) {
    if (constellations.any((e) => e.contains(i))) continue;
    Set<int> next = findConstellationPoints(i, distances);
    Set<int> toCombine = {};
    for (int el in next) {
      constellations.indexed.where((e) => e.$2.contains(el)).forEach((e) => toCombine.add(e.$1));
    }
    for (int i in toCombine.toList()..sort((a, b) => b - a)) {
      next.addAll(constellations.removeAt(i));
    }
    constellations.add(next);
  }
  print('Part 1: ${constellations.length}');
}
