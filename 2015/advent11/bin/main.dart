bool first(Runes test) {
  for (int i = 0; i < test.length - 2; i++) {
    if (test.elementAt(i) + 1 == test.elementAt(i + 1) && test.elementAt(i) + 2 == test.elementAt(i + 2))
      return true;
  }
  return false;
}

main() {
  String input = 'hepxcrrq';
  RegExp cond1 = new RegExp(r'[ilo]'), cond2 = new RegExp(r'(.)\1.*(.)\2');
  bool good(value) => !cond1.hasMatch(value) && cond2.hasMatch(value) && first(value.runes);

  for(int i = 1; i <= 2; i++) {
    while (!good(input)) {
      input = (int.parse(input, radix: 36) + 1).toRadixString(36).replaceAll('0', 'a');
    }
    print('Part ${i}: ${input}');
    input = (int.parse(input, radix: 36) + 1).toRadixString(36).replaceAll('0', 'a');
  }
}