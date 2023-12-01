import 'dart:io';
import 'dart:collection';
import 'package:collection/collection.dart';

class Planet {
  String name;
  Planet? orbiting;
  late List<Planet?> orbiters;
  late int? orbits;
  int hops = 0;
  bool visited = false;
  Planet(this.name) { orbiters = List<Planet>.empty(growable: true); }
  bool operator==(covariant Planet o) => name == o.name;
  int get hashCode => name.hashCode;
}

void main() {
  Map<String, Planet> solarSystem = new Map<String, Planet>();
  List<String> input = File('input.txt').readAsLinesSync();
  Stopwatch time = Stopwatch()..start();
  input.forEach((String line) {
    List<String> parts = line.split(')');
    String orbits = parts[0], orbiter = parts[1];
    // ??= if null assign
    solarSystem[orbits] ??= Planet(orbits);
    solarSystem[orbiter] ??= Planet(orbiter);
    solarSystem[orbits]?.orbiters.add(solarSystem[orbiter]);
    solarSystem[orbiter]?.orbiting = solarSystem[orbits];
  });
  // find center of the universe
  Planet center = solarSystem.values.first;
  while (center.orbiting != null){
    center = center.orbiting ?? center;
  }
  // traverse universe
  Queue<Planet> planets = Queue<Planet>()..add(center);
  int sum = 0;
  while (planets.isNotEmpty) {
    Planet planet = planets.removeFirst();
    planet.orbits = (planet.orbiting?.orbits ?? -1) + 1;
    planet.orbiters.forEach((p) => planets.add(p!));
    sum += planet.orbits!;
  }
  print('Part 1: $sum (Time: ${time.elapsed})');
  // jumping planets
  PriorityQueue<Planet> queue = PriorityQueue<Planet>((Planet p1, Planet p2) => p1.hops - p2.hops);
  queue.add((solarSystem['YOU']?.orbiting)!);
  Planet? target;
  while (target == null) {
    Planet current = queue.removeFirst()..visited = true;
    if (current.name == 'SAN') {
      target = current.orbiting;
    }
    if (current.orbiting?.visited == false) {
      current.orbiting?.hops += current.hops + 1;
      queue.add(current.orbiting!);
    }
    current.orbiters.forEach((Planet? p) {
      if (!p!.visited) {
        p.hops += current.hops + 1;
        queue.add(p);
      }
    });
  }
  print('Part 2: ${target.hops} (Time: ${time.elapsed})');
}