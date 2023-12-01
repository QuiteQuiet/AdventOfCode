import '../../intcode/computer.dart';
import 'dart:collection';

bool reverse(int a, int b) {
  if (a == 1 && b == 2) return false;
  if (a == 2 && b == 1) return false;
  if (a == 3 && b == 4) return false;
  if (a == 4 && b == 3) return false;
  return true;
}

List bfs(IntcodeComputer computer, {List start}) {
  Queue<List<int>> queue = Queue();
  List<int> oxygenloc;
  List<int> output = [0], next;
  IntcodeComputer copy = computer.copy();
  queue.addAll([[1], [2], [3], [4]]);

  while (queue.isNotEmpty) {
    output.clear();
    next = queue.removeFirst();
    copy..run(input: List.from(next), output: output)..reset();
    if (output.last == 1) {
      queue.addAll([1, 2, 3, 4].where((el) => reverse(el, next.last)).map((el) => [...next, el]));
    }
    if (output.last == 2) {
      oxygenloc = List.from(next);
    }
    copy = computer.copy();
  }
  return start == null ? oxygenloc : next;
}

void main() {
  List<String> input = '3,1033,1008,1033,1,1032,1005,1032,31,1008,1033,2,1032,1005,1032,58,1008,1033,3,1032,1005,1032,81,1008,1033,4,1032,1005,1032,104,99,102,1,1034,1039,1001,1036,0,1041,1001,1035,-1,1040,1008,1038,0,1043,102,-1,1043,1032,1,1037,1032,1042,1106,0,124,1001,1034,0,1039,1001,1036,0,1041,1001,1035,1,1040,1008,1038,0,1043,1,1037,1038,1042,1106,0,124,1001,1034,-1,1039,1008,1036,0,1041,101,0,1035,1040,1002,1038,1,1043,1001,1037,0,1042,1105,1,124,1001,1034,1,1039,1008,1036,0,1041,101,0,1035,1040,102,1,1038,1043,101,0,1037,1042,1006,1039,217,1006,1040,217,1008,1039,40,1032,1005,1032,217,1008,1040,40,1032,1005,1032,217,1008,1039,5,1032,1006,1032,165,1008,1040,33,1032,1006,1032,165,1102,2,1,1044,1106,0,224,2,1041,1043,1032,1006,1032,179,1102,1,1,1044,1105,1,224,1,1041,1043,1032,1006,1032,217,1,1042,1043,1032,1001,1032,-1,1032,1002,1032,39,1032,1,1032,1039,1032,101,-1,1032,1032,101,252,1032,211,1007,0,44,1044,1106,0,224,1102,1,0,1044,1106,0,224,1006,1044,247,1002,1039,1,1034,1001,1040,0,1035,101,0,1041,1036,1002,1043,1,1038,1002,1042,1,1037,4,1044,1105,1,0,84,9,40,28,41,90,52,26,39,35,81,12,9,28,1,68,11,25,73,16,24,68,64,5,17,2,41,90,36,41,40,53,79,14,68,21,27,2,8,6,23,58,78,99,5,21,82,34,95,7,19,87,68,47,33,76,57,21,56,58,13,42,88,30,48,69,36,96,83,86,16,69,31,27,57,27,67,21,75,13,6,98,7,47,22,82,96,68,18,90,6,13,26,55,64,30,86,13,8,71,65,39,76,92,28,32,99,26,99,12,71,67,15,63,21,94,9,8,39,78,50,16,14,71,73,29,21,91,69,1,88,69,41,94,26,10,67,24,4,23,1,93,72,39,11,53,42,55,41,89,16,66,50,58,75,28,26,55,8,26,60,84,14,33,3,89,15,21,94,3,40,70,15,18,83,27,90,63,65,62,12,6,75,96,60,39,99,43,69,23,19,43,18,84,39,20,82,93,43,20,70,64,74,36,75,89,14,91,65,4,49,36,57,41,11,71,18,29,46,56,40,93,18,13,83,7,31,63,14,45,60,67,22,40,34,31,31,55,92,10,65,40,70,65,9,38,51,18,92,49,84,52,13,98,42,37,90,20,80,17,47,81,92,39,90,46,19,6,28,47,32,17,72,26,62,85,31,5,67,1,22,66,43,77,5,81,39,59,19,98,10,73,89,20,80,23,37,68,6,76,2,99,24,14,71,35,54,56,32,80,95,10,76,80,9,32,54,98,56,57,24,28,87,36,68,19,53,30,84,8,11,59,38,77,4,56,37,32,32,51,9,41,51,88,90,9,23,78,11,32,12,23,9,88,96,11,43,36,52,71,2,30,73,43,1,76,4,10,91,15,53,77,33,91,40,85,71,27,92,53,34,79,39,23,60,38,54,37,91,79,39,27,33,92,25,83,86,9,74,25,47,78,21,74,31,41,63,43,75,47,19,69,15,34,62,58,23,67,92,19,4,80,49,8,73,79,20,13,34,39,88,31,55,64,35,39,76,65,35,20,45,6,89,72,60,40,9,73,35,91,54,30,24,60,3,86,11,18,83,25,2,10,50,82,29,59,88,43,16,88,21,13,10,51,90,4,92,37,19,91,74,31,86,33,64,89,91,15,51,3,30,54,36,2,11,76,15,57,35,64,80,2,7,67,11,31,35,60,82,32,96,20,17,71,1,69,97,72,26,63,34,81,21,83,9,88,16,14,94,99,63,17,73,40,55,64,24,49,86,43,81,71,18,99,47,1,11,25,78,51,76,81,5,41,88,41,51,18,95,15,77,10,53,28,7,68,43,72,18,25,83,53,54,6,97,15,18,67,73,10,28,14,88,35,99,18,76,2,12,45,37,84,76,32,32,2,12,69,24,18,31,76,55,43,97,53,25,54,85,28,9,5,38,65,48,96,35,5,89,1,72,58,43,11,18,54,15,74,58,32,74,23,79,56,39,96,93,39,87,75,14,25,11,73,93,34,35,52,34,53,85,7,91,28,70,32,68,94,66,32,52,12,19,9,75,99,11,73,32,94,39,63,39,28,63,39,22,67,3,73,54,39,17,81,16,62,71,74,6,12,81,3,13,6,56,43,41,18,13,99,90,13,25,26,89,6,76,82,6,9,72,23,68,95,25,56,65,39,54,7,70,57,23,34,97,21,5,53,17,71,26,97,67,9,86,90,98,38,49,27,62,79,26,50,37,66,1,96,25,89,26,98,53,55,4,80,18,57,37,73,27,57,13,82,54,50,11,56,57,84,12,88,43,84,24,51,17,76,13,46,0,0,21,21,1,10,1,0,0,0,0,0,0'.split(',');
  IntcodeComputer computer = IntcodeComputer(input)..alloc(1000);
  Stopwatch time = Stopwatch()..start();
  List<int> oxygenloc = bfs(computer);
  print('Part 1: ${oxygenloc.length} ${time.elapsed}');
  computer.run(input: List.from(oxygenloc), output: []);
  print('Part 2: ${bfs(computer, start: oxygenloc).length - 1} ${time.elapsed}');
}