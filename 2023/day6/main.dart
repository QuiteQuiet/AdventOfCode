int simulate(int duration, int record) {
  int wins = 0, speed = 0;
  while (duration >= 0) {
    if (duration-- * speed++ > record) {
      wins++;
    }
  }
  return wins;
}

void main() async {
  Stopwatch time = Stopwatch()..start();
  List<(int, int)> races = [(38, 241), (94, 1549), (79, 1074), (70, 1091)];
  List<String> p2Duration = [], p2Record = [];

  int product = 1;
  for (final (duration, record) in races) {
    product *= simulate(duration, record);
    p2Duration.add(duration.toString());
    p2Record.add(record.toString());
  }
  print('Part 1: $product');
  print('Part 2: ${simulate(int.parse(p2Duration.join("")),
                            int.parse(p2Record.join("")))}');
  print('${time.elapsed}');
}