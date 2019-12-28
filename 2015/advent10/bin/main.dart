String getNext(String input) {
  List<String> out = new List<String>();
  int index = 0;
  while (index < input.length) {
    int point = index, matched = 0;
    for (; point < input.length && input[index] == input[point]; point++) {
      matched++;
    }
    out.add('${matched}${input[index]}');
    index += matched;
  }
  return out.join();
}

main() {
  String input = '3113322113';
  for (int i = 0; i < 40; i++) {
    input = getNext(input);
  }
  print('Part 1: ${input.length}');
  for (int i = 0; i < 10; i++) {
    input = getNext(input);
  }
  print('Part 2: ${input.length}');
}