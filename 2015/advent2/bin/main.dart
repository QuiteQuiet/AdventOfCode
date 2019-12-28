import 'dart:io';

main() async {
  int paper = 0, ribbon = 0;
  new File('advent2/input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      List<int> dim = line.split('x').map(int.parse).toList()..sort();
      paper += 2 * (dim[0] * dim[1] + dim[0] * dim[2] + dim[1] * dim[2]) + dim[0] * dim[1];
      ribbon += 2 * dim[0] + 2 * dim[1] + dim.reduce((a, b) => a * b);
    });
    print('Part 1: $paper');
    print('Part 2: $ribbon');
  });
}
