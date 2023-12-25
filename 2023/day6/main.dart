int simulate(int duration, int record) {
  int wins = 0, speed = 0;
  while (duration >= 0)
    if (duration-- * speed++ > record)
      wins++;
  return wins;
}

void main() {
  List<(int, int)> races = [(38, 241), (94, 1549), (79, 1074), (70, 1091)];
  final (int p2d, int p2r) = (38947970, 241154910741091);

  int product = 1;
  for (final (duration, record) in races) {
    product *= simulate(duration, record);
  }
  print('Part 1: $product');
  print('Part 2: ${simulate(p2d, p2r)}');
}