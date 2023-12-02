import 'dart:io';

class Port {
  int i, o, weight = 0;
  Port(this.i, this.o);
  void invert() {
    int t = this.o;
    this.o = this.i;
    this.i = t;
  }
  bool operator==(covariant Port o) => this.i == o.i && this.o == o.o || this.i == o.o && this.o == o.i;
}

class Bridge {
  int last, w, len;
  late List<Port> free;
  Bridge(List<Port> l, [this.w = 0, this.last = 0, this.len = 0]) {
    this.free = new List<Port>.empty(growable: true);
    for (Port p in l) {
      this.free.add(p);
    }
  }
  void use(Port p) {
    this.free.remove(p);
    if (p.i != this.last) p.invert();
    this.len++;
    this.last = p.o;
    this.w += p.i + p.o;
  }
}

main() async {
  List<Port> options = new List<Port>.empty(growable: true);
  new File('input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String l) {
      List<int> parts = l.split('/').map(int.parse).toList()..sort();
      options.add(new Port(parts.first, parts.last));
    });
    options.sort((a, b) => a.i - b.i);
    List<Bridge> explore = new List<Bridge>.empty(growable: true);
    explore.add(new Bridge(options));
    explore.last.use(options[0]);

    int max = 0;
    Bridge longest = new Bridge([]);
    while (explore.length > 0) {
      Bridge next = explore.removeLast();
      int find = next.last;
      Iterable<Port> possible = next.free.where((Port p) => p.i == find || p.o == find);
      for (Port p in possible) {
        Bridge alt = new Bridge(next.free, next.w, next.last, next.len);
        alt.use(p);
        explore.add(alt);
        if (alt.w > max) max = alt.w;
        if (longest.len < alt.len) {
          longest = alt;
        }
        else if (longest.len == alt.len) {
          if (alt.w > longest.w) longest = alt;
        }
      }
      explore.sort((a, b) => a.w - b.w);
    }
    print('Part 1: $max');
    print('Part 2: ${longest.w}');
  });
}