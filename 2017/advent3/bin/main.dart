import 'dart:math';

enum dir {U, D, L, R}

void main() {
  int input = 347991,
  outer = sqrt(input).ceil(),                 // find the bounding square that contains the value (bottom right corner)
  side = outer % 2 != 0 ? outer : outer + 1,  // length of the current side
  row = (side - 1) ~/ 2,                      // steps to reach the starting row
  offset = (input - (side - 2) * (side - 2)) % (side - 1); // find starting column offset

  // part 1
  print('Part 1: ${row + (offset - row).abs()}');

  // part 2
  int written = 1, x = 49, y = 49;
  // generate a small subset of the whole square
  List<List<int>> grid = new List.generate(100, (i) => new List.generate(100, (j) => 0));
  grid[x][y] = 1;
  dir d = dir.R;
  while (written < input) {
    int sum = 0;
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        sum += grid[i][j];
      }
    } 
    written = grid[x][y] = sum;
    switch (d) {
      case dir.R: if (x <= grid.length - 1 && grid[x][y - 1] == 0) { d = dir.U; } break;
      case dir.U: if (grid[x - 1][y] == 0) { d = dir.L; } break;
      case dir.L: if (x == 0 || grid[x][y + 1] == 0) { d = dir.D; } break;
      case dir.D: if (grid[x + 1][y] == 0) { d = dir.R; } break;
    }
    switch (d) {
      case dir.R: x++; break;
      case dir.U: y--; break;
      case dir.L: x--; break;
      case dir.D: y++; break;
    }
  }
  print('Part 2: $written');
}

