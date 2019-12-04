import 'dart:io';
import 'package:queries/collections.dart';
import 'package:edit_distance/edit_distance.dart';

void main() async {
  int twos = 0, threes = 0;
  List<String> boxes = new List();
  Levenshtein levenshtein = new Levenshtein();
  await new File('input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      Collection col = Collection(line.split(''));
      bool hasTwo = false, hasThree = false;
      for (int i = 0; i < line.length; i++) {
        int count = col.count((e) => e == line[i]);
        if (count == 2) hasTwo = true;
        if (count == 3) hasThree = true;
      }
      if (hasTwo) twos++;
      if (hasThree) threes++;

      if (boxes.length == 0) {
        file.forEach((String s) {
          int d = levenshtein.distance(line, s);
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