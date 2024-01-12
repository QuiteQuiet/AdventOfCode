import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

class Part {
  Map<String, (int, int)> xmas = {};
  bool range = true;
  Part.single(int x, int m, int a, int s) {
    xmas['x'] = (x, x);
    xmas['m'] = (m, m);
    xmas['a'] = (a, a);
    xmas['s'] = (s, s);
    range = false;
  }
  Part.range(int xs, int xe,
             int ms, int me,
             int as, int ae,
             int ss, int se) {
    xmas['x'] = (xs, xe);
    xmas['m'] = (ms, me);
    xmas['a'] = (as, ae);
    xmas['s'] = (ss, se);
  }
  Part.copy(Part p): this.range(p.xmas['x']!.$1, p.xmas['x']!.$2,
                                p.xmas['m']!.$1, p.xmas['m']!.$2,
                                p.xmas['a']!.$1, p.xmas['a']!.$2,
                                p.xmas['s']!.$1, p.xmas['s']!.$2);
  int get value => range ? xmas.values.fold(1, (a, b) => a * (1 + b.$2 - b.$1)) : xmas.values.fold(0, (a, b) => a + b.$1);
}


void main() async {
  List<String> input = await aoc.getInput();

  List<String> workflows = input.sublist(0, input.indexOf(''));
  List<String> parts = input.sublist(input.indexOf('') + 1);

  Map<String, List<({String cat, String next, Function check, Function split})>> process = {};
  for (String w in workflows) {
    String name = w.substring(0, w.indexOf('{'));
    List<String> bins = w.replaceFirst('}', '').split('{')[1].split(',');

    process[name] = [];
    for (String bin in bins) {
      switch (bin.split(':')) {
        case [String instr, String bin]:
          int value = int.parse(instr.substring(2));
          String param = instr[0];
          if (instr[1] == '>') {
            process[name]!.add((cat: param, next: bin, check: (e) => e.xmas[param].$1 > value,
                                split: (e) => ((value + 1, e.xmas[param].$2), (e.xmas[param].$1, value))));
          } else {
            process[name]!.add((cat: param, next: bin, check: (e) => e.xmas[param].$2 < value,
                                split: (e) => ((e.xmas[param].$1, value - 1), (value, e.xmas[param].$2))));
          }
        case [String bin]:
          process[name]!.add((cat: '', next: bin, check: (_) => true, split: (_) => null));
      }
    }
  }

  int work(String curBin, Part piece) {
    if (curBin == 'R') return 0;
    if (curBin == 'A') return piece.value;

    int sum = 0;
    for (var rule in process[curBin]!) {
      if (piece.range) {
        if (rule.check(piece)) {
          sum += work(rule.next, piece);
        } else {
          Part valid = Part.copy(piece);
          final newRanges = rule.split(piece);
          valid.xmas[rule.cat] = newRanges.$1;
          piece.xmas[rule.cat] = newRanges.$2;
          sum += work(rule.next, valid);
        }
      } else if (rule.check(piece)) {
        return work(rule.next, piece);
      }
    }
    return sum;
  }

  int done = 0;
  for (String part in parts) {
    List<int> params = part.substring(1, part.length - 1).split(',').map(
      (e) => int.parse(e.split('=')[1])).toList();
    done += work('in', Part.single(params[0], params[1], params[2], params[3]));
  }
  print('Part 1: $done');
  print('Part 2: ${work("in", Part.range(1, 4000, 1, 4000, 1, 4000, 1, 4000))}');
}