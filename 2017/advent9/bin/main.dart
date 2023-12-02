import 'dart:io';

main() async {
  int score = 0, garbage = 0;
  new File('input.txt').readAsLines()
  .then((List<String> file) {
    // clean up the input so no ignore characters or garbage is there
    String line = file[0].replaceAll(new RegExp(r'\!.'), '').replaceAllMapped(new RegExp('<.*?>'), (Match m) {
      garbage += m.group(0)!.length - 2; // solves part 2, regular `replaceAll` is enough for part 1
      return '';
    });

    // now the input contains only groups that are valid and not garbage
    int openBrackets = 0;
    for (int i = 0; i < line.length; i++) {
      if (line[i] == '{') {
        openBrackets++;
      } else if (line[i] == '}') {
        score += openBrackets--;
      }
    }
    print('Part 1: $score');
    print('Part 2: $garbage');
  });
}