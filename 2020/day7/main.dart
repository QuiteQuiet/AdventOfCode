import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

void main() async {
  List<String> lines = await aoc.getInput();

  Map<String, Map<String, int>> bags = {};
  for (String line in lines) {
    List<String> parts = line.split(' bags contain ');
    bags[parts[0]] = {};
    if (parts[1].startsWith('no')) continue;
    for (String colour in parts[1].split(',')) {
      List<String> d = colour.trim().split(' ');
      bags[parts[0]]!['${d[1]} ${d[2]}'] = d[0].toInt();
    }
  }

  Set<String> possibleBags(String bag) {
    Set<String> valid = {};
    for (String colour in bags.keys.where((e) => bags[e]!.containsKey(bag)))
      valid..add(colour)..addAll(possibleBags(colour));
    return valid;
  }
  print('Part 1: ${possibleBags('shiny gold').length}');

  int bagsRequired(String bag) {
    int toBuy = 1;
    for (String req in bags[bag]!.keys) {
      toBuy += bags[bag]![req]! * bagsRequired(req);
    }
    return toBuy;
  }
  print('Part 2: ${bagsRequired('shiny gold') - 1}');
}
