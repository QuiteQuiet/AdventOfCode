import 'dart:io';

class Grid
{
  List _l;
  int _x, _y;

  Grid(this._x, this._y) { this._l = new List.generate(this._y, (i) => new List(this._x)); }
  Object operator[](List<int> xy) => this._l[xy[0]][xy[1]];
  void operator[]=(List<int> xy, Object o) { this._l[xy[0]][xy[1]] = o; }

  bool contains(Object o) => this._l.contains(o);
  int count(Object o) {
    int counter = 0;
    for (int i = 0; i < this._y; i++)
      for (int ii = 0; ii < this._x; ii++)
        if (this[[i, ii]] == o) 
          counter++;
    return counter;
  }
  void fill(Object o) => this._l.forEach((l) => l.fillRange(0, l.length, o));
  void fillTopLeft(int xend, int yend, Object o) {
    for (int i = 0; i < yend; i++) 
      for (int ii = 0; ii < xend; ii++) 
        this[[i, ii]] = o;
  }
  void rotate(String type, int index) {
    List<Object> temp = [null];
    for (int i = 0, len = (type == 'row' ? this._x : this._y); i < len; i++) {
      temp.add(this[(type == 'row' ? [index, i] : [i, index])]);
    }
    temp[0] = temp.last;
    for (int i = 0, len = (type == 'row' ? this._x : this._y); i < len; i++) {
      this[(type == 'row' ? [index, i] : [i, index])] = temp[i];
    }
  }
  void rotateColumn(int col, int pixels) {
    for (int i = 0; i < pixels; i++) this.rotate('col', col);
  }
  void rotateRow(int row, int pixels) {
    for (int i = 0; i < pixels; i++) this.rotate('row', row);
  }
  String toString() {
    String buf = '\n';
    for (int i = 0; i < this._y; i++) {
      for (int ii = 0; ii < this._x; ii++) {
        buf += '${this[[i, ii]]} ';
      }
      buf += '\n';
    }
    return '$buf';
  }
}

main() async {
  Grid pad = new Grid(50, 6)..fill('.');
  await new File('input.txt').readAsLines()
  .then((List<String> file) => file.forEach((String line) {
    if (line.startsWith('rect')) {
      List<int> rect = line.substring('rect'.length).split('x').map(int.parse).toList();
      pad.fillTopLeft(rect[0], rect[1], '#');
    } else if (line.startsWith('rotate row')) {
      List<int> rot = line.substring('rotate row y='.length).split('by').map(int.parse).toList();
      pad.rotateRow(rot[0], rot[1]);
    } else if (line.startsWith('rotate column')) {
      List<int> rot = line.substring('rotate column x='.length).split('by').map(int.parse).toList();
      pad.rotateColumn(rot[0], rot[1]);
    }
    sleep(new Duration(milliseconds: 250));   
    print(pad.toString());
  }));
  print('Part 1: ${pad.count('#')}');
  print('Part 2: ${pad.toString()}');
}