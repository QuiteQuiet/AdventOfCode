import 'dart:io';

String template = """
import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

void main() async {
  List<String> lines = await aoc.getInput();

}
""";

void main(List<String> args) async {
  String year = args[0];
  String day = 'day${args[1]}';
  String targetDir = '$year/$day';

  Directory directory = await Directory(targetDir).create(recursive: true);
  await File('$targetDir/main.dart').writeAsString(template);
  print('Created ${directory.path}');
}