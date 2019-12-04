import 'dart:io';

class No5Int {
  int _i;
  No5Int(this._i);
  int get I => this._i;
  int inc() {
    this._i++;
    if (this._i == 5) this._i = 6;
    return this._i;
  }
  int dec() {
    this._i--;
    if (this._i == 5) this._i = 4;
    return this._i;
  }
  int assign(No5Int o) => this._i = o._i;
  bool operator==(covariant No5Int o) => this._i == o._i;
  bool operator<(No5Int o) => this._i < o._i;
  No5Int operator+(No5Int o) {
    No5Int t = new No5Int(this._i + o._i);
    if (t._i == 5) t._i = 6;
    return t;
  }
  No5Int operator-(No5Int o) {
    No5Int t = new No5Int(this._i + o._i);
    if (t._i == 5) t._i = 4;
    return t;
  }
  String toString() => '($_i)';
}

main() async {
  int ops = 0;
  No5Int instruction = new No5Int(0);
  List<No5Int> processed = new List<No5Int>();
  bool part2 = true;
  await new File('advent5/input.txt').readAsLines()
  .then((List<dynamic> file) {
    processed.length = file.length + 1; // since index 5 isn't open to use
    No5Int index = new No5Int(0);
    for (int fi = 0; fi < file.length; fi++) {
      processed[index.I] = new No5Int(int.parse(file[fi]));
      index.inc();
    }
  });
  for (; instruction.I >= 0 && instruction.I < processed.length; ops++) {
      int old = instruction.I;
      instruction.assign(instruction + processed[instruction.I]);
      part2 && processed[old].I >= 3 ? processed[old].dec() : processed[old].inc();
    }
  print('Part ${part2 ? 2 : 1}: $ops');
}