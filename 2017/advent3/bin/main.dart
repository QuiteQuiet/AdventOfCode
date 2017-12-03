import 'dart:math';

enum dir {U, D, L, R}

void main() {
  int input = 347991, outer, distance;
  outer = sqrt(input).ceil(); // find the bounding square that contains the value (bottom right corner)
  // outerValue has an (outer - 1) length to reach the start, find how far from that we are
  distance = outer * outer - input;
  // part 1 because our input was so nice
  print('Part 1: ${(outer - 1) - distance}');

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

