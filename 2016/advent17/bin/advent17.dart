import 'package:crypto/crypto.dart';
import 'dart:convert';
String input = 'lpvhkcbi';
class Room {
  int x, y;
  List<String> open;
  String path;
  Room(this.x, this.y, [this.path = '']) {
    String hash4 = _hash4('$input$path');
    open = new List();
    if ('bcdef'.contains(hash4[0])) open.add('U');
    if ('bcdef'.contains(hash4[1])) open.add('D');
    if ('bcdef'.contains(hash4[2])) open.add('L');
    if ('bcdef'.contains(hash4[3])) open.add('R');
  }
  String _hash4(String h) => md5.convert(UTF8.encode(h)).toString().substring(0, 4);
  bool operator==(Room other) => this.x == other.x && this.y == other.y;
}

void main() {
  Room end = new Room(3, 3), shortest, longest = new Room(-1, -1);
  bool isEnd(Room r) => r == end;

  List<Room> here = [new Room(0, 0)];
  while (here.length > 0) {
    List<Room> temp = new List();
    for (Room r in here) {
      if (r.open.length < 1) continue;
      for (String s in r.open) {
        int newX = s == 'D' ? r.x + 1 : s == 'U' ? r.x - 1 : r.x,
            newY = s == 'R' ? r.y + 1 : s == 'L' ? r.y - 1 : r.y;
        if (newX < 0 || newX > 3 || newY < 0 || newY > 3) continue;
        temp.add(new Room(newX, newY, '${r.path}$s'));
      }
    }
    here = temp;
    if (here.contains(end)) {
      for (Room r in here.where(isEnd)) {
        if (shortest == null || r.path.length < shortest.path.length) {
          shortest = r;
        }
        if (r.path.length > longest.path.length) {
          longest = r;
        }
      }
      here.removeWhere(isEnd);
    }
  }
  print('Part 1: ${shortest.path}');
  print('Part 2: ${longest.path.length}');
}