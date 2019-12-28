import 'dart:io';

enum Condition {Resting, Running}

class Reindeer {
  int speed, endurance, rest, curStateTime = 0, distance = 0, points = 0;
  Condition state = Condition.Running;
  Reindeer(this.speed, this.endurance, this.rest);
  int advance() {
    this.curStateTime++;
    switch (this.state) {
      case Condition.Resting:
        if (this.curStateTime >= this.rest) {
          this.state = Condition.Running;
          this.curStateTime = 0;
        }
      break;
      case Condition.Running:
        this.distance += this.speed;
        if (this.curStateTime >= this.endurance) {
          this.state = Condition.Resting;
          this.curStateTime = 0;
        }
      break;
    }
    return this.distance;
  }
}

void main() {
  List<Reindeer> reindeers = new List<Reindeer>();
  new File('advent14/input.txt').readAsLinesSync().forEach((String line) {
    List<int> p = new RegExp(r'[0-9]+').allMatches(line).map((m) => int.parse(m.group(0))).toList();
    reindeers.add(new Reindeer(p[0], p[1], p[2]));
  });
  for (int i = 0; i < 2503; i++) {
    for (Reindeer r in reindeers) {
      r.advance();
    }
    reindeers.reduce((a, b) => a.distance > b.distance ? a : b).points++;
  }
  print('Part 1: ${reindeers.reduce((a, b) => a.distance > b.distance ? a : b).distance}');
  print('Part 2: ${reindeers.reduce((a, b) => a.points > b.points ? a : b).points}');
}