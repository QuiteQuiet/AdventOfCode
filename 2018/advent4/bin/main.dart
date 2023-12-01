import 'dart:io';

import 'dart:math';

class Guard {
  late int id, minutes = 0, fellAsleep, mostAsleepAt;
  late Map<int, int> asleep;
  Guard(this.id) { asleep = Map<int, int>(); }
}

void main() {
  List<String> input = File('input.txt').readAsLinesSync()..sort();
  Map<String, Guard> guards = Map();
  Guard active = Guard(0);
  RegExp format = RegExp(r'\[\d+-\d+-\d+ \d+:(\d+)\] (.+)'),
        guardid = RegExp(r'#(\d+)');
  File('sorted.txt').writeAsString(input.join('\n'));

  input.forEach((String entry) {
    Match match = format.firstMatch(entry)!;
    if (match.group(2)!.startsWith('Guard')) {
      String id = guardid.firstMatch(match.group(2)!)!.group(1)!;
      active = guards[id] ??= Guard(int.parse(id));
    } else if (match.group(2) == 'wakes up') {
      int awoke = int.parse(match.group(1)!);
      for (int i = active.fellAsleep; i < awoke; i++) {
        active.asleep[i] ??= 0;
        active.asleep[i] = active.asleep[i]! + 1;
      }
      active.minutes += awoke - active.fellAsleep;
    } else if (match.group(2) == 'falls asleep') {
      active.fellAsleep = int.parse(match.group(1)!);
    }
  });

  Guard sleeper = (guards.values.toList()..sort((a, b) => a.minutes - b.minutes)).last;
  int minute = sleeper.asleep.keys.fold(0, (a, b) => (sleeper.asleep[a] ?? 0) > sleeper.asleep[b]! ? a : b);
  print('Part 1: ${sleeper.id * minute}');

  sleeper = guards.values.fold(Guard(-1), (a, b) => a.asleep.values.fold(0, max) > b.asleep.values.fold(0, max) ? a : b);
  minute = sleeper.asleep.keys.fold(0, (a, b) => (sleeper.asleep[a] ?? 0) > sleeper.asleep[b]! ? a : b);
  print('Part 2: ${sleeper.id * minute}');
}