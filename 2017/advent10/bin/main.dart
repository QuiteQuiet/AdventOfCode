void main() {
  String input = '147,37,249,1,31,2,226,0,161,71,254,243,183,255,30,70';

  // part 1
  List<int> inputL = input.split(',').map(int.parse).toList();
  List<int> data1 = new List<int>.generate(256, (i) => i++);
  int current1 = 0, skip1 = 0;
  for (int next in inputL) {
    for (int i = 0; i < next ~/ 2; i++) {
      int curI = (current1 + i) % data1.length, temp = data1[curI], swapTo = (current1 + next - i - 1) % data1.length;
      data1[curI] = data1[swapTo];
      data1[swapTo] = temp;
    }
    current1 = (current1 + next + skip1) % data1.length;
    skip1++;
  }
  // part 2
  List<int> data2 = new List<int>.generate(256, (i) => i++);
  int current2 = 0, skip2 = 0;
  List<int> compute = input.runes.toList()..addAll([17, 31, 73, 47, 23]);
  for (int i = 0; i < 64; i++) {
    for (int next in compute) {
      for (int i = 0; i < next ~/ 2; i++) {
        int curI = (current2 + i) % data2.length, temp = data2[curI], swapTo = (current2 + next - i - 1) % data2.length;
        data2[curI] = data2[swapTo];
        data2[swapTo] = temp;
      }
      current2 = (current2 + next + skip2) % data2.length;
      skip2++;
    }
  }
  List<String> hex = new List<String>();
  for (int i = 0; i < data2.length; i += 16) {
    hex.add(data2.sublist(i, i + 16).reduce((a, b) => a ^ b).toRadixString(16).padLeft(2, '0'));
  }

  print('Part 1: ${data1[0] * data1[1]}');
  print('Part 2: ${hex.join()}');
}