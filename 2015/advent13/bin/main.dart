import 'dart:io';

List<List<String>> permutate(List<String> list) {
  List<List<String>> res = new List<List<String>>();
  if (list.length <= 1) {
    res.add(list);
  } else {
    int last = list.length - 1;
    res.addAll(merge(permutate(list.sublist(0, last)), list[last]));
  }
  return res;
}
List<List<String>> merge(List<List<String>> list, String token) {
  List<List<String>> res = new List<List<String>>();
  list.forEach((List<String> l) {
    for (int i = 0; i <= l.length; i++) {
        res.add(new List<String>.from(l)..insert(i, token));
    }
  });
  return res;
}

int happiness(List<String> guests, Map<String, Map<String, int>> values) {
  int happy = 0;
  permutate(guests.toList()).forEach((List<String> seat) {
      int trial = 0, end = seat.length - 1;
      for (int i = 0; i < seat.length; i++) {
        trial += values[seat[i]][seat[(i == 0 ? end:i-1)]] + values[seat[i]][seat[(i == end ? 0:i+1)]];
      }
      if (happy < trial) happy = trial;
  });
  return happy;
}

main() async {
  Set<String> guests = new Set<String>();
  Map<String, Map<String, int>> values = new Map<String, Map<String, int>>();
  await new File('advent13/input.txt').readAsLines()
  .then((List<String> file) => file.forEach((String line) {
    List<String> part = line.substring(0, line.length - 1).split(' ');
    if (!values.containsKey(part[0])) values[part[0]] = {};
    values[part[0]].addAll({part[10]: int.parse('${{"lose":"-","gain":""}[part[2]]}${part[3]}')});
    guests.add(part[0]);
  }));

  print('Part 1: ${happiness(guests.toList(), values)}');
  // Add myself to the seating
  values['Me'] = {};
  guests.forEach((String name) {
    values['Me'].addAll({name: 0});
    values[name].addAll({'Me': 0});
  });
  guests.add('Me');
  print('Part 2: ${happiness(guests.toList(), values)}');
}