import 'dart:io';
main() async {
  Map<int, List<int>> dir = {68:[1,0],76:[0,-1],82:[0,1],85:[-1,0]};
  List<List<String>> pad2 = [['-','-','1','-','-'],['-','2','3','4','-'],['5','6','7','8','9'],['-','A','B','C','-'],['-','-','D','-','-']];
  List<int> locP1 = [1, 1], locP2 = [2, 0];
  List<String> keysP1 = new List(), keysP2 = new List();
  await new File('input.txt').readAsLines()
  .then((List<String> file) => file.forEach((String line) {
    line.runes.forEach((int c) {
      // Part 1
      locP1[0] += (locP1[0] + dir[c][0] < 0 || locP1[0] + dir[c][0] > 2 ? 0 : dir[c][0]);
      locP1[1] += (locP1[1] + dir[c][1] < 0 || locP1[1] + dir[c][1] > 2 ? 0 : dir[c][1]);
      // Part 2
      int x = locP2[0] + dir[c][0], y = locP2[1] + dir[c][1];
      x = x < 0 ? 0 : x > 4 ? 4 : x;
      y = y < 0 ? 0 : y > 4 ? 4 : y;
      if (pad2[x][y] != '-') {
        locP2[0] = x;
        locP2[1] = y;
      }
    });
    keysP1.add('${locP1[0] * 3 + locP1[1] + 1}');
    keysP2.add(pad2[locP2[0]][locP2[1]]);
  }));
  print('Part 1: ${keysP1.join('')}');
  print('Part 2: ${keysP2.join('')}');
}
