import 'dart:io';
class Disc {
  int s, u, a;
  Disc(this.s, this.u, this.a);
  bool operator==(covariant Disc o) => this.s == o.s && this.u == o.u && this.a == o.a;
}
class Grid {
  List _l;
  int _x, _y;
  Grid(this._x, this._y) { this._l = new List.generate(this._x, (i) => new List(this._y)); }
  Disc operator[](List<int> xy) => this._l[xy[0]][xy[1]];
  void operator[]=(List<int> xy, Disc o) { this._l[xy[0]][xy[1]] = o; }
  Iterable<Disc> get All sync* {
    for (int i = 0; i < this._x; i++) {
      for (int j = 0; j < this._y; j++) {
        yield this[[i, j]];
      }
    }
  }
  String toString() {
    String buf = '';
    for (int i = 0; i < this._x; i++) {
      for (int j = 0; j < this._y; j++) {
        if (i == 0 && j == 0) buf += 'X ';
        else if (this[[i, j]].u > 100) buf += '# ';
        else if (this[[i, j]].u < 1) buf += 'E ';
        else if (i == this._x - 1 && j == 0) buf += 'G ' ;
        else buf += '. ';
      }
      buf += '\n';
    }
    return buf;
  }
}
main() async {
  List<List<Disc>> pairs = new List();
  Grid discs = new Grid(30, 35);
  await new File('input.txt').readAsLines()
  .then((List<String> file ) => file.sublist(2).forEach((String line) {
    // Building the disc grid
    List<String> p = line.split(new RegExp(' +'));
    List<int> loc = p[0].split('-').sublist(1).map((e) => int.parse(e.substring(1))).toList(),
      params = p.sublist(1, 4).map((e) => int.parse(e.substring(0, e.length - 1))).toList();
    discs[loc] = new Disc(params[0], params[1], params[2]);
  }));
  for (Disc d in discs.All) {
    if (d.u == 0) continue;
    for (Disc d2 in discs.All) {
      if (d == d2) continue;
      if (d2.a >= d.u) {
        pairs.add([d, d2]);
      }
    }
  }
  print('Part 1: ${pairs.length}');
  print('Part 2: moves to gap + moves to G + + + 5 x squares to X = 198\n$discs');
}