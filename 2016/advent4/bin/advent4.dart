import 'dart:io';
main() async {
  int sum = 0, location;
  await new File('input.txt').readAsLines()
  .then((List<String> file) => file.forEach((String line) {
    Map<String, int> chars = new Map();
    line.substring(0, line.indexOf('[')).runes.forEach((int c) {
      String char = new String.fromCharCode(c);
      if ('1234567890-['.contains(char)) return;
      chars[char] = chars.containsKey(char) ? chars[char] + 1 : 1;
    });
    String keycode = '';
    while (keycode.length < 5) {
      String max = '';
      chars.forEach((k, v) {
        if (max == '') max = k;
        if (chars[max] < chars[k]) {
          max = k;
        } else if (chars[max] == chars[k]) {
          max = max.compareTo(k) < 0 ? max : k;
        }
      });
      keycode += max;
      chars.remove(max);
    }
    int index = line.indexOf('[') + 1;
    String checksum = line.substring(index, index + 5);
    if (checksum == keycode) {
      int id = int.parse(line.substring(line.lastIndexOf('-') + 1, line.indexOf('[')));
      sum += id;
      String word = '';
      line.substring(0, line.lastIndexOf('-')).runes.forEach((int c) {
        int shift = (c + (id % 26));
        if (shift > 122) shift -= 26;
        if (c == 45) shift = 32;
        word += '${new String.fromCharCode(shift)}';
      });
      if (word.startsWith('north')) {
        location = id;
      }
    }
  }));
  print('Part 1: $sum');
  print('Part 2: $location');
}
