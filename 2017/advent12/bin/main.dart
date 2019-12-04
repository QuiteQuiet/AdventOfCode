import 'dart:io';

class Program {
  int id;
  bool visited = false;
  List<Program> pipes;
  Program(this.id) { this.pipes = new List<Program>(); }
  bool operator==(covariant Program o) => this.id == o.id;
}

main() async {
  int groups = 0, programsIn0;
  Map<int, Program> programs = new Map<int, Program>();
  List<Program> currentGroup = new List<Program>(), toExplore = new List<Program>();
  new File('advent12/input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      List<String> parts = line.split(' <-> ');
      int target = int.parse(parts[0]);
      if (!programs.containsKey(target)) programs[target] = new Program(target);
      for (String link in parts[1].split(', ')) {
        int pipe = int.parse(link);
        if (!programs.containsKey(pipe)) programs[pipe] = new Program(pipe);
        programs[target].pipes.add(programs[pipe]);
      }
    });
    for (Program next in programs.values) {
      if (!next.visited) {
        toExplore.addAll(next.pipes);
        currentGroup.add(next);
        next.visited = true;
        while (toExplore.length > 0) {
          Program temp = toExplore.removeAt(0);
          if (currentGroup.contains(temp)) continue;
          currentGroup.add(temp);
          toExplore.addAll(temp.pipes);
          temp.visited = true;
        }
        // part 1
        if (next.id == 0) programsIn0 = currentGroup.length;
        // part 2
        groups++;
        currentGroup.clear();
      }
    }

    print('Part 1: $programsIn0');
    print('Part 2: $groups');
  });
}