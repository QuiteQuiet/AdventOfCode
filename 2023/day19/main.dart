import 'dart:io';

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
  List<String> input = await File('input.txt').readAsLines();

  List<String> workflows = input.sublist(0, input.indexOf(''));
  List<String> parts = input.sublist(input.indexOf('') + 1);

  Map<String, List<({String cat, int v, String i, Function f, String next})>> process = {};
  for (String w in workflows) {
    String name = w.substring(0, w.indexOf('{'));
    List<String> bins = w.replaceFirst('}', '').split('{')[1].split(',');

    process[name] = [];
    for (String bin in bins) {
      switch (bin.split(':')) {
        case [String instr, String bin]:
          int value = int.parse(instr.substring(2));
          if (instr[1] == '>') {
            process[name]!.add((cat: instr[0], v: value, i: instr[1], next: bin, f: (e) => e.xmas[instr[0]].$1 > value));
          } else {
            process[name]!.add((cat: instr[0], v: value, i: instr[1], next: bin, f: (e) => e.xmas[instr[0]].$2 < value));
          }
        case [String bin]:
          process[name]!.add((cat: '', v: 0, i: '', f: (e) => true, next: bin));
      }
    }
  }

  int work(String curBin, Part piece) {
    if (curBin == 'R') return 0;
    if (curBin == 'A') return piece.value;

    int sum = 0;
    for (var rule in process[curBin]!) {
      if (piece.range) {
        if (rule.f(piece)) {
          sum += work(rule.next, piece);
        } else {
          Part truth = Part.copy(piece);
          if (rule.i == '<') {
            truth.xmas[rule.cat] = (truth.xmas[rule.cat]!.$1 , rule.v - 1);
            piece.xmas[rule.cat] = (rule.v, piece.xmas[rule.cat]!.$2);
          } else if (rule.i == '>') {
            piece.xmas[rule.cat] = (piece.xmas[rule.cat]!.$1 , rule.v);
            truth.xmas[rule.cat] = (rule.v + 1, truth.xmas[rule.cat]!.$2);
          }
          sum += work(rule.next, truth);
        }
      } else if (rule.f(piece)) {
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