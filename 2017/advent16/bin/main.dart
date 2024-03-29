import 'dart:io';

main() async {
  List<String> programs = new List.from('abcdefghijklmnop'.split(''));
  Map<String, int> states = new Map<String, int>();
  int remaining = 1000000000;
  int? cycle;
  new File('input.txt').readAsLines()
  .then((List<String> file) {
    List<String> parts = file[0].split(',');
    states[programs.join()] = 0;
    for (int i = 1; cycle == null; i++) {
      for (String act in parts) {
        String params = act.substring(1);
        switch (act[0]) {
          case 's':
            int index = programs.length - int.parse(params);
            programs = programs.sublist(index)..addAll(programs.sublist(0, index));
          break;
          case 'x':
            List<int> values = params.split('/').map(int.parse).toList();
            String temp = programs[values.first];
            programs[values.first] = programs[values.last];
            programs[values.last] = temp;
          break;
          case 'p':
            List<int> values = params.split('/').map((p) => programs.indexOf(p)).toList();
            String temp = programs[values.last];
            programs[values.last] = programs[values.first];
            programs[values.first] = temp;
          break;
        }
      }
      if (states.containsKey(programs.join())) {
        cycle = i - states[programs.join()]!;
        remaining = (remaining % cycle!);
        for (String k in states.keys) {
          if (states[k] == remaining) {
            programs = k.split('');
            break;
          }
        }
      }
      else {
        states[programs.join()] = i;
      }
      if (i == 1) print('Part 1: ${programs.join()}');
    }
  print('Part 2: ${programs.join()}');
  });
}