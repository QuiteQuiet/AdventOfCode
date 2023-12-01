void main() {
  String input = '359282-820401';
  int start = int.parse(input.split('-')[0]), stop = int.parse(input.split('-')[1]);
  int passwords1 = 0, passwords2 = 0;
  RegExp increasing = RegExp(r'^0*1*2*3*4*5*6*7*8*9*$'),
         dupes = RegExp(r'(\d)\1');
  for (int i = start; i < stop; i++) {
    String pw = i.toString();
    if (increasing.hasMatch(pw) && dupes.hasMatch(pw)) {
      passwords1++;
      if (dupes.allMatches(pw).any((m) => m.group(1)!.allMatches(pw).length == 2)) {
        passwords2++;
      }
    }
  }

  print('Part 1: $passwords1');
  print('Part 2: $passwords2');
}