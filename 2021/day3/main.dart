import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

int reduce(List<String> options, String Function(int, int) digit) {
  int index = 0;
  while (options.length != 1) {
    int zeroes = 0, ones = 0;
    options.forEach((e) => e[index] == '0' ? zeroes++ : ones++);
    String target = digit(zeroes, ones);
    options = options.where((e) => e[index] == target).toList();
    index++;
  }
  return int.parse(options.first, radix: 2);
}

void main() async {
  List<String> lines = await aoc.getInput();

  List<String> gamma = List.generate(lines.first.length, (index) {
    int zeroes = 0, ones = 0;
    lines.forEach((e) => e[index] == '0' ? zeroes++ : ones++);
    return zeroes < ones ? '1' : '0';
  });

  List<String> epsilon = List.generate(gamma.length, (index) => gamma[index] == '1' ? '0' : '1');

  int g = int.parse(gamma.join(''), radix: 2),
      e = int.parse(epsilon.join(''), radix: 2);
  print('Part 1: ${g * e}');

  int o2 = reduce(List.from(lines), (zeroes, ones) => zeroes <= ones ? '1' : '0'),
      co2 = reduce(List.from(lines), (zeroes, ones) => zeroes <= ones ? '0' : '1');
  print('Part 2: ${o2 * co2}');
}
