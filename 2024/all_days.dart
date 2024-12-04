import 'dart:io';
import 'day1/main.dart' as day1;
import 'day2/main.dart' as day2;
import 'day3/main.dart' as day3;
// import 'day4/main.dart' as day4;
// import 'day5/main.dart' as day5;
// import 'day6/main.dart' as day6;
// import 'day7/main.dart' as day7;
// import 'day8/main.dart' as day8;
// import 'day9/main.dart' as day9;
// import 'day10/main.dart' as day10;
// import 'day11/main.dart' as day11;
// import 'day12/main.dart' as day12;
// import 'day13/main.dart' as day13;
// import 'day14/main.dart' as day14;
// import 'day15/main.dart' as day15;
// import 'day16/main.dart' as day16;
// import 'day17/main.dart' as day17;
// import 'day18/main.dart' as day18;
// import 'day19/main.dart' as day19;
// import 'day20/main.dart' as day20;
// import 'day21/main.dart' as day21;
// import 'day22/main.dart' as day22;
// import 'day23/main.dart' as day23;
// import 'day24/main.dart' as day24;
// import 'day25/main.dart' as day25;

Future<void> run(String day, Function f) async {
  print(day);
  Directory prev = Directory.current;
  Directory.current = new Directory(day.replaceAll(' ', '').toLowerCase());
  Stopwatch time = Stopwatch()..start();
  await f();
  Directory.current = prev;
  print('Solved in ${time.elapsed}\n');
}
void main() async {
  String cur = Platform.script.path;
  cur = cur.substring(1, cur.lastIndexOf('/'));
  Directory.current = cur;
  List<Function> days = [day1.main, day2.main, day3.main];

  Stopwatch total = Stopwatch()..start();
  for (final (int day, Function solve) in days.indexed) {
    await run('Day ${day + 1}', solve);
  }
  print('Time for all solutions: ${total.elapsed}');
}