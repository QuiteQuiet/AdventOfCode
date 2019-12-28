import 'dart:io';
import 'dart:math';

class Lights {
  int h, w;
  List<List<int>> grid;
  Lights(this.w, this.h) {
    this.grid = new List.generate(w, (i) => new List.filled(h, 0));
  }
  void toggle(int xs, int ys, int xe, int ye) {
    for (int i = xs; i <= xe; i++) {
      for (int j = ys; j <= ye; j++) {
        this.grid[i][j] = this.grid[i][j] == 0 ? 1 : 0;
      }
    }
  }
  void change(int xs, int ys, int xe, int ye, int value) {
    for (int i = xs; i <= xe; i++) {
      for (int j = ys; j <= ye; j++) {
        this.grid[i][j] = value;
      }
    }
  }
  void inc(int xs, int ys, int xe, int ye) {
    for (int i = xs; i <= xe; i++) {
      for (int j = ys; j <= ye; j++) {
        this.grid[i][j]++;
      }
    }
  }
  void dec(int xs, int ys, int xe, int ye) {
    for (int i = xs; i <= xe; i++) {
      for (int j = ys; j <= ye; j++) {
        this.grid[i][j] = max(0, this.grid[i][j] - 1);
      }
    }
  }
  String toString() => this.grid.map((l) => l.join(' ')).toList().join('\n');
}
void main() {
  Lights lights = new Lights(1000, 1000), lights2 = new Lights(1000, 1000);
  RegExp digits = new RegExp('[0-9]+');
  new File('advent6/input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      List<int> l = digits.allMatches(line).map((m) => int.parse(m.group(0))).toList();
      if (line.startsWith('toggle')) {
        lights.toggle(l[0], l[1], l[2], l[3]);
        lights2.inc(l[0], l[1], l[2], l[3]);
        lights2.inc(l[0], l[1], l[2], l[3]);
      }
      else if (line.startsWith('turn on')) {
        lights.change(l[0], l[1], l[2], l[3], 1);
        lights2.inc(l[0], l[1], l[2], l[3]);
      }
      else if (line.startsWith('turn off')) {
        lights.change(l[0], l[1], l[2], l[3], 0);
        lights2.dec(l[0], l[1], l[2], l[3]);
      }
    });
    
    print('Part 1: ${"1".allMatches("$lights").length}');
    print('Part 2: ${lights2.grid.fold(0, (i, l) => i + l.reduce((a, b) => a + b))}');
  });
}