import 'dart:io';
int getLength(String s) {
  if (s.length < 0) return 0;
  try {
    String match = new RegExp(r'\d+x\d+').firstMatch(s).group(0);
    List<int> m = match.split('x').map(int.parse).toList();
    int index = s.indexOf(match) + match.length + 1;
    return m[1] * getLength(s.substring(index, index + m[0])) + getLength(s.substring(index + m[0]));
  } catch(e) {
    return s.length;
  } 
}
main() async {
  String decomp = '';
  int length = 0;
  await new File('input.txt').readAsLines()
  .then((List<String> file) {
    String line = file[0];
    length = getLength(line);
    while (line.length > 0) {
      String match = new RegExp(r'\(\d+x\d+\)').firstMatch(line).group(0);
      List<int> m = match.substring(1, match.length - 1).split('x').map(int.parse).toList();
      decomp += line.substring(match.length, match.length + m[0]) * m[1];
      line = line.substring(match.length + m[0]);
    }

  });
  print('Part 1: ${decomp.replaceAll(' ', '').length}');
  print('Part 2: $length');
}