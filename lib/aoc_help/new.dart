import 'dart:io';

String template = """import 'package:AdventOfCode/aoc_help/get.dart' as aoc;\r
\r
void main() async {\r
  List<String> lines = await aoc.getInput();\r
\r
}\r
""";

void main(List<String> args) async {
  String year = args[0];
  String day = 'day${args[1]}';
  String targetDir = '$year/$day';

  Directory directory = await Directory(targetDir).create(recursive: true);
  await File('$targetDir/main.dart').writeAsString(template);
  print('Created ${directory.path}');
}