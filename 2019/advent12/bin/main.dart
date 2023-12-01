import 'package:trotter/trotter.dart';

class Moon {
  int x, y, z, dx = 0, dy = 0, dz = 0;
  Moon(this.x, this.y, this.z);
  void move() { x += dx; y += dy; z += dz; }
  int get energy => (x.abs() + y.abs() + z.abs()) * (dx.abs() + dy.abs() + dz.abs());
}

int lcm(int a, int b) => (a * b) ~/ gcd(a, b);

int gcd(int a, int b) {
  while (b != 0) {
    var t = b;
    b = a % t;
    a = t;
  }
  return a;
}

void main() {
  List<String> input = '''\
<x=-9, y=10, z=-1>
<x=-14, y=-8, z=14>
<x=1, y=5, z=6>
<x=-19, y=7, z=8>'''.split('\n');
  List<Moon> moons = [];
  for (String el in input) {
    Match m = RegExp(r'<x=(-?\d+), y=(-?\d+), z=(-?\d+)>').firstMatch(el)!;
    moons.add(Moon(int.parse(m.group(1)!), int.parse(m.group(2)!), int.parse(m.group(3)!)));
  }
  int energy = 0;
  Set<String> xloop = {}, yloop = {}, zloop = {};
  bool xcycle = false, ycycle = false, zcycle = false;
  xloop.add(moons.map((m) => '${m.x}/${m.dx}').join(','));
  yloop.add(moons.map((m) => '${m.y}/${m.dy}').join(","));
  zloop.add(moons.map((m) => '${m.z}/${m.dz}').join(","));
  Combinations combinations = Combinations(2, moons);
  for (int i = 0; !xcycle || !ycycle || !zcycle; i++) {
    for (var pair in combinations()) {
      Moon m1 = pair[0], m2 = pair[1];
      int dx = m1.x > m2.x ? -1 : m1.x < m2.x ? 1 : 0;
      int dy = m1.y > m2.y ? -1 : m1.y < m2.y ? 1 : 0;
      int dz = m1.z > m2.z ? -1 : m1.z < m2.z ? 1 : 0;
      m1.dx += dx; m1.dy += dy; m1.dz += dz;
      m2.dx -= dx; m2.dy -= dy; m2.dz -= dz;
    }
    moons.forEach((moon) => moon.move());
    xcycle = !xloop.add(moons.map((m) => '${m.x}/${m.dx}').join(","));
    ycycle = !yloop.add(moons.map((m) => '${m.y}/${m.dy}').join(","));
    zcycle = !zloop.add(moons.map((m) => '${m.z}/${m.dz}').join(","));
    if (i == 999) {
      energy = moons.fold(0, (sum, moon) => sum += moon.energy);
    }
  }
  print('Part 1: $energy');
  print('Part 2: ${[xloop.length, yloop.length, zloop.length].reduce(lcm)}');
}