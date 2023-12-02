import 'dart:io';
/// Returns a new lazy [Iterable] with every permutation of the list
Iterable<List<String>> permutations(List<String> l) sync* {
  if (l.length == 2) {
    yield l;
    yield [l[1], l[0]];
  } else {
    for (int i = 0; i < l.length; i++) {
      for (List<String> perm in permutations(l.sublist(0, i)..addAll(l.sublist(i + 1)))) {
        yield [l[i]]..addAll(perm);
      }
    }
  }
}
List<String> swap(List<String> c, int a, int b) {
  String temp = c[b];
  c[b] = c[a];
  c[a] = temp;
  return c;
}
List<String> mutate(List<String> l, List<String> parts) {
  switch(parts[0]) {
      case 'move':
        String c = l[int.parse(parts[2])];
        l.remove(c);
        l.insert(int.parse(parts[5]), c);
      break;
      case 'swap':
        if (parts[1] == 'position') {
          l = swap(l, int.parse(parts[2]), int.parse(parts[5]));
        } else {
          l = swap(l, l.indexOf(parts[2]), l.indexOf(parts[5]));
        }
      break;
      case 'reverse':
        int x = int.parse(parts[2]), y = int.parse(parts[4]) + 1;
        l = new List.from(l.sublist(0, x), growable: true)..addAll(l.sublist(x, y).reversed)..addAll(l.sublist(y, l.length));
      break;
      case 'rotate':
        int times, i;
        if (parts[1] == 'left') {
          i = int.parse(parts[2]) % l.length;
          l = l.sublist(i)..addAll(l.sublist(0, i));
        } else {
          if (parts[1] == 'based') {
            times = l.indexOf(parts[6]);
            times += times < 4 ? 1 : 2;
          } else {
            times = int.parse(parts[2]);
          }
          i = l.length - (times % l.length);
          l = new List.from(l.sublist(i))..addAll(l.sublist(0, i));
        }
      break;
    }
  return l;
}
main() async {
  List<String> input = new List.from('abcdefgh'.split(''));
  await new File('input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      input = mutate(input, line.split(' '));
    });
    print('Part 1: ${input.join()}');
    for (List<String> next in permutations('abcdefgh'.split(''))) {
      String undone = next.join();
      file.forEach((String line) => next = mutate(next, line.split(' ')));
      if (next.join() == 'fbgdceah') {
        print('Part 2: $undone');
        break;
      }
    }
  });
}