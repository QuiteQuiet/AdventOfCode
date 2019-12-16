import 'dart:io';
import 'dart:collection';

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
    List<int> temp = [];
    for (int i = 0; i < signal.length; i++) {
      int sum = 0;
      for (int j = i; j < signal.length; j++) {
          sum += signal[j] * patterns[i][j];
      }
      temp.add(sum % 10);
    }
    temp = signal;
  }
  print('Part 1: ${signal.sublist(0, 8).join('')} ${time.elapsed}');

  int offset = int.tryParse(input.substring(0, 7)) ?? -1;
  int jumps = offset ~/ input.length;
  int index = offset % input.length;
  input *= (10000 - jumps);
  input = input.substring(index);
  Queue<int> signal2 = Queue.from(input.split('').map(int.parse));
  for (int i = 0; i < 100; i++) {
    int sum = 0;
    Queue<int> temp = Queue();
    while (signal2.isNotEmpty) {
      temp.addFirst((sum += signal2.removeLast()) % 10);
    }
    signal2 = temp;
  }
  print('Part 2: ${signal2.take(8).join('')} ${time.elapsed}');
}