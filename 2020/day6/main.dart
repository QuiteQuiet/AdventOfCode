import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  List<String> lines = await aoc.getInput();

  List<Map<String, int>> yeses = [{}];
  List<int> participants = [0];
  for (String line in lines) {
    if (line.isNotEmpty) {
      for (String s in line.runes.map(String.fromCharCode)) {
        yeses.last.update(s, (v) => v + 1, ifAbsent: () => 1);
      }
      participants.last++;
    } else {
      yeses.add({});
      participants.add(0);
    }
  }
  print('Part 1: ${yeses.fold(0, (sum, e) => sum + e.keys.length)}');
  print('Part 2: ${yeses.indexed.fold(0, (sum, e) => sum + e.$2.values.where((v) => v == participants[e.$1]).length)}');
}
