import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

bool solve(int sum, List<int> equation, int target, List<String> operations)
{
  if (sum == target) {
    return true;
  }
  if (equation.isEmpty || equation.first > target) {
    return false;
  }

  int first = equation.removeLast();
  for (String op in operations) {
    if (switch (op) {
      '+' => solve(sum + first, List.from(equation), target, operations),
      '*' => solve(sum * first, List.from(equation), target, operations),
      '|' => solve('$sum$first'.toInt(), List.from(equation), target, operations),
      _ => false,
    }) {
      return true;
    }
  }
  return false;
}

void main() async {
  Iterable<List<int>> equations = (await aoc.getInput()).map((e) => List.from(e.numbers().reversed));
  List<String> operations = ['+', '*', '|'];

  int sum1 = 0, sum2 = 0;
  for (List<int> equation in equations) {
    int result = equation.removeLast();
    if (solve(0, List.from(equation), result, operations.sublist(0, 2))) {
      sum1 += result;
    }
    else if (solve(0, List.from(equation), result, operations)) {
      sum2 += result;
    }
  }
  print('Part 1: $sum1');
  print('Part 2: ${sum1 + sum2}');
}