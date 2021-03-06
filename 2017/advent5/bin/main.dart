import 'dart:io';

main() async {
  int instruction = 0, ops = 0;
  bool part2 = true;
  await new File('advent5/input.txt').readAsLines()
  .then((List<String> content) {
    List<int> file = new List.from(content.map(int.parse));
    for (; instruction >= 0 && instruction < file.length; ops++) {
      int old = instruction;
      instruction += file[instruction];
      file[old] += part2 && file[old] >= 3 ? -1 : 1;
    }
    print('Part ${part2 ? 2 : 1}: $ops');
  });
}