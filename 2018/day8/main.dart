import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/int.dart';

(int, int, int) getMetaData(List<int> input, int index) {
  int metadata = 0;
  int value = 0;
  int subnodes = input[index++];
  int metaEntries = input[index++];

  List<int> values = [-1];
  for (int _ in 0.to(subnodes - 1)) {
    (int, int, int) ret = getMetaData(input, index);
    index = ret.$1;
    metadata += ret.$2;
    values.add(ret.$3);
  }

  int sum = 0;
  for (int i = index; i < index + metaEntries; i++) {
    sum += input[i];
    if (input[i] < values.length) {
      value += values[input[i]];
    }
  }
  if (subnodes == 0) {
    value = sum;
  }
  index += metaEntries;
  metadata += sum;

  return (index, metadata, value);
}

void main() async {
  List<int> input = (await aoc.getInputString()).split(' ').map(int.parse).toList();

  (int, int, int) result = getMetaData(input, 0);
  print('Part 1: ${result.$2}');
  print('Part 2: ${result.$3}');
}