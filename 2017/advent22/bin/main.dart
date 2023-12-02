import 'dart:io';

enum Direction { Up, Down, Left, Right}

class Grid<T> {
  late List<List<T>> cells;
  Grid() { this.cells = new List<List<T>>.empty(); }
  String toString() => this.cells.map((r) => r.join()).join('\n');
  T at(int x, int y) => this.cells[x][y];
  void place(int x, int y, T e) => this.cells[x][y] = e;
  void initiate(int h, int w, T e) => this.cells = new List.generate(h, (i) => new List.filled(w, e));
}

class Carrier {
  int x, y, bursts = 10000;
  bool part2 = false;
  Direction dir = Direction.Up;
  Carrier(this.x, this.y);
  void move() {
    switch (this.dir) {
      case Direction.Up: this.x--; break;
      case Direction.Down: this.x++; break;
      case Direction.Left: this.y--; break;
      case Direction.Right: this.y++; break;
    }
  }
  String mutate(String cur) {
    switch (cur) {
      case '.': return part2 ? 'W' : '#';
      case 'W': return '#';
      case '#': return part2 ? 'F' : '.';
      case 'F': return '.';
    }
    return '';
  }
  void turn(String cur) {
    if (cur == '#') {
      switch (this.dir) {
        case Direction.Up: this.dir = Direction.Right; break;
        case Direction.Down: this.dir = Direction.Left; break;
        case Direction.Left: this.dir = Direction.Up; break;
        case Direction.Right: this.dir = Direction.Down; break;
      }
    }
    else if (cur == '.') {
      switch (this.dir) {
        case Direction.Up: this.dir = Direction.Left; break;
        case Direction.Down: this.dir = Direction.Right; break;
        case Direction.Left: this.dir = Direction.Down; break;
        case Direction.Right: this.dir = Direction.Up; break;
      }
    }
    else if (cur == 'F'){
      switch (this.dir) {
        case Direction.Up: this.dir = Direction.Down; break;
        case Direction.Down: this.dir = Direction.Up; break;
        case Direction.Left: this.dir = Direction.Right; break;
        case Direction.Right: this.dir = Direction.Left; break;
      }
    }
  }
}

main() async {
  Grid<String> grid = new Grid<String>();
  new File('input.txt').readAsLines()
  .then((List<String> file) {
    for (int parts = 0; parts < 2; parts++) {
      List<List<String>> infection;
      infection = file.map((l) => l.split('')).toList();
      grid.initiate(infection.length * 25, infection[0].length * 25, '.'); // just make it really big eh?
      int center = (grid.cells.length / 2).round(), topleft = center - infection.length ~/ 2;
      for (int i = 0; i < infection.length; i++) {
        for (int j = 0; j < infection[i].length; j++) {
          grid.cells[topleft + i][topleft + j] = infection[i][j];
        }
      }
      Carrier virus = new Carrier(center, center);
      if (parts == 1) {
        virus.part2 = true;
        virus.bursts = 10000000;
      }
      // actually solving it now
      int newinfections = 0;
      for (int i = 0; i < virus.bursts; i++) {
        String current = grid.at(virus.x, virus.y);
        virus.turn(current);
        String next = virus.mutate(current);
        if (next == '#') newinfections++;
        grid.place(virus.x, virus.y, next);
        virus.move();
      }
      print('Part ${parts + 1}: $newinfections');
    }
  });
}