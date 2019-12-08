import 'dart:io';

class Grid<T> {
  List<List<T>> cells;
  T e;
  String toString() => this.cells.map((r) => r.join()).join('\n') + '\n';
  T at(int x, int y) => this.cells[x][y];
  void put(int x, int y, T e) => this.cells[x][y] = e;
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
  int w = 25, h = 6;
  List<String> input = File('input.txt').readAsStringSync().split('');
  Grid<String> image = Grid.initiate(w, h, ''), output = Grid.initiate(w, h, '.');
  int index = 0, min = 10000000, ones, twos;

  while (index < input.length) {
    for (int x = 0; x < image.cells.length; x++) {
      for (int y = 0; y < image.cells[x].length; y++) {
        String char = input[index++];
        image.put(x, y, char);
        if (output.at(x, y) == '.' && char != '2') {
          output.put(x, y, char.replaceAll('1', '#').replaceAll('0', ' '));
        }
      }
    }
    int zeros = image.count('1');
    if (zeros < min) {
      min = zeros;
      ones = image.count('1');
      twos = image.count('2');
    }
  }
  print('Part 1: ${ones * twos}');
  print('Part 2:\n${output.toString()}');
}