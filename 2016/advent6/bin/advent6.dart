import 'dart:io';
main() async {
  String msg1 = '', msg2 = '', next1 = '';
  await new File('input.txt').readAsLines()
  .then((List<String> file) {
    for (int i = 0, len = file[0].length; i < len; i++) {
      int max = 0;
      Map<String, int> chars = new Map();
      file.forEach((String s) {
        chars[s[i]] = chars.containsKey(s[i]) ? chars[s[i]]! + 1 : 1;
        if (chars[s[i]]! > max) {
          max = chars[s[i]]!;
          next1 = s[i];
        }
      });
      msg1 += next1;
      List<int> counted = chars.values.toList()..sort();
      chars.forEach((String key, int value) => msg2 += value == counted[0] ? key : '');
    }
  });
  print('Part 1: $msg1');
  print('Part 2: $msg2');
}