import 'dart:io';

main() async {
  int checksum1 = 0, checksum2 = 0;

  await new File('advent2/input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      List<int> values = line.split('\t').map(int.parse).toList()..sort();
      // part 1
      checksum1 += values[values.length - 1] - values[0];

      // part 2
      for (int i = values.length - 1; i >= 0; i--) {
        for (int j = i - 1; j >= 0; j--) {
          if (values[i] % values[j] == 0) checksum2 += values[i] ~/ values[j];
        }
      }
    });
    print('Part 1: $checksum1');
    print('Part 2: $checksum2');
  });
}
