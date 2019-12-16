import 'dart:io';

List<int> fft(List<int> signal, List<List<int>> patterns) {
  List<int> output = [];
  for (int i = 0; i < signal.length; i++) {
    int sum = 0;
    for (int j = i; j < signal.length; j++) {
        sum += signal[j] * patterns[i][j];
    }
    output.add(sum.abs() % 10);
  }
  return output;
}

void main() {
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
    signal = fft(signal, patterns);
  }
  print('Part 1: ${signal.sublist(0, 8).join('')}');

  int offset = int.tryParse(input.substring(0, 7)) ?? -1;
  int jumps = offset ~/ input.length;
  int index = offset % input.length;
  input *= (10000 - jumps);
  input = input.substring(index);
  List<int> signal2 = input.split('').map(int.parse).toList();
  for (int i = 0; i < 100; i++) {
    int sum = 0;
    List<int> temp = [];
    for (int el in signal2.reversed) {
      temp.add((sum += el) % 10);
    }
    signal2 = temp.reversed.toList();
  }
  print('Part 2: ${signal2.sublist(0, 8).join('')}');
}