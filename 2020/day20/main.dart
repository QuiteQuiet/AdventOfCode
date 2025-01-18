import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/space.dart';
import 'package:AdventOfCode/string.dart';

class PuzzlePiece {
  int id;
  Grid<String> tile;
  PuzzlePiece(this.id, this.tile);
}

Iterable<Grid<String>> allOrientations(Grid<String> square) sync* {
  for(bool vert in [true, false, true]) {
    for (int i = 0; i < 4; i++) {
      yield square;
      square.rotate();
    }
    if (vert)
      square.flip(vertical: true);
    else
      square.flip(horizontal: true);
  }
}

(int?, int?) fitsTogether(PuzzlePiece a, PuzzlePiece b) {
  int w = a.tile.width, h = a.tile.height;
  bool top = true, bottom = true;
  for (int x = 0; x < w; x++) {
    if (a.tile.at(x, 0) != b.tile.at(x, h - 1))
      top = false;
    if (a.tile.at(x, h - 1) != b.tile.at(x, 0))
      bottom = false;
  }
  if (top) return (0, 1);
  if (bottom) return (0, -1);

  bool left = true, right = true;
  for (int y = 0; y < h; y++) {
    if (a.tile.at(0, y) != b.tile.at(w - 1, y))
      left = false;
    if (a.tile.at(w - 1, y) != b.tile.at(0, y))
      right = false;
  }
  if (left) return (1, 0);
  if (right) return (-1, 0);

  return (null, null);
}

(int?, int?) tryAllPositions(PuzzlePiece a, PuzzlePiece b) {
  (int?, int?) result;
  for (Grid<String> _ in allOrientations(a.tile)) {
    result = fitsTogether(a, b);
    if (result.$1 != null) return result;
  }
  return (null, null);
}

///                   #
/// #    ##    ##    ###
///  #  #  #  #  #  #
int countSeaMonster(Grid<String> picture) {
  List<Point> seaMonster = [Point(0, 1), Point(1, 2), Point(4, 2), Point(5, 1), Point(6, 1), Point(7, 2),
                            Point(10, 2), Point(11, 1), Point(12, 1), Point(13, 2),
                            Point(16, 2), Point(17, 1), Point(18, 1), Point(18, 0), Point(19, 1)];
  int count = 0;
  picture.every((x, y, e) {
    for (Point seg in seaMonster) {
      int xs = x + seg.xi, ys = y + seg.yi;
      if (picture.outOfBounds(xs, ys) || picture.at(xs, ys) != '#')
        return;
    }
    count++;
  });
  return count;
}

int findSeaMonsters(Grid<String> picture) {
  for (Grid<String> _ in allOrientations(picture)) {
    int count = countSeaMonster(picture);
    if (count > 0) return count;
  }
  return 0;
}

void main() async {
  List<String> lines = (await aoc.getInput())..add('');

  List<PuzzlePiece> pieces = [];
  List<String> cur = [];
  for (String line in lines) {
    if (line.isNotEmpty) {
      cur.add(line);
    } else {
      Grid<String> tile = Grid.from(cur.skip(1).map((e) => e.split('')));
      pieces.add(PuzzlePiece(cur.first.numbers()[0], tile));
      cur.clear();
    }
  }

  Map<(int, int), PuzzlePiece> canvas = {(0, 0): pieces.first};
  Set<int> fixed = {pieces.first.id};
  while (fixed.length != pieces.length) {
    for (PuzzlePiece p in pieces) {
      if (fixed.contains(p.id)) continue;

      List<(int, int)> keys = canvas.keys.toList();
      for ((int, int) key in keys) {
        (int?, int?) place = tryAllPositions(p, canvas[key]!);
        if (place.$1 != null) {
          canvas[(key.$1 + place.$1!, key.$2 + place.$2!)] = p;
          fixed.add(p.id);
          break;
        }
      }
    }
  }
  int xmin = 0, xmax = 0, ymin = 0, ymax = 0;
  for ((int, int) key in canvas.keys) {
    if (xmin > key.$1) xmin = key.$1;
    if (xmax < key.$1) xmax = key.$1;
    if (ymin > key.$2) ymin = key.$2;
    if (ymax < key.$2) ymax = key.$2;
  }

  int product = (canvas[(xmin, ymin)]!.id * canvas[(xmax, ymin)]!.id *
                 canvas[(xmin, ymax)]!.id * canvas[(xmax, ymax)]!.id);
  print('Part 1: $product');

  int pieceWidth = pieces.first.tile.width - 2, pieceHeight = pieces.first.tile.height - 2;
  int fullWidth = (1 + xmax - xmin) * pieceWidth,
      fullHeight = (1 + ymax - ymin) * pieceHeight;

  Grid<String> fullPicture = Grid.filled(fullWidth, fullHeight, '.');
  fullPicture.every((x, y, e) {
    int xq = (x ~/ pieceWidth) + xmin, yq = (y ~/ pieceHeight) + ymin;
    Grid<String> tile = canvas[(xq, yq)]!.tile;
    fullPicture.put(x, y, tile.at((x % pieceWidth) + 1, (y % pieceHeight) + 1));
  });

  int monster = findSeaMonsters(fullPicture);
  int busy = fullPicture.fold<int>(0, (s, x, y, e) => s + (e == '#' ? 1: 0));

  // Sea monsters are 15 #s big
  print('Part 2: ${busy - monster * 15}');
}