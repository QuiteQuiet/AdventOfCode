import 'dart:io';

class Layer {
  late int depth, range;
  Layer({this.depth = 0, this.range = 0, Iterable<int>? data = null}) {
    if (data!.length > 0) {
      this.depth = data.first;
      this.range = data.last;
    }
  }
  int pos(int time) => (this.depth + time) % ((this.range - 1) * 2);
}

main() async {
  List<Layer> firewall = new List<Layer>.empty(growable: true);
  int severity = 0, i;
  bool gotCaught = true;
  new File('input.txt').readAsLines()
  .then((List<String> file) {
    firewall = file.map((String line) => new Layer(data: line.split(': ').map(int.parse))).toList();
    for (i = 0; gotCaught; i++) {
      gotCaught = false;
      for (Layer next in firewall) {
        // entering this layer
        if (next.pos(i) == 0) {
          gotCaught = true;
          if (i == 0) severity += next.depth * next.range;
          else break;
        }
      }
    }
    print('Part 1: $severity');
    print('Part 2: ${i - 1}');
  });
}