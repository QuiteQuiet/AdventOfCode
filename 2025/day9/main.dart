import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/space.dart';

(int, int) sort(int a, int b) => a < b ? (a, b) : (b, a);

bool intersects((int, int) x, (int, int) y, Point l1, Point l2) {
  final (int lxmin, int lxmax) = sort(l1.xi, l2.xi);
  final (int lymin, int lymax) = sort(l1.yi, l2.yi);
  bool xdim, ydim;
  if (lxmin == lxmax) {
    xdim = x.$1 < lxmin && lxmin < x.$2;
    ydim = (lymin <= y.$1 && lymax > y.$1) || (lymin < y.$2 && lymax >= y.$2);
  } else {
    xdim = (lxmin <= x.$1 && lxmax > x.$1) || (lxmin < x.$2 && lxmax >= x.$2);
    ydim = y.$1 < lymin && lymin < y.$2;
  }
  return xdim && ydim;
}

void main() async {
  List<Point> tiles = (await aoc.getInput()).map((e) {
    List<int> coords = e.split(',').map(int.parse).toList();
    return Point(coords[0], coords[1]);
  }).toList();

  List<(int, bool)> areas = [];
  for (final (int i, Point tile) in tiles.indexed) {
    for (Point other in tiles.skip(i + 1)) {
      bool valid = true;
      final (int, int) xbounds = sort(tile.xi, other.xi);
      final (int, int) ybounds = sort(tile.yi, other.yi);

      for (final (int ii, Point t) in tiles.indexed) {
        if (intersects(xbounds, ybounds, t, tiles[(ii + 1) % tiles.length])) {
          valid = false;
          break;
        }
      }
      areas.add((tile.area(other), valid));
    }
  }
  areas.sort((a, b) => b.$1 - a.$1);
  print('Part 1: ${areas.first.$1}');
  print('Part 2: ${areas.firstWhere((e) => e.$2).$1}');
}
