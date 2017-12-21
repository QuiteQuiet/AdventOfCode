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

  String toString() => this.cells.map((r) => r.join()).toList().join('\n');
  int get size => (this.cells.length + this.cells[0].length) ~/ 2;

  void mutate(List<List<List<String>>> patterns, List<List<List<String>>> replace) {
    int splitsize = this.size % 2 == 0 ? 2 : 3, parts = this.size ~/ splitsize, addto;
    List<List<String>> next = new List<List<String>>();
    for (int x = 0; x < parts; x++) {
      for (int y = 0; y < parts; y++) {
        int xi = x * splitsize, yi = y * splitsize;
        List<List<String>> sublist = this.cells.sublist(xi, xi + splitsize).map((l) => l.sublist(yi, yi + splitsize)).toList();
        for (int k = 0; k < patterns.length; k++) {
          List<List<String>> p = patterns[k];
          if (p.length != sublist.length) continue;
          if (Grid.compare(sublist, p)) {
            sublist = replace[k]; break;
          }
          if (Grid.compare(Grid.flipX(sublist), p)) {
            sublist = replace[k]; break;
          }
          if (Grid.compare(Grid.flipY(sublist), p)) {
            sublist = replace[k]; break;
          }
          List<List<String>> temp = Grid.rotate(sublist);
          if (Grid.compare(temp, p)) {
            sublist = replace[k]; break;
          }
          if (Grid.compare(Grid.flipX(temp), p)) {
            sublist = replace[k]; break;
          }
          if (Grid.compare(Grid.flipY(temp), p)) {
            sublist = replace[k]; break;
          }
          temp = Grid.rotate(Grid.rotate(sublist));
          if (Grid.compare(temp, p)) {
            sublist = replace[k]; break;
          }
          if (Grid.compare(Grid.flipX(temp), p)) {
            sublist = replace[k]; break;
          }
          if (Grid.compare(Grid.flipY(temp), p)) {
            sublist = replace[k]; break;
          }
          temp = Grid.rotate(Grid.rotate(Grid.rotate(sublist)));
          if (Grid.compare(temp, p)) {
            sublist = replace[k]; break;
          }
          if (Grid.compare(Grid.flipX(temp), p)) {
            sublist = replace[k]; break;
          }
          if (Grid.compare(Grid.flipY(temp), p)) {
            sublist = replace[k]; break;
          }
        }
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

  static List<List<String>> flipX(List<List<String>> l) {
    return l.reversed.toList();
  }
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

  static bool compare(List<List<String>> a, List<List<String>> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      for (int j = 0; j < a[i].length; j++) {
        if (a[i][j] != b[i][j]) return false;
      }
    }
    return true;
  }
  static List<List<String>> copy(List<List<String>> l) {
    List<List<String>> temp = new List<List<String>>();
    for (int i = 0; i < l.length; i++) {
      temp.add(new List<String>());
      for (int j = 0; j < l[i].length; j++) {
        temp[i].add(l[i][j]);
      }
    }
    return temp;
  }
}

main() async {
  Grid art = new Grid();
  List<List<List<String>>> patterns = new List<List<List<String>>>(), replace = new List<List<List<String>>>();
  new File('advent21/input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      List<String> parts = line.split(' => ');
      patterns.add(new List.from(parts[0].split('/').map((r) => r.split(''))));
      replace.add(new List.from(parts[1].split('/').map((r) => new List.from(r.split(''), growable: true))));
    });

    for (int i = 0; i < 18; i++) {
      art.mutate(patterns, replace);
      print('${i + 1}: ${"#".allMatches("$art").length}');
    }
  });
}