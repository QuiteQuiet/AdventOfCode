import 'package:crypto/crypto.dart';
import 'dart:convert';
class Cache {
  bool p2;
  Map<int, String> store;
  Cache(this.p2) { this.store = new Map(); }
  String hash(String salt, int index) {
    if (!this.store.containsKey(index))  {
      String hash = '$salt$index';
      for (int i = 0, len = (this.p2 ? 2017 : 1); i < len; i++) {
        hash = md5.convert(UTF8.encode(hash)).toString();
      }
      this.store[index] = hash;
    }
    return this.store[index];
  }
}
void main() {
  bool part2 = true;
  String input = 'qzyelonm';
  RegExp TRIPLET = new RegExp(r'(.)\1{2}'), QUINT = new RegExp(r'(.)\1{4}');
  Cache cache = new Cache(part2);
  int tracker = 0, valid = 0;
  Stopwatch time = new Stopwatch()..start();
  while (valid < 64) {
    Match test = TRIPLET.firstMatch(cache.hash(input, tracker));
    if (test != null) {
      String next = test.group(0);
      int testing = tracker + 1;
      while (tracker + 1000 > testing) {
        for (Match m in QUINT.allMatches(cache.hash(input, testing))) {
          if (m.group(0).contains(next)) {
            valid++;
            testing += 1000;
            break;
          }
        }
        testing++;
      }
    }
    tracker++;
  }
  print('Part ${part2 ? 2 : 1}: ${tracker - 1} | elapsed: ${time.elapsed}');
}
