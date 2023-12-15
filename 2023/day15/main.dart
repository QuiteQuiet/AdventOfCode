import 'dart:io';

int hash(String s) => s.runes.fold(0, (s, e) => ((s + e) * 17) % 256);

void main() async {
  List<String> input = (await File('input.txt').readAsLines())[0].split(',');
  List<Map<String, int>> hashmap = List.generate(256, (i) => {});

  int current = 0;
  for (String s in input) {
    current += hash(s);

    switch (s.split('=')) {
      case [String label, String focus]:
        hashmap[hash(label)][label] = int.parse(focus);
      case [String label]:
        label = label.substring(0, label.length - 1);
        hashmap[hash(label)].remove(label);
    }
  }
  print('Part 1: $current');

  int power = 0;
  for (final (int b, Map<String, int> box) in hashmap.indexed) {
    for (final (int l, String lens) in  box.keys.indexed) {
      power += (b + 1) * (l + 1) * box[lens]!;
    }
  }
  print('Part 2: $power');
}