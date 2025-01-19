import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  List<String> lines = await aoc.getInput();

  Map<String, Map<String, int>> ingredients = {};
  Map<String, int> seen = {}, frequency = {};

  for (String line in lines) {
    List<String> recipie = line.replaceAll(RegExp(r'[\(\),]'), '').split(' ');
    int contains = recipie.indexOf('contains');
    Set<String> alergens = {};
    if (contains > -1) {
      alergens.addAll(recipie.skip(contains + 1));
      for (String a in alergens) {
        frequency[a] ??= 1;
      }
    } else {
      contains = recipie.length;
    }

    for (String element in recipie.take(contains)) {
      seen[element] = (seen[element] ?? 0) + 1;
      ingredients[element] ??= {};
      for (String a in alergens) {
        ingredients[element]!.update(a, (v) => v + 1, ifAbsent: () => 1);
        if (ingredients[element]![a]! > frequency[a]!) {
          frequency[a] = ingredients[element]![a]!;
        }
      }
    }
  }

  Set<String> known = {};
  int instances = 0;
  for (MapEntry<String, Map<String, int>> ing in ingredients.entries) {
    for (String alergen in frequency.keys) {
      if ((ing.value[alergen] ?? 0) != frequency[alergen]!)
        ing.value.remove(alergen);
    }
    if (ing.value.isEmpty) {
      instances += seen[ing.key]!;
      known.add(ing.key);
    }
  }
  print('Part 1: $instances');

  Map<String, String> found = {};
  int allIngredients = ingredients.keys.length;
  while (known.length != allIngredients) {
    for (MapEntry<String, Map<String, int>> option in ingredients.entries) {
      if (known.contains(option)) continue;

      if (option.value.keys.length == 1) {
        known.add(option.key);
        found[option.value.keys.first] = option.key;
      } else {
        for (String f in found.keys)
          option.value.remove(f);
      }
    }
  }

  List<String> dangers = found.keys.toList()..sort();
  List<String> dangerous = List.generate(dangers.length, (i) => found[dangers[i]]!);
  print('Part 2: ${dangerous.join(',')}');
}
