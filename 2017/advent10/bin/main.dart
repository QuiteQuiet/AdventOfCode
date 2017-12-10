List<int> modify(List<int> data, List<int> input, int times) {
  int current = 0, skip = 0;
  for (int count = 0; count < times; count++) {
    for (int next in input) {
      for (int i = 0; i < next ~/ 2; i++) {
        int cur = (current + i) % data.length, temp = data[cur], swapTo = (current + next - i - 1) % data.length;
        data[cur] = data[swapTo];
        data[swapTo] = temp;
      }
      current = (current + next + skip) % data.length;
      skip++;
    }
  }
  return data;
}

void main() {
  String input = '147,37,249,1,31,2,226,0,161,71,254,243,183,255,30,70';

  // part 1
  List<int> result1 = modify(new List<int>.generate(256, (i) => i++), input.split(',').map(int.parse).toList(), 1);
  
  // part 2
  List<int> result2 = modify(new List<int>.generate(256, (i) => i++),input.runes.toList()..addAll([17, 31, 73, 47, 23]), 64);
  List<String> hex = new List<String>();
  for (int i = 0; i < result2.length; i += 16) {
    hex.add(result2.sublist(i, i + 16).reduce((a, b) => a ^ b).toRadixString(16).padLeft(2, '0'));
  }
  print('Part 1: ${result1[0] * result1[1]}');
  print('Part 2: ${hex.join()}');
}