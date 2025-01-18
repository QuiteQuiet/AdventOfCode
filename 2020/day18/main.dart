import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

int regularMath(List<String> math) {
  Map<String, int Function(int, int)> operations = {'+': (a, b) => a + b,
                                                    '*': (a, b) => a * b};
  int index = 0, res = math[index++].toInt();
  while (index < math.length)
    res = operations[math[index++]]!(res, math[index++].toInt());
  return res;
}

int advancedMath(List<String> math) {
  List<int> priority = [];
  for (int i = 0; i < math.length; i++) {
    if (math[i] == '+')
      priority.add(math[++i].toInt() + priority.removeLast().toInt());
    else if (math[i] != '*')
      priority.add(math[i].toInt());
  }
  return priority.fold(1, (p, e) => p * e);
}

int helpWithHomework(List<List<String>> homework, int Function(List<String>) mathSystem) {
  int sum = 0;
  List<List<String>> stack = [];
  for (List<String> line in homework) {
    stack.add([]);
    for (int index = 0; index < line.length; index++) {
      if (line[index] == '(') {
        stack.add([]);
      } else if (line[index] == ')') {
        List<String> part = stack.removeLast();
        stack.last.add(mathSystem(part).toString());
      } else {
        stack.last.add(line[index]);
      }
    }
    sum += mathSystem(stack.removeLast());
  }
  return sum;
}

void main() async {
  List<List<String>> lines = (await aoc.getInput()).map((e) => e.replaceAll(' ', '').split('')).toList();

  print('Part 1: ${helpWithHomework(lines, regularMath)}');
  print('Part 1: ${helpWithHomework(lines, advancedMath)}');
}
