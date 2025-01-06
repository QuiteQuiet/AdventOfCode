import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/int.dart';

void main() async {
  List<String> lines = await aoc.getInput();

  List<int> ids = [];
  for (String line in lines) {
    int rLow = 0, rHigh = 128, cLow = 0, cHigh = 8;
    for (int i in 0.to(9)) {
      switch (line[i]) {
        case 'F': rHigh = (rLow + rHigh) ~/ 2;
        case 'B': rLow = (rLow + rHigh) ~/ 2;
        case 'L': cHigh = (cLow + cHigh) ~/ 2;
        case 'R': cLow = (cLow + cHigh) ~/ 2;
      }
    }
    ids.add(rLow * 8 + cLow);
  }
  print('Part 1: ${(ids..sort()).last}');
  print('Part 2: ${ids.indexed.firstWhere((e) => ids[e.$1 + 1] - e.$2 == 2).$2 + 1}');
}
