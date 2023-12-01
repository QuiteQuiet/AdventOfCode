import 'dart:io';

class Grid<T> {
  late List<List<T>> cells;
  T e;
  String toString() => this.cells.map((r) => r.join()).join('\n') + '\n';
  T at(int x, int y) => this.cells[y][x];
  void put(int x, int y, T e) => this.cells[y][x] = e;
  bool border(int x, int y) => x == 0 || y == 0 || y == cells.length - 1 || x == cells[0].length -1;
  Grid.initiate(int w, int h, T this.e) { this.cells = new List.generate(h, (i) => new List.filled(w, this.e)); }
  int count(T e) {
    int c = 0;
    for (int i = 0; i < this.cells.length; i++) {
      for (int j = 0; j < this.cells[i].length; j++) {
        if (this.cells[i][j] == e) c++;
      }
    }
    return c;
  }
}

void main() {
  List<List<int>> input = List.from(File('input.txt').readAsLinesSync().map((el) => el.split(', ').map(int.parse).toList()))
    ..sort((a, b) => a[0] == b[0] ? a[1] - b[1] : a[0] - b[0]);
  List<String> repr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
  Set<String> infinity = Set();
  int closeEnough = 0;
  int xmin = input[0][0], xmax = input.last[0] + 1,
      ymin = input.reduce((a, b) => a[1] < b[1] ? a : b)[1],
      ymax = input.reduce((a, b) => a[1] > b[1] ? a : b)[1] + 1;
  Grid grid = Grid.initiate(xmax - xmin, ymax - ymin, '.');
  for (int x = xmin; x < xmax; x++) {
    for (int y = ymin; y < ymax; y++) {
      int min = 100000, sum = 0;
      String point = '';
      for (int z = 0; z < input.length; z++) {
        int dist = (x - input[z][0]).abs() + (y - input[z][1]).abs();
        if (dist < min) {
          point = repr[z];
          min = dist;
        } else if (dist == min) {
          point = '.';
        }
        sum += dist;
      }
      grid.put(x - xmin, y - ymin, point);
      if (grid.border(x - xmin, y - ymin)) {
          infinity.add(point);
      }
      if (sum < 10000) closeEnough++;
    }
  }
  print('Part 1: ${(repr.where((el) => !infinity.contains(el)).map((el) => grid.count(el)).toList()..sort()).last}');
  print('Part 2: $closeEnough');
}