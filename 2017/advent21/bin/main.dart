import 'dart:io';

class Grid {
  late List<List<String>> cells;
  Grid() {
    this.cells = new List<List<String>>.empty(growable: true);
    this.cells.addAll([
      ['.', '#', '.'],
      ['.', '.', '#'],
      ['#', '#', '#'],
    ]);
  }

  String toString() => cells.map((r) => r.join()).join('\n');
  int get size => (cells.length + cells[0].length) ~/ 2;

  void mutate(Map<String, List<List<String>>> replace) {
    int splitsize = size % 2 == 0 ? 2 : 3, parts = size ~/ splitsize, addto = 0;
    List<List<String>> next = new List<List<String>>.empty(growable: true);
    for (int x = 0; x < parts; x++) {
      for (int y = 0; y < parts; y++) {
        int xi = x * splitsize, yi = y * splitsize;
        List<List<String>> sublist = cells.sublist(xi, xi + splitsize).map((l) => l.sublist(yi, yi + splitsize)).toList();
        sublist = replace[Grid.toId(sublist)]!;
        // merge sublist into next
        if (yi != 0) {
          sublist = Grid.copy(sublist) as List<List<String>>;
          for (int ii = 0; ii < sublist.length; ii++) {
            next[addto + ii].addAll(sublist[ii]);
          }
        }
        else {
          next.addAll(Grid.copy(sublist));
          addto = next.length - sublist.length;
        }
      }
    }
    cells = next;
  }

  static List<List<String>> flipX(List<List<String>> l) => l.reversed.toList();
  static List<List<String>> flipY(List<List<String>> l) {
    for (int i = 0; i < l.length; i++) {
      l[i] = l[i].reversed.toList();
    }
    return l;
  }
  static List<List<String>> rotate(List<List<String>> l) {
    List<List<String>> temp = new List.generate(l.length, (i) => new List<String>.filled(l[i].length, ''));
    for (int i = 0; i < l.length; i++) {
      for (int j = 0; j < l[i].length; j++) {
        temp[j][i] = l[i][j];
      }
    }
    return Grid.flipX(temp);
  }
  static Iterable<List<String>> copy(List<List<String>> l) {
    List<List<String>> temp = new List<List<String>>.empty(growable: true);
    for (int i = 0; i < l.length; i++) {
      temp.add(new List<String>.empty(growable: true));
      for (int j = 0; j < l[i].length; j++) {
        temp[i].add(l[i][j]);
      }
    }
    return temp;
  }
  static String toId(List<List<String>> l) => l.map((r) => r.join()).join('\n');
}

main() async {
  Grid art = new Grid();
  Map<String, List<List<String>>> replace = new Map<String, List<List<String>>>();
  new File('input.txt').readAsLines()
  .then((List<String> file) {
    for (String line in file) {
      List<String> parts = line.split(' => ');
      List<List<String>> key = new List.from(
        parts[0].split('/').map((r) => r.split('')));
      List<List<String>> r = new List.from(
        parts[1].split('/').map<List<String>>(
          (r) => new List.from(r.split(''))
      ));
      List<List<List<String>>> p = [
        key,
        Grid.rotate(key),
        Grid.rotate(Grid.rotate(key)),
        Grid.rotate(Grid.rotate(Grid.rotate(key)))
      ];
      for (List<List<String>> a in p) {
        replace[Grid.toId(a)] = r;
        replace[Grid.toId(Grid.flipX(a))] = r;
        replace[Grid.toId(Grid.flipY(a))] = r;
      }
    }

    List<int> lights = new List<int>.empty(growable: true);
    for (int i = 0; i < 18; i++) {
      art.mutate(replace);
      lights.add('#'.allMatches('$art').length);
    }
    print('Part 1: ${lights[4]}');
    print('Part 2: ${lights.last}');
  });
}