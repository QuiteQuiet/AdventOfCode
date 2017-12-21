import 'dart:io';

class Particle {
  int x, y, z, xv, yv, zv, xa, ya, za, d;
  bool remove = false;
  Particle(this.x, this.y, this.z, this.xv, this.yv, this.zv, this.xa, this.ya, this.za);
  int tick() {
    this.xv += this.xa;
    this.yv += this.ya;
    this.zv += this.za;
    this.x += this.xv;
    this.y += this.yv;
    this.z += this.zv;
    return this.d = this.x.abs() + this.y.abs() + this.z.abs();
  }
  String toString() => 'Particle($x, $y, $z, $xv, $yv, $zv, $xa, $ya, $za)';
}

main() async {
  List<Particle> particles = new List<Particle>();
  RegExp numbers = new RegExp(r'-?\d+');
  new File('advent20/input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      List<int> val = numbers.allMatches(line).map((m) => int.parse(m.group(0))).toList();
      particles.add(new Particle(val[0], val[1], val[2], val[3], val[4], val[5], val[6], val[7], val[8]));
    });
    int id;
    for (int i = 0; i < 1000; i++) {
      int distance = 0xFFFFFFFF;
      for (int j = 0; j < particles.length; j++) {
        int d = particles[j].tick();
        if (d < distance) {
          distance = d;
          id = j;
        }
      }
    }
    print('Part 1: $id');

    particles.clear(); // restart for part 2
    file.forEach((String line) {
      List<int> val = numbers.allMatches(line).map((m) => int.parse(m.group(0))).toList();
      particles.add(new Particle(val[0], val[1], val[2], val[3], val[4], val[5], val[6], val[7], val[8]));
    });
    List<List<int>> dangerous = new List<List<int>>();
    for (int i = 0; i < 100; i++) {
      List<Particle> next = new List<Particle>();
      dangerous.clear();
      for (Particle p in particles) {
        p.tick();
        dangerous.add([p.x, p.y, p.z]);
      }
      for (Particle p in particles) {
        if (dangerous.where((l) => p.x == l[0] && p.y == l[1] && p.z == l[2]).length <= 1) next.add(p);
      }
      particles = next;
    }
    print('Part 2: ${particles.length}');
  });
}