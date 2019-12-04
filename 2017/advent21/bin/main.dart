import 'dart:io';

class Grid {
  List<List<String>> cells;
  Grid() {
    this.cells = new List<List<String>>();
    this.cells.addAll([
      ['.', '#', '.'],
      ['.', '.', '#'],
      ['#', '#', '#'],
    ]);
  }

  String toString() => this.cells.map((r) => r.join()).join('\n');
  int get size => (this.cells.length + this.cells[0].length) ~/ 2;

  void mutate(Map<String, List<List<String>>> replace) {
    int splitsize = this.size % 2 == 0 ? 2 : 3, parts = this.size ~/ splitsize, addto;
    List<List<String>> next = new List<List<String>>();
    for (int x = 0; x < parts; x++) {
      for (int y = 0; y < parts; y++) {
        int xi = x * splitsize, yi = y * splitsize;
        List<List<String>> sublist = this.cells.sublist(xi, xi + splitsize).map((l) => l.sublist(yi, yi + splitsize)).toList();
        sublist = replace[Grid.toId(sublist)];
        // merge sublist into next
        if (yi != 0) {
          sublist = Grid.copy(sublist);
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
    this.cells = next;
  }

  static List<List<String>> flipX(List<List<String>> l) => l.reversed.toList();
  static List<List<String>> flipY(List<List<String>> l) {
    for (int i = 0; i < l.length; i++) {
      l[i] = l[i].reversed.toList();
    }
    return l;
  }
  static List<List<String>> rotate(List<List<String>> l) {
    List<List<String>> temp = new List.generate(l.length, (i) => new List<String>(l[i].length));
    for (int i = 0; i < l.length; i++) {
      for (int j = 0; j < l[i].length; j++) {
        temp[j][i] = l[i][j];
      }
    }
    return Grid.flipX(temp);
  }
  static Iterable<List<dynamic>> copy(List<List<dynamic>> l) {
    List<List<dynamic>> temp = new List<List<dynamic>>();
    for (int i = 0; i < l.length; i++) {
      temp.add(new List<dynamic>());
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
  Map<String, List<List<String>>> replace = new Map<String, List<List<String>>>();;
  new File('advent21/input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      List<String> parts = line.split(' => ');
      List<List<String>> key = new List.from(parts[0].split('/').map((r) => r.split(''))),
        r = new List.from(parts[1].split('/').map((r) => new List.from(r.split(''))));
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
    });

    List<int> lights = new List<int>();
    for (int i = 0; i < 18; i++) {
      art.mutate(replace);
      lights.add('#'.allMatches('$art').length);
    }
    print('Part 1: ${lights[4]}');
    print('Part 2: ${lights.last}');
  });
}