void main() {
  Stopwatch time = new Stopwatch()..start();
  int input = 349, pos = 0;
  List<int> buffer = new List<int>();
  buffer.add(0);
  for (int i = 0; i < 2017; i++) {
    pos = (pos + input) % buffer.length + 1;
    buffer.insert(pos, i + 1);
  }
  print('Part 1: ${buffer[buffer.indexOf(2017) + 1]}');
  int after = buffer[1];
  for (int i = 2018; i < 50000001; i++) {
    pos = (pos + input) % i + 1;
    if (pos == 1) after = i;
  }
  print('Part 2: $after');
}