import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

void main() async {
  List<String> lines = await aoc.getInput();

  RegExp digits = RegExp(r'\d+');
  bool hasOnlyStrings(List<String> l) => !l.any((e) => digits.hasMatch(e));

  // Translate rules into regular expressions to avoid having to implement
  // string parsing for the rules
  Map<String, List<String>> rules = {};
  List<String> toReplace = [];
  int index = 0;
  while (lines[index].isNotEmpty) {
    List<String> parts = lines[index++].split(':');
    String id = parts[0];
    rules[id] = parts[1].trim().replaceAll('"', '').split(' ');
    if (hasOnlyStrings(rules[id]!)) {
      toReplace.add(id);
    }
  }

  Set<String> known = Set.from(toReplace);
  while (toReplace.isNotEmpty) {
    String id = toReplace.removeLast();
    for (MapEntry<String, List<String>> r in rules.entries) {
      for (final (int i, String part) in r.value.indexed) {
        if (part == id) {
          String replacement = rules[id]!.join('');
          if (replacement.contains('|'))
            replacement = '($replacement)';
          r.value[i] = replacement;
        }
      }
      if (!known.contains(r.key) && hasOnlyStrings(r.value)) {
        toReplace.add(r.key);
        known.add(r.key);
      }
    }
  }

  List<String> simplifiedRules = List.filled(200, '');
  for (String k in rules.keys) {
    simplifiedRules[k.toInt()] = rules[k]!.join('');
  }

  RegExp rule0 = RegExp(simplifiedRules[0]);
  int matches = 0;
  for (String message in lines.skip(index++)) {
    String? match = rule0.stringMatch(message);
    if (match != null && match.length == message.length) {
      matches++;
    }
  }
  print('Part 1: $matches');

  // Rule 0: 8 11 -> (42 | 42 8) (42 31 | 42 11 31)
  // So lines with n 42s followed by 1..n-1 31s are valid
  RegExp rule42 = RegExp(simplifiedRules[42]);
  RegExp rule31 = RegExp(simplifiedRules[31]);

  (int, String) replaceMatches(String message, RegExp rule) {
    int count = 0;
    String? match = rule.stringMatch(message);
    while (match != null && message.startsWith(match)) {
      count++;
      message = message.replaceFirst(match, '');
      match = rule.stringMatch(message);
    }
    return (count, message);
  }

  int matches2 = 0;
  for (String message in lines.skip(index)) {
    final (int num42, String after42) = replaceMatches(message, rule42);
    final (int num31, String after31) = replaceMatches(after42, rule31);

    if (after31.isEmpty && num42 > 0 && num31 > 0 && num42 - num31 > 0)
      matches2++;
  }
  print('Part 2: $matches2');
}
