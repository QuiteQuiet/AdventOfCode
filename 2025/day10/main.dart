import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/int.dart';
import 'package:advance_math/advance_math.dart';
import 'package:collection/collection.dart';

class Diagram {
  List<int> goal, joltages;
  List<List<int>> buttons;
  Diagram(this.goal, this.buttons, this.joltages);

  bool check(List<int> lights) {
    for (final (int i, int g) in goal.indexed)
      if (g != lights[i] % 2)
        return false;
    return true;
  }
}

class Func {
  int index;
  num constant;
  Map<int, num> weights;
  Func(this.index, this.constant, this.weights);
  num apply(List<int> x) {
    if (index != -1) return x[index];
    num value = constant;
    for (MapEntry e in weights.entries) {
      value += e.value * x[e.key];
    }
    return value;
  }
}

Iterable<Map<int, int>> generator(Map<int, List<int>> limits) sync* {
  List<int> variables = [...limits.keys.toList(), 1000, 1001]; // Pad to always have 3+ elements to take from
  variables.sort();

  int va = variables[0], vb = variables[1], vc = variables[2];
  List<int> first = limits[va]!, second = limits[vb] ?? [0, 0], third = limits[vc] ?? [0, 0];
  for (int a in first[0].to(first[1])) {
    for (int b in second[0].to(second[1])) {
      for (int c in third[0].to(third[1])) {
        yield {va: a, vb: b, vc: c};
      }
    }
  }
}

void main() async {
  RegExp indicatorsRegexp = new RegExp(r'\[(.+)]'),
         buttonRegexp = new RegExp(r'\(([0-9,]+)\)'),
         joltageRegexp = new RegExp(r'\{([0-9,]+)}');

  List<Diagram> diagrams = (await aoc.getInput()).map((e) {
    List<int> lights = indicatorsRegexp.firstMatch(e)!.group(1)!.runes.map((r) => r == 35 ? 1 : 0).toList(),
              joltages = joltageRegexp.firstMatch(e)!.group(1)!.split(',').map(int.parse).toList();
    List<List<int>> buttons = [];
    for (RegExpMatch button in buttonRegexp.allMatches(e)) {
      Set<int> active = button.group(1)!.split(',').map(int.parse).toSet();
      buttons.add(new List.generate(lights.length, (i) => active.contains(i) ? 1 : 0));
    }
    return Diagram(lights, buttons, joltages);
  }).toList();

  int sum = 0;
  for (Diagram diagram in diagrams) {
    HeapPriorityQueue<(List<int>, int)> queue = new HeapPriorityQueue((a, b) => a.$2 - b.$2);
    List<int> lights = new List.filled(diagram.goal.length, 0);
    queue.add((lights, 0));

    Set<int> visited = {};
    while (queue.isNotEmpty) {
      (List<int>, int) next = queue.removeFirst();
      int state =  next.$1.indexed.fold(0, (b, el) => b |= (el.$2 & 1) << el.$1);
      if (!visited.add(state))
        continue;

      if (diagram.check(next.$1)) {
        sum += next.$2;
        break;
      }

      for (List<int> button in diagram.buttons) {
        List<int> lights = new List.from(next.$1);
        for (int i = 0; i < lights.length; i++)
          lights[i] += button[i];
        queue.add((lights, next.$2 + 1));
      }
    }
  }
  print('Part 1: $sum');

  num buttonPresses = 0;
  for (Diagram cur in diagrams) {
    int buttons = cur.buttons.length;
    List<ColumnMatrix> c = List.generate(buttons, (i) => ColumnMatrix(cur.buttons[i]));

    c.add(ColumnMatrix(cur.joltages));
    Matrix a = Matrix.fromColumns(c);

    // Build a set of equations for calculating presses required.
    // This depends on one of more variable.
    Matrix rref = a.reducedRowEchelonForm();
    List<Func> linearFunc = [];
    int rowIndex = 0;
    Map<int, List<int>> limits = {};
    num limit = cur.joltages.reduce((a, b) => a < b ? b : a);
    for (int index = 0; index < buttons; index++) {
      if (rowIndex >= rref.length) {
        linearFunc.add(Func(index, 0, {}));
      } else if (rref[rowIndex][index] == 1) {
        num constant = rref[rowIndex].last.value; // Complex has value
        if (constant > limit) limit = constant;
        Map<int, num> weights = {};
        for (int i = 0; i < rref[rowIndex].length - 1; i++) {
          if (i > index && rref[rowIndex][i].value != 0)
            weights[i] = -rref[rowIndex][i].value;
        }
        for (int w in weights.keys) {
          limits[w] ??= [0, 0];
          num value = (constant / weights[w]!).absolute();
          if (constant > 0 && weights[w]! < 0 && limits[w]![1] < value) {
            limits[w]![1] = value.ceil();
          }
        }
        linearFunc.add(Func(-1, constant, weights));
        rowIndex++;
      } else {
        int loc = rref[rowIndex].indexOf(1);
        if (loc > index || loc == -1) {
          linearFunc.add(Func(index, 0, {}));
        }
      }
    }

    // Exactly 1 solution
    if (limits.isEmpty) {
      num presses = linearFunc.fold(0, (s, f) => s + f.apply([]));
      if (presses == 0) {
        // The linear algebra library I use for this solution don't actually
        // treat the augmented matrix correctly, so for a few (2) lines in
        // my input it ends up breaking the matrix entirely and finds no solution.
        // Luckily those have a single unique solution so their presses can
        // be found through a normal matrix inverse operation.
        Matrix Ainv = Matrix.fromColumns(c.take(c.length - 1).toList()).inverse();
        Matrix solution = Ainv * c.last;
        presses = solution.elements.reduce((a, b) => a.round() + b.round());
      }
      buttonPresses += presses;

    // Test combinations to find the smallest
    } else {
      limits.values.forEach((l) { if (l[1] == 0) l[1] = limit.ceil(); });

      num smallest = 1000000000;
      List<int> numbers = new List.filled(buttons, 0);

      for (final next in generator(limits)) {
        next.forEach((k, v) { if (k < numbers.length) numbers[k] = v; });

        List<num> result = [];
        bool valid = true;
        for (Func f in linearFunc) {
          num res = f.apply(numbers);
          num adj = (res + 0.00000001).floor(); // I hate floating points
          if (adj < 0 || res.round() != adj) {
            valid = false;
            break;
          }
          result.add(adj);
        }
        if (valid) {
          num presses = result.reduce((a, b) => a + b);
          if (smallest > presses) {
            smallest = presses;
          }
        }
      }
      buttonPresses += smallest;
    }
  }
  print('Part 2: ${buttonPresses.toInt()}');
}
