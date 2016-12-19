import 'dart:collection';
class Elf extends LinkedListEntry {
  int nr, p;
  Elf(this.nr, [this.p = 1]);
  void takeFrom(Elf other) {
    this.p += other.p;
    other.p = 0;
  }
  String toString() => '$nr: $p presents';
}
void main() {
  int input = 3012210;
  List<Elf> circle = new List.generate(input, (i) => new Elf(i + 1));
  LinkedList<Elf> circle2 = new LinkedList()..addAll(circle);
  while (circle.length > 1) {
    for (int i = 0; i < circle.length; i++) {
      if (circle[i].p <= 0) continue;
      circle[i].takeFrom(circle[(i + 1) % circle.length]);
    }
    circle.removeWhere((e) => e.p < 1);
  }
  print('Part 1: ${circle[0]}');
  Elf start = circle2.first, middle = circle2.elementAt(circle2.length ~/ 2);
  while (circle2.length > 1) {
    start.takeFrom(middle);
    Elf temp = middle;
    middle = middle.next == null ? circle2.first : middle.next;
    if (circle2.length % 2 == 1) middle = middle.next == null ? circle2.first : middle.next;
    circle2.remove(temp);
    start = start.next == null ? circle2.first : start.next;
  }
  print('Part 2: $start');
}