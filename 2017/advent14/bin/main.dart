class Node {
  int x, y;
  Node(this.x, this.y);
}

List<int> getHash(List<int> input) {
  input.addAll([17, 31, 73, 47, 23]);
  int current = 0, skip = 0;
  List<int> data = new List<int>.generate(256, (i) => i++);
  for (int count = 0; count < 64; count++) {
    for (int next in input) {
      for (int i = 0; i < next ~/ 2; i++) {
        int cur = (current + i) % data.length, temp = data[cur], swapTo = (current + next - i - 1) % data.length;
        data[cur] = data[swapTo];
        data[swapTo] = temp;
      }
      current = (current + next + skip) % data.length;
      skip++;
    }
  }
  List<int> dense = new List<int>.empty(growable: true);
  for (int i = 0; i < data.length; i += 16) {
    dense.add(data.sublist(i, i + 16).reduce((a, b) => a ^ b));
  }
  return dense;
}

void main() {
  String input = 'ffayrhll';
  List<List<String>> disk = new List<List<String>>.empty(growable: true);
  int count = 0;
  for (int i = 0; i < 128; i++) {
    List<String> hashbits = new List<String>.empty(growable: true);
    getHash(input.runes.toList()..add(45)..addAll('$i'.runes)).forEach((i) => hashbits.add(i.toRadixString(2).padLeft(8, '0')));
    String hash = hashbits.join();
    count += '1'.allMatches(hash).length;
    disk.add(hash.split(''));
  }
  int groups = 0;
  List<Node> explore = new List<Node>.empty(growable: true);
  for (int i = 0; i < disk.length; i++) {
    for (int j = 0; j < disk[i].length; j++) {
      if (disk[i][j] != '1') continue;
      int x = i, y = j;
      groups++;
      explore.add(new Node(x, y));
      while (explore.length > 0) {
        Node next = explore.removeAt(0);
        disk[next.x][next.y] = '-';
        if (next.x < 127 && disk[next.x + 1][next.y] == '1') explore.add(new Node(next.x + 1, next.y));
        if (next.x > 0 && disk[next.x - 1][next.y] == '1') explore.add(new Node(next.x - 1, next.y));
        if (next.y < 127 && disk[next.x][next.y + 1] == '1') explore.add(new Node(next.x, next.y + 1));
        if (next.y > 0 && disk[next.x][next.y - 1] == '1') explore.add(new Node(next.x, next.y - 1));
      }
    }
  }
  print('Part 1: $count');
  print('Part 2: $groups');
}