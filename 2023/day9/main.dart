import 'dart:io';

List<int> extrapolate(List<int> row, Function(List<int>, List<int>) calcNext) {
  List<List<int>> folds = [List.from(row)];
  while (!folds.last.every((e) => e == 0)) {
    List<int> next = [];
    for (int i = 0; i < folds.last.length - 1; i++)
      next.add(folds.last[i + 1] - folds.last[i]);
    folds.add(next);
  }

  folds.last.add(0);
  for (int i = folds.length - 1; i >= 1; i--) {
    int val = calcNext(folds[i - 1], folds[i]);
    folds[i - 1].add(val);
    folds[i - 1].insert(0, val);
  }
  return [folds[0].first, folds[0].last];
}

void main() async {
  List<List<int>> lines = (await File('input.txt').readAsLines()).map(
    (e) => e.split(' ').map(int.parse).toList()).toList();

  int part1 = 0, part2 = 0;
  for (List<int> seq in lines) {
    part1 += extrapolate(seq, (a, b) => a.last + b.last).last;
    part2 += extrapolate(seq, (a, b) => a.first - b.first).first;
  }
  print('Part 1: $part1');
  print('Part 2: $part2');
}