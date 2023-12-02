import 'dart:io';

dynamic convert(String s) => int.tryParse(s) ?? s;

void main() async {
  List<String> lines = await File('input.txt').readAsLines();
  Map<String, int> cubes = {'red': 12, 'green': 13, 'blue': 14};
  Set<int> possible = {};
  int powerSum = 0;
  for (String line in lines) {
    List<List<dynamic>> parts = RegExp(r'(\w+) (\w+)').allMatches(line).map(
      (e) => [convert(e.group(1)!), convert(e.group(2)!)]).toList();

    int game = parts.removeAt(0)[1];
    possible.add(game);
    Map<String, int> minimum = {'red': 0, 'green': 0, 'blue': 0};
    for (List<dynamic> thing in parts) {
      (int, String, int?) round = (thing[0], thing[1], cubes[thing[1]]);
      var (count, colour, inSack!) = round;
      if (count > inSack) {
        possible.remove(game);
      }
      if (count > minimum[colour]!) {
        minimum[colour] = count;
      }
    }
    powerSum += minimum.values.reduce((a, b) => a * b);
  }
  print('Part 1: ${possible.reduce((a, b) => a + b)}');
  print('Part 2: $powerSum');
}