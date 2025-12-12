import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:advance_math/advance_math.dart';
import 'package:collection/collection.dart';
import 'package:trotter/trotter.dart';

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
    Set<int> free = new List.generate(buttons, (i) => i).toSet();
    int rowIndex = 0;
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
        free.remove(index);
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
    if (free.isEmpty) {
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
      num smallest = 1000000000;
      List<int> options = List.generate(limit.toInt(), (i) => i),
                numbers = new List.filled(buttons, 0),
                freeList = free.toList();

      // TODO: This code is fairly fast except one 24s outlier that takes
      //       execution time from ~2s to ~30s. Maybe fix that one day.
      for (final amalgam in Amalgams(freeList.length, options)()) {
        for (final (int i, int a) in amalgam.indexed) {
          numbers[freeList[i]] = a;
        }

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
