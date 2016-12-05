import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';
void main() {
  String input = 'ugkcyxxp', key1 = '';
  List<String> key2 = ['_','_','_','_','_','_','_','_'];
  Map<String, bool> used = {'0':false,'1':false,'2':false,'3':false,'4':false,'5':false,'6':false,'7':false};
  int tracker = 0;
  crypto.MD5 md5 = crypto.md5;
  while (key2.contains('_')) {
    String hash = md5.convert(UTF8.encode('$input$tracker')).toString();
    if (hash.startsWith('00000')) {
      if (key1.length < 8) {
        key1 += hash[5];
        print(key1);
      }
      if (used.containsKey(hash[5]) && !used[hash[5]]) {
        key2[int.parse(hash[5])] = hash[6];
        used[hash[5]] = true;
        print(key2);
      }
    }
    tracker++;
  }
  print('$tracker');
  print('Part 1: $key1');
  print('Part 2: ${key2.join('' )}');
}
