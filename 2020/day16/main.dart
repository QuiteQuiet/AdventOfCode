import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/int.dart';
import 'package:AdventOfCode/string.dart';

Set<int> possibleField(int x, List<List<(int, int)>> fields) {
  Set<int> options = {};
  for (final (int i, List<(int, int)> field) in fields.indexed)
    for (final (int l, int h) in field)
      if (l <= x && x <= h)
        options.add(i);
  return options;
}

void main() async {
  List<String> lines = await aoc.getInput();

  int index = 0;
  List<List<(int, int)>> fields = [];
  while (lines[index].isNotEmpty) {
    List<int> numbers = lines[index++].numbers();
    fields.add([(numbers[0], numbers[1].abs()), (numbers[2], numbers[3].abs())]);
  }
  List<int> myTicket = lines[index += 2].numbers();

  index += 3;
  List<List<int>> otherTickets = [];
  while (index < lines.length)
    otherTickets.add(lines[index++].numbers());

  List<List<Set<int>>> validTickets = [];
  int invalidFields = 0;
  for (List<int> ticket in otherTickets) {
    List<Set<int>> valid = [];
    for (int f in ticket) {
      Set<int> options = possibleField(f, fields);
      if (options.isEmpty)
        invalidFields += f;
      else
        valid.add(options);
    }
    if (valid.length == myTicket.length) {
      validTickets.add(valid);
    }
  }
  print('Part 1: $invalidFields');

  List<Set<int>> validIndexes = List.generate(myTicket.length, (_) => {});
  for (int i in 0.to(myTicket.length - 1))
    for (int opt in validTickets.first[i])
      if (validTickets.every((e) => e[i].contains(opt)))
        validIndexes[i].add(opt);

  List<int> solution = List.filled(myTicket.length, -1);
  while (validIndexes.any((e) => e.length > 0)) {
    (int, Set<int>) solved = validIndexes.indexed.firstWhere((e) => e.$2.length == 1);
    int index = solved.$2.first;
    solution[index] = solved.$1;
    validIndexes.forEach((e) => e.remove(index));
  }

  print('Part 2: ${solution.sublist(0, 6).fold<int>(1, (s, e) => s * myTicket[e])}');
}
