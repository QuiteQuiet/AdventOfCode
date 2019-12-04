import 'dart:io';

class Grid<T> {
  List<List<T>> _cells;
  T e;
  String toString() => this._cells.map((r) => r.join()).join('\n');
  T at(int x, int y) => this._cells[x][y];
  void put(int x, int y, T e) => this._cells[x][y] = e;
  Grid.initiate(int h, int w, T this.e) { this._cells = new List.generate(h, (i) => new List.filled(w, this.e)); }
  int count(T e) {
    int c = 0;
    for (int i = 0; i < this._cells.length; i++) {
      for (int j = 0; j < this._cells[i].length; j++) {
        if (this._cells[i][j] == e) c++;
      }
    }
    return c;
  }
}

void main() async {
  Grid<String> fabric = new Grid<String>.initiate(1000, 1000, '.');
  Map<String, int> claims = new Map(), remains = new Map();
  RegExp regex = new RegExp(r"#([0-9]+) @ ([0-9]+),([0-9]+): ([0-9]+)x([0-9]+)");
  await new File('input.txt').readAsLines()
    .then((List<String> file) {
      file.forEach((String line) {
        RegExpMatch match = regex.firstMatch(line);
        int left   = int.parse(match.group(2)),
            top    = int.parse(match.group(3)),
            width  = int.parse(match.group(4)),
            height = int.parse(match.group(5));
        String id = match.group(1);
        for (int i = left; i < left + width; i++) {
          for (int j = top; j < top + height; j++) {
            fabric.put(j, i, fabric.at(j, i) == '.' ? id : 'X');
          }
        }
        claims[id] = width * height;
      });
  });

  for (int i = 0; i < 1000; i++) {
    for (int j = 0 ; j < 1000; j++) {
      String id = fabric.at(i, j);
      if (remains.containsKey(id)) {
        remains[id]++;
      } else {
        remains[id] = 1;
      }
    }
  }
  String noOverlap;
  claims.forEach((String id, int s) {
    if (s == remains[id]) {
      noOverlap = id;
    }
  });
  print('Part 1: ${fabric.count('X')}');
  print('Part 2: $noOverlap');
}