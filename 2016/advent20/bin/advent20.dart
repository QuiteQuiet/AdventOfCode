import 'dart:io';
main() async {
  int first = 0, upper, total = 0;
  Stopwatch time = new Stopwatch();
  await new File('input.txt').readAsLines()
  .then((List<String> file) {
    time.start();
    List<List<int>> ips = file.map((l) => l.split('-').map(int.parse).toList()).toList()..sort((a, b) => a[0] - b[0]);
    upper = ips[0][0];
    ips.forEach((List<int> range) {
      if (range[1] < upper) return;
      if (range[0] > upper + 1) {
        total += range[0] - (upper + 1);
      }
      upper = range[1];
    });
  });
  print('Part 1: $first');
  print('Part 2: $total (elapsed: ${time.elapsed})');
}