import 'package:crypto/crypto.dart';
import 'dart:convert';
void main() {
  String input = 'ugkcyxxp', key1 = '';
  List<String> key2 = new List(8)..fillRange(0, 8, '_');
  int tracker = 0;
  while (true) {
    String hash = md5.convert(UTF8.encode('$input$tracker')).toString();
    if (hash.startsWith('00000')) {
      if (key1.length < 8) {
        key1 += hash[5];
      }
      try {
        int index = int.parse(hash[5]);
        if (key2[index] == '_') {
          key2[int.parse(hash[5])] = hash[6];
          if (!key2.contains('_')) break;
        }
      } catch (e) {}
    }
    tracker++;
  }
  print('Part 1: $key1');
  print('Part 2: ${key2.join('' )}');
}
