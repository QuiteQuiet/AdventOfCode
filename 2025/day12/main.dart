import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

void main() async {
  List<String> input = (await aoc.getInputString()).split('\n\n');

  List<String> possible = [];
  for (String region in input.last.split('\n')) {
    List<String> parts = region.split(': ');
    List<int> presentCount = parts[1].split(' ').map(int.parse).toList();

    int treeArea = parts[0].split('x').fold(1, (s, e) => s * e.toInt());
    // Area can fit the 9x9 sq used to represent presents
    if (treeArea >= presentCount.fold(0, (s, p) => s + p * 9)) {
      possible.add(region);
      continue;
    }
  }
  print('Part 1: ${possible.length}');
}
