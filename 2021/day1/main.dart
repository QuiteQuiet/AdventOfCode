import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

int countWindows(List<int> depths, int windowSize) {
  int total = 0, window = depths.sublist(0, windowSize).reduce((a, b) => a + b);;
  for (int i = 1; i < depths.length - (windowSize - 1); i++) {
    int next = depths.sublist(i, i + windowSize).reduce((a, b) => a + b);
    if (next > window)
      total++;
    window = next;
  }
  return total;
}

void main() async {
  List<int> depths = (await aoc.getInput()).map(int.parse).toList();

  print('Part 1: ${countWindows(depths, 1)}');
  print('Part 2: ${countWindows(depths, 3)}');
}
