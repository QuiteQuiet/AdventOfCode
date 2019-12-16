import 'dart:io';

void main() {
  Stopwatch time = Stopwatch()..start();
  String input = File('input.txt').readAsStringSync();
  List<int> signal = input.split('').map(int.parse).toList();
  List<int> basePattern = [0, 1, 0, -1];
  List<List<int>> patterns = [];

  for (int i = 0; i < signal.length; i++) {
    List<int> pattern = []..addAll(List.filled(i + 1, basePattern[0]))
                          ..addAll(List.filled(i + 1, basePattern[1]))
                          ..addAll(List.filled(i + 1, basePattern[2]))
                          ..addAll(List.filled(i + 1, basePattern[3]));
    pattern.add(pattern.first);
    pattern.removeAt(0);
    while (pattern.length < signal.length)
      pattern.addAll([...pattern]);
    pattern.sublist(0, signal.length);
    patterns.add(pattern);
  }

  for(int i = 0; i < 100; i++) {
    for (int i = 0; i < signal.length; i++) {
      int sum = 0;
      for (int j = i; j < signal.length; j++) {
          sum += signal[j] * patterns[i][j];
      }
      signal[i] = sum % 10;
    }
  }
  print('Part 1: ${signal.sublist(0, 8).join('')} ${time.elapsed}');

  int offset = int.parse(input.substring(0, 7));
  int jumps = offset ~/ input.length;
  int index = offset % input.length;
  input = (input * (10000 - jumps)).substring(index);
  List<int> signal2 = input.split('').map(int.parse).toList();
  for (int i = 0; i < 100; i++) {
    int sum = 0;
    for (int j = signal2.length - 1; j >= 0; j--) {
      signal2[j] = (sum += signal2[j]) % 10;
    }
  }
  print('Part 2: ${signal2.take(8).join('')} ${time.elapsed}');
}