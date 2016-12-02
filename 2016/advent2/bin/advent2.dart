import 'dart:io';
import 'dart:math';
main() async {
  Map<int, List<int>> dir = {68:[1,0],76:[0,-1],82:[0,1],85:[-1,0]};
  List<List<String>> pad2 = [['-','-','1','-','-'],['-','2','3','4','-'],['5','6','7','8','9'],['-','A','B','C','-'],['-','-','D','-','-']];
  List<int> locP1 = [1, 1], locP2 = [2, 0];
  List<String> keysP1 = new List(), keysP2 = new List();
  await new File('input.txt').readAsLines()
  .then((List<String> file) => file.forEach((String line) {
    line.runes.forEach((int c) {
      // Part 1
      locP1[0] = max(0, min(locP1[0] + dir[c][0], 2));
      locP1[1] = max(0, min(locP1[1] + dir[c][1], 2));
      // Part 2
      int x = max(0, min(locP2[0] + dir[c][0], 2)),
          y = max(0, min(locP2[1] + dir[c][1], 2));
      if (pad2[x][y] != '-') {
        locP2 = [x, y];
      }
    });
    keysP1.add('${locP1[0] * 3 + locP1[1] + 1}');
    keysP2.add(pad2[locP2[0]][locP2[1]]);
  }));
  print('Part 1: ${keysP1.join('')}');
  print('Part 2: ${keysP2.join('')}');
}
