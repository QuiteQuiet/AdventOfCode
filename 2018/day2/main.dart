import 'dart:math';

import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

/// Levenshtein algorithm implementation based on:
/// http://en.wikipedia.org/wiki/Levenshtein_distance#Iterative_with_two_matrix_rows
int levenshtein(String s, String t, {bool caseSensitive = true}) {
  if (!caseSensitive) {
    s = s.toLowerCase();
    t = t.toLowerCase();
  }
  if (s == t)
    return 0;
  if (s.length == 0)
    return t.length;
  if (t.length == 0)
    return s.length;

  List<int> v0 = new List<int>.filled(t.length + 1, 0);
  List<int> v1 = new List<int>.filled(t.length + 1, 0);

  for (int i = 0; i < t.length + 1; i < i++)
    v0[i] = i;

  for (int i = 0; i < s.length; i++) {
    v1[0] = i + 1;

    for (int j = 0; j < t.length; j++) {
      int cost = (s[i] == t[j]) ? 0 : 1;
      v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
    }

    for (int j = 0; j < t.length + 1; j++) {
      v0[j] = v1[j];
    }
  }

  return v1[t.length];
}

class Collection {
  late Map<String, int> items;
  Collection(List<String> chars) {
    items = {};
    for (String c in chars) {
      items[c] = (items[c] ?? 0) + 1;
    }
  }
}

void main() async {
  int twos = 0, threes = 0;
  List<String> boxes = new List.empty(growable: true);
  await aoc.getInput()
  .then((List<String> file) {
    file.forEach((String line) {
      Collection col = Collection(line.split(''));
      bool hasTwo = false, hasThree = false;
      for (int i = 0; i < line.length; i++) {
        int count = col.items[line[i]]!;
        if (count == 2) hasTwo = true;
        if (count == 3) hasThree = true;
      }
      if (hasTwo) twos++;
      if (hasThree) threes++;

      if (boxes.length == 0) {
        file.forEach((String s) {
          int d = levenshtein(line, s);
          if (d == 1) {
            for (int j = 0; j < line.length; j++) {
              if (line[j] == s[j]) {
                boxes.add(line[j]);
              }
            }
          }
        });
      }
    });

    print('Part 1: ${twos * threes}');
    print('Part 2: ${boxes.join()}');
  });
}