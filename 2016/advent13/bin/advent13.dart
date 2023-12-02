int input = 1362;
class Location {
  int x, y;
  late bool isWall;
  Location(this.x, this.y) {
    isWall = '1'.allMatches((x * x + 3 * x + 2 * x * y + y + y * y + input).toRadixString(2)).length % 2 == 1;
  }
  bool operator ==(covariant Location other) => this.x == other.x && this.y == other.y;
}
List<Location> visited = new List.empty(growable: true);
List<Location> adj(List<Location> cur) {
  List<Location> ret = new List.empty(growable: true);
  cur.forEach((Location loc) {
    if (loc.x != 0) {
      Location next = new Location(loc.x - 1, loc.y);
      if (!visited.contains(next) && !next.isWall) {
        visited.add(next);
        ret.add(next);
      }
    }
    if (loc.y != 0) {
      Location next = new Location(loc.x, loc.y - 1);
      if (!visited.contains(next) && !next.isWall) {
        visited.add(next);
        ret.add(next);
      }
    }
    Location next = new Location(loc.x + 1, loc.y);
    if (!visited.contains(next) && !next.isWall) {
      visited.add(next);
      ret.add(next);
    }
    Location next2 = new Location(loc.x, loc.y + 1);
    if (!visited.contains(next2) && !next2.isWall) {
      visited.add(next2);
      ret.add(next2);
    }
  });
  return ret;
}
void main() {
  List<Location> here = [new Location(1, 1)];
  Location end = new Location(31, 39);
  int steps = 0, steps2 = 0;
  while (!here.contains(end)) {
    steps++;
    here = adj(here);
    if (steps == 50) {
      steps2 = visited.length;
    }
  }
  print('Part 1: $steps');
  print('Part 2: $steps2');
}