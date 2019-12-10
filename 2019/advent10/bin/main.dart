import 'dart:io';
import 'dart:math' as math;

List<String> input = File('input.txt').readAsLinesSync();

Map<num, List<int>> getLineOfSight(int x, int y) {
  Map<num, List<int>> slopes = {};
  for (int i = 0; i < input.length; i++) {
    for (int ii = 0; ii < input[i].length; ii++) {
      if (input[ii][i] == '.' || (x == i && y == ii)) continue;
      num slope = math.atan2(x - i, y - ii);
      if (slopes.containsKey(slope)) {
        // measure euclidean distance
        List<int> old = slopes[slope];
        num d1 = math.sqrt(math.pow(i - x, 2) + math.pow(ii - y, 2));
        num d2 = math.sqrt(math.pow(old[0] - x, 2) + math.pow(old[1] - y, 2));
        if (d1 < d2) {
          slopes[slope] = [i, ii];
        }
      } else {
        slopes[slope] = [i, ii];
      }
    }
  }
  return slopes;
}

void main() {
  int bestx, besty, los = 0;
  for (int y = 0; y < input.length; y++) {
    for (int x = 0; x < input[y].length; x++) {
      if (input[y][x] == '.') continue;
      int count = getLineOfSight(x, y).keys.length;
      if (count > los) {
        los = count;
        bestx = x;
        besty = y;
      }
    }
  }
  print('Part 1: $bestx,$besty: ${los}');

  Map<num, List<int>> lineOfSight = getLineOfSight(bestx, besty);
  List<num> sorted = lineOfSight.keys.toList()..sort();
  int index = sorted.indexOf(0.0) + 1;
  sorted = (sorted.sublist(index)..addAll(sorted.sublist(0, index))).reversed.toList();
  List<int> target = lineOfSight[sorted[199]]; // asteriod index 200 to be destroyed
  print('Part 2: ${target[0] * 100 + target[1]}');
}