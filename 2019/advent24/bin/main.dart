import 'dart:math';

int count(List grid, int x, int y) {
  int c = 0;
  if (x > 0 && grid[y][x-1] == '#') c++;
  if (y > 0 && grid[y-1][x] == '#') c++;
  if (x + 1 < grid[y].length && grid[y][x+1] == '#') c++;
  if (y + 1 < grid.length && grid[y+1][x] == '#') c++;
  return c;
}

int recursive(List space, int level, int x, int y) {
  int c = 0;
  List<List<String>> grid = space[level];
  c += count(grid, x, y);
  if (level < space.length - 1) {
    if (x == 0 && space[level+1][2][1] == '#') c++;
    if (y == 0 && space[level+1][1][2] == '#') c++;
    if (x + 1 == grid[y].length && space[level+1][2][3] == '#') c++;
    if (y + 1 == grid.length && space[level+1][3][2] == '#') c++;
  }
  if (level > 0) {
    if (x == 2 && y == 1) c += space[level-1][0].where((s) => s == '#').length;
    if (x == 2 && y == 3) c += space[level-1][4].where((s) => s == '#').length;
    if (y == 2 && x == 1)
      for (int i = 0, len = space[level-1].length; i < len; i++)
        if (space[level-1][i][0] == '#') c++;
    if (y == 2 && x == 3)
      for (int i = 0, len = space[level-1].length; i < len; i++)
        if (space[level-1][i][4] == '#') c++;
  }
  return c;
}

void main() {
  String input = '''
####.
.###.
.#..#
##.##
###..''';

  List<List<String>> state = input.split('\n').map((line) => line.split('')).toList();
  Set<String> states = {};
  while (!states.contains('$state')) {
    states.add('$state');
    List<List<String>> next = [];
    for (int y = 0; y < state.length; y++) {
      next.add([]);
      for (int x = 0; x < state[y].length; x++) {
        int bugs = count(state, x, y);
        if (state[y][x] == '#' && bugs != 1) next[y].add('.');
        else if (state[y][x] == '.' && (bugs == 1 || bugs == 2)) next[y].add('#');
        else next[y].add(state[y][x]);
      }
    }
    state = next;
  }
  int rating = 0, index = 0;
  for (int y = 0; y < state.length; y++)
    for (int x = 0; x < state[y].length; x++, index++)
      rating += state[y][x] == '#' ? pow(2, index) : 0;

  state = input.split('\n').map((line) => line.split('')).toList();
  state[2][2] = '?';
  List<List<List<String>>> space = [state], placeholder;
  for (int i = 0; i < 200; i++) {
    placeholder = [];
    // add new subspace and superspace layers when needed
    if (space.first.fold(0, (bugs, l) => bugs + l.where((e) => e == '#').length) > 0)
      space.insert(0, List.generate(5, (i) => List.filled(5, '.')));
    if (space.last.fold(0, (bugs, l) => bugs + l.where((e) => e == '#').length) > 0)
      space.add(List.generate(5, (i) => List.filled(5, '.')));
    space.last[2][2] = space.first[2][2] = '?';
    for (int s = 0, len = space.length; s < len; s++) {
      List<List<String>> next = [], cur = space[s];
      for (int y = 0; y < cur.length; y++) {
        next.add([]);
        for (int x = 0; x < cur[y].length; x++) {
          int bugs = recursive(space, s, x, y);
          if (cur[y][x] == '#' && bugs != 1) next[y].add('.');
          else if (cur[y][x] == '.' && (bugs == 1 || bugs == 2)) next[y].add('#');
          else next[y].add(cur[y][x]);
        }
      }
      placeholder.add(next);
    }
    space = placeholder;
  }
  print('Part 1: $rating');
  print('Part 2: ${space.fold(0, (sum, layer) => sum + layer.fold(0, (c, l) => c + l.where((e) => e == '#').length))}');
}