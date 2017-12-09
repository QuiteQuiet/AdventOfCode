import 'dart:io';
import 'dart:collection';

main() async {
  int score = 0, garbage = 0;
  Queue<String> stack = new Queue<String>();
  await new File('advent9/input.txt').readAsLines()
  .then((List<String> file) {
    // clean up the input so no ignore characters or garbage is there
    String line = file[0].replaceAll(new RegExp(r'\!.'), '');
    line =  line.replaceAllMapped(new RegExp('<.*?>'), (Match m) {
      garbage += m.group(0).length - 2;
      return '';
    });

    // now the input contains only groups that are valid and not garbage
    int cumulativeGroupScore = 0;
    for (int i = 0; i < line.length; i++) {
      if (line[i] == '{') {
        stack.addFirst(line[i]);
        cumulativeGroupScore++;
      } else if (line[i] == '}') {
        stack.removeFirst();
        score += cumulativeGroupScore--;
      }
    }
  });
  print('Part 1: $score');
  print('Part 2: $garbage');
}