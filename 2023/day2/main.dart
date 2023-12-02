import 'dart:io';
import 'dart:math';

dynamic convert(String s) => int.tryParse(s) ?? s;

void main() async {
  List<String> lines = await File('input.txt').readAsLines();
  const int maxRed = 12, maxGreen = 13, maxBlue = 14;
  int possibleSum = 0, powerSum = 0;
  for (String line in lines) {
    List<List<dynamic>> parts = RegExp(r'(\w+) (\w+)').allMatches(line).map(
    (e) => [convert(e.group(1)!), convert(e.group(2)!)]).toList();

    int red = 0, green = 0, blue = 0, game = parts.removeAt(0)[1];
    parts.forEach((element) => switch (element) {
        [int c, 'red'] => red = max(c, red),
        [int c, 'green'] => green = max(c, green),
        [int c, 'blue'] => blue = max(c, blue),
        _ => print,
      });
    if (red <= maxRed && green <= maxGreen && blue <= maxBlue) {
      possibleSum += game;
    }
    powerSum += red * blue * green;
  }
  print('Part 1: $possibleSum');
  print('Part 2: $powerSum');
}