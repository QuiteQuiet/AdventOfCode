import 'package:quiver/iterables.dart';
import '../../intcode/computer.dart';

class Dir {
  final String _value;
  const Dir._internal(this._value);
  toString() => 'Enum.$_value';

  static const Up = const Dir._internal('Up');
  static const Down = const Dir._internal('Down');
  static const Left = const Dir._internal('Left');
  static const Right = const Dir._internal('Right');
  static const List<Dir> Order = [Up, Left, Down, Right];
}

class Painter {
  int x, y, i;
  Dir dir;
  Painter(this.x, this.y, [this.dir=Dir.Up]) { i = Dir.Order.indexOf(dir); }
  String get pos => '$x,$y';
  int move() {
    switch(dir) {
      case Dir.Up: return x--;
      case Dir.Down: return x++;
      case Dir.Left: return y--;
      case Dir.Right: return y++;
    }
    throw Exception('Illegal Access');
  }
  void rotate(int d) {
    if (d == 0) {
      if (i + 1 >= Dir.Order.length) i -= Dir.Order.length;
      dir = Dir.Order[++i];
    } else {
      if (i <= 0) i += Dir.Order.length;
      dir = Dir.Order[--i];
    }
  }
}

Map<int, List<Set>> paint(List<String> input, int start) {
  Set<String> white = {}, black = {};
  List<int> enter = [start], output = [];
  int firstTimePainted = 1;
  Painter robot = Painter(0, 0);
  String pos = robot.pos;
  IntcodeComputer computer = IntcodeComputer(input, resets: false)..alloc(1000);

  do {
    computer.run(input: enter, output: output);
    int dir = output.removeLast(), color = output.removeLast();

    if (color == 0) {
      black.add(pos);
      white.remove(pos);
    } else {
      white.add(pos);
      black.remove(pos);
    }
    robot.rotate(dir);
    robot.move();

    pos = robot.pos;
    enter = [0];
    if (white.contains(pos)) {
      enter = [1];
    } else if (!black.contains(pos)) {
      firstTimePainted++;
    }
  } while (!computer.done);
  return {firstTimePainted: [white, black]};
}

void main() {
  List<String> input = '3,8,1005,8,320,1106,0,11,0,0,0,104,1,104,0,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,102,1,8,29,2,1005,1,10,1006,0,11,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,102,1,8,57,1,8,15,10,1006,0,79,1,6,3,10,3,8,102,-1,8,10,101,1,10,10,4,10,108,0,8,10,4,10,101,0,8,90,2,103,18,10,1006,0,3,2,105,14,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,101,0,8,123,2,9,2,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,1,10,4,10,1001,8,0,150,1,2,2,10,2,1009,6,10,1,1006,12,10,1006,0,81,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,1,10,4,10,102,1,8,187,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,101,0,8,209,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,1,10,4,10,101,0,8,231,1,1008,11,10,1,1001,4,10,2,1104,18,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,264,1,8,14,10,1006,0,36,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,101,0,8,293,1006,0,80,1006,0,68,101,1,9,9,1007,9,960,10,1005,10,15,99,109,642,104,0,104,1,21102,1,846914232732,1,21102,1,337,0,1105,1,441,21102,1,387512115980,1,21101,348,0,0,1106,0,441,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,209533824219,1,1,21102,1,395,0,1106,0,441,21101,0,21477985303,1,21102,406,1,0,1106,0,441,3,10,104,0,104,0,3,10,104,0,104,0,21101,868494234468,0,1,21101,429,0,0,1106,0,441,21102,838429471080,1,1,21102,1,440,0,1106,0,441,99,109,2,21201,-1,0,1,21101,0,40,2,21102,472,1,3,21101,0,462,0,1106,0,505,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,467,468,483,4,0,1001,467,1,467,108,4,467,10,1006,10,499,1102,1,0,467,109,-2,2106,0,0,0,109,4,2101,0,-1,504,1207,-3,0,10,1006,10,522,21101,0,0,-3,21202,-3,1,1,22101,0,-2,2,21102,1,1,3,21102,541,1,0,1106,0,546,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,569,2207,-4,-2,10,1006,10,569,22102,1,-4,-4,1105,1,637,22102,1,-4,1,21201,-3,-1,2,21202,-2,2,3,21102,588,1,0,1105,1,546,22101,0,1,-4,21102,1,1,-1,2207,-4,-2,10,1006,10,607,21101,0,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,629,21201,-1,0,1,21102,629,1,0,105,1,504,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0'.split(',');

  print('Part 1: ${paint(input, 0).keys.first}');
  Set<String> whites = paint(input, 1).values.first[0];
  List<List<int>> pos = whites.map((el) => el.split(',').map(int.parse).toList()).toList();
  int width = 40, height = 6, x = 0, y = 0;
  List<String> plate = List.generate(width * height, (i) => ' ');
  for (List<int> point in pos) {
    plate[(x + point[0]) * width + y + point[1]] = '#';
  }
  print('Part 2: \n${partition(plate, width).map((el) => el.join('')).join('\n')}');
}