import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';

int seatSimulation(Grid<String> seats, int limit, bool Function(Grid<String>, int, int, int, int) isOccupied) {
  int changed = 1;
  while (changed > 0) {
    Grid<String> temp = Grid.filled(seats.width, seats.height, '.');
    changed = 0;
    seats.every((x, y, e) {
      if (e == '.') return;

      int occupied = 0;
      for (final (int dx, int dy) in [(-1, -1), (0, -1), (1, -1),
                                      (-1,  0),          (1,  0),
                                      (-1,  1), (0,  1), (1,  1)]) {
        if (isOccupied(seats, x, y, dx, dy)) {
          occupied++;
        }
      }
      if (e == 'L' && occupied == 0) {
        temp.put(x, y, '#');
        changed++;
      } else if (e == '#' && occupied >= limit) {
        temp.put(x, y, 'L');
        changed++;
      } else {
        temp.put(x, y, e);
      }
    });
    seats = temp;
  }
  return seats.fold(0, (prev, x, y, e) => prev + (e == '#' ? 1: 0));
}

void main() async {
  Grid<String> seating = Grid.string(await aoc.getInputString(), (e) => e);

  int part1 = seatSimulation(seating, 4, (seats, x, y, dx, dy) {
    int nx = x + dx, ny = y + dy;
    return !seats.outOfBounds(nx, ny) && seats.at(nx, ny) == '#';
  });
  print('Part 1: $part1');

  int part2 = seatSimulation(seating, 5, (seats, x, y, dx, dy) {
    int nx = x + dx, ny = y + dy;
    while (!seats.outOfBounds(nx, ny) && seats.at(nx, ny) == '.') {
      nx += dx;
      ny += dy;
    }
    return !seats.outOfBounds(nx, ny) && seats.at(nx, ny) == '#';
  });
  print('Part 2: $part2');
}
