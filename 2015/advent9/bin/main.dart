import 'dart:io';

List<List<String>> permutate(List<String> list) {
  List<List<String>> res = new List<List<String>>.empty(growable: true);
  if (list.length <= 1) {
    res.add(list);
  } else {
    int lastIndex = list.length - 1;
    res.addAll(merge(permutate(list.sublist(0, lastIndex)), list[lastIndex]));
  }
  return res;
}

List<List<String>> merge(List<List<String>> list, String token) {
  List<List<String>> res = new List<List<String>>.empty(growable: true);
  list.forEach((List<String> l) {
    for (int i = 0; i <= l.length; i++) {
        res.add(new List<String>.from(l)..insert(i, token));
    }
  });
  return res;
}

main() async {
  int shortest = 1000, longest = 0;
  String short = '', long = '';
  Map distance = new Map<String, Map<String, int>>();
  Set<String> locations = new Set<String>();

  await new File('input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      List<String> parts = line.split(' ');
      if (!distance.containsKey(parts[0])) distance[parts[0]] = Map<String, int>();
      if (!distance.containsKey(parts[2])) distance[parts[2]] = Map<String, int>();
      distance[parts[0]].addAll({parts[2]: int.parse(parts[4])});
      distance[parts[2]].addAll({parts[0]: int.parse(parts[4])});

      locations.add(parts[0]);
      locations.add(parts[2]);
    });
    permutate(locations.toList()).forEach((List<String> path) {
      String now = path[0], route = now;
      int dist = 0;
      path.sublist(1).forEach((String goal) {
        dist += distance[now][goal] as int;
        route = '${route} -> ${goal}';
        now = goal;
      });
      if (dist < shortest) {
        shortest = dist;
        short = route;
      } else if (dist > longest) {
        longest = dist;
        long = route;
      }
    });
    print('Part 1: ${shortest} (${short})');
    print('Part 2: ${longest} (${long})');
  });
}