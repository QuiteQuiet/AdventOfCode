import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/int.dart';

void main() async {
  List<List<int>> ranges = (await aoc.getInputString()).split(',').map(
    (e) => e.split('-').map(int.parse).toList()
  ).toList();

  RegExp p1 = RegExp(r'^(\d+)\1$'),
         p2 = RegExp(r'^(\d+)\1+$');
  int invalid1 = 0, invalid2 = 0;
  for (List<int> range in ranges) {
    for (int e in range[0].to(range[1])) {
      String number = e.toString();
      if (p1.hasMatch(number)) {
          invalid1 += e;
      }
      if (p2.hasMatch(number)) {
          invalid2 += e;
      }
    }
  }
  print('Part 1: ${invalid1}');
  print('Part 2: ${invalid2}');
}
