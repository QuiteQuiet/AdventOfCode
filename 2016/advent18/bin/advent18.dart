bool isSafe(String judge) {
  if (judge == '^^.') return false;
  if (judge == '.^^') return false;
  if (judge == '^..') return false;
  if (judge == '..^') return false;
  return true;
}
main() async {
  String input = '^.....^.^^^^^.^..^^.^.......^^..^^^..^^^^..^.^^.^.^....^^...^^.^^.^...^^.^^^^..^^.....^.^...^.^.^^.^', cur, last = input;
  List<String> room = [input];
  int counter = 0, width = input.length, safe = 0, safe1 = 0;
  while (room.length < 400001) {
    cur = '';
    String test;
    for (int i = 0; i < width; i++) {
      if (i < 1) {
        test = '.${last[0]}${last[1]}';
      } else if (i >= width - 1) {
        test = '${last[i - 1]}${last[i]}.';
      } else {
        test = last.substring(i - 1, i + 2);
      }
      cur += isSafe(test) ? '.' : '^';
    }
    room.add(cur);
    safe += ".".allMatches(last).length;
    last = room[++counter];
    if (counter == 40) {
      safe1 = safe;
    }
  }
  print('Part 1: $safe1');
  print('Part 2: $safe');
}