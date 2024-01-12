import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

int extrapolate(List<int> row) {
  if (row.every((e) => e == 0))
    return 0;
  return row.last + extrapolate(List.generate(row.length - 1, (i) => row[i + 1] - row[i]));
}

void main() async {
  List<List<int>> lines = (await aoc.getInput()).map(
    (e) => e.split(' ').map(int.parse).toList()).toList();

  int part1 = 0, part2 = 0;
  for (List<int> seq in lines) {
    part1 += extrapolate(seq);
    part2 += extrapolate([...seq.reversed]);
  }
  print('Part 1: $part1');
  print('Part 2: $part2');
}