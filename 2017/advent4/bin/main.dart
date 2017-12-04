import 'dart:io';
/// Returns a new lazy [Iterable] with every permutation of the list
Iterable<List> permutations(List<dynamic> l) sync* {
  if (l.length == 2) {
    yield l;
    yield [l[1], l[0]];
  } else {
    for (int i = 0; i < l.length; i++) {
      for (List perm in permutations(l.sublist(0, i)..addAll(l.sublist(i + 1)))) {
        yield [l[i]]..addAll(perm);
      }
    }
  }
}

main() async {
  int valid1 = 0, valid2 = 0;
  RegExp bounds = new RegExp(r'(\b[^\s]+?\b).*?\b\1\b');
  await new File('advent4/input.txt').readAsLines()
  .then((List<String> file) => file.forEach((String line) {
    // part 1 
    if (!bounds.hasMatch(line)) valid1++;
    // part 2
    bool valid = true;
    List<String> words = line.split(' ');
    for (String word in words) {
      List<String> excluded = line.split(' ')..remove(word);
      if (!valid) break; // no need to bother with this line anymore 
      for (List<String> option in permutations(word.split(''))) {
        String test = option.join();
        if (excluded.contains(test)) {
          valid = false;
          break;
        }
      }
    }
    if (valid) valid2++;
  }));
  print('Part 1: $valid1');
  print('Part 2: $valid2');
}

