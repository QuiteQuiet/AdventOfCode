import 'dart:io';
import 'day1/main.dart' as day1;
import 'day2/main.dart' as day2;
import 'day3/main.dart' as day3;
import 'day4/main.dart' as day4;
import 'day5/main.dart' as day5;
import 'day6/main.dart' as day6;
import 'day7/main.dart' as day7;
import 'day8/main.dart' as day8;
import 'day9/main.dart' as day9;
import 'day10/main.dart' as day10;
import 'day11/main.dart' as day11;
import 'day12/main.dart' as day12;

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
  List<Function> days = [
    day1.main, day2.main, day3.main, day4.main, day5.main, day6.main, day7.main,
    day8.main, day9.main, day10.main, day11.main, day12.main];

  Stopwatch total = Stopwatch()..start();
  for (final (int day, Function solve) in days.indexed) {
    await run('Day ${day + 1}', solve);
  }
  print('Time for all solutions: ${total.elapsed}');
}