import 'dart:io';
import 'dart:math';
class Robot {
  int _number, _low, _high;
  Robot(this._number, [this._high = -1]);
  bool get Full => this._high != -1;
  int get Low => this._low;
  int get High => this._high;
  int get Number => this._number;
  void give(int val) {
    if (_low == null && _high == -1) {
      _low = val;
    } else {
      _high = max(_high, max(val, _low));
      _low = min(_low, val);   
    }
  }
  void clear() {
    _low = null;
    _high = -1;
  }
}
main() async {
  List<Robot> robots = new List.generate(210, (i) => new Robot(i));
  List<Map<String, String>> ops = new List();
  await new File('input.txt').readAsLines()
  .then((List<String> file) => file.forEach((String line) {
    if (line.startsWith('value')) {
      robots[int.parse(line.split('bot ')[1])].give(int.parse(line.substring(6).split(' goes')[0]));
    } else {
      Map<String, String> temp = new Map();
      temp['number'] = line.substring(4, line.indexOf(' ', 4));
      temp['low'] = line.substring(line.indexOf('low to ') + 7, line.indexOf(' and high'));
      temp['high'] = line.substring(line.indexOf('high to ') + 8, line.length);
      ops.add(temp);
    }
  }));
  ops.sort((a, b) => int.parse(a['number']).compareTo(int.parse(b['number'])));
  int result;
  List<int> outputs = new List();
  while (outputs.length < 3) {
    Robot next = robots.firstWhere((r) => r.Full);
    if (next.Low == 17 && next.High == 61) result = next.Number;
    String low = ops[next.Number]['low'], high = ops[next.Number]['high'];
    if (low.startsWith('bot')) {
      robots[int.parse(low.substring(4))].give(next.Low);
    }
    if (high.startsWith('bot')) {
      robots[int.parse(high.substring(4))].give(next.High);
    }
    if (low.startsWith(new RegExp(r'output [0-2]$'))) {
      outputs.add(next.Low);
    }
    next.clear();
  }
  print('Part 1: $result');
  print('Part 2: ${outputs.reduce((a, b) => a * b)}');
}