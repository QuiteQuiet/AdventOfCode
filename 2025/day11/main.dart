import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

int traverse(Map<String, List<String>> reactors, String cur, String goal, Map<String, int> ccache) {
  if (cur == goal) return 1;
  if (ccache.containsKey(cur)) return ccache[cur]!;
  return ccache[cur] = reactors[cur]!.fold(0, (s, next) => s + traverse(reactors, next, goal, ccache));
}

void main() async {
  List<String> lines = await aoc.getInput();

  Map<String, List<String>> reactors = {'out': []};
  for (String line in lines) {
    List<String> all = line.split(' ');
    reactors[all.first.replaceAll(':', '')] = all.sublist(1);
  }
  print('Part 1: ${traverse(reactors, 'you', 'out', {})}');

  int dacs = traverse(reactors, 'fft', 'dac', {}),
      ffts = traverse(reactors, 'dac', 'fft', {}),
      outs = 0;
  if (dacs != 0) {
    ffts = traverse(reactors, 'svr', 'fft', {});
    outs = traverse(reactors, 'dac', 'out', {});
  } else {
    dacs = traverse(reactors, 'svr', 'dac', {});
    outs = traverse(reactors, 'fft', 'out', {});
  }
  print('Part 2: ${ffts * dacs * outs}');
}
