import 'dart:io';
import '../../intcode/computer.dart';

class NIC extends IntcodeComputer {
  late List<int> input, output;
  NIC(base, {resets = true}) : super(base, resets: resets) {
    input = [];
    output = [];
  }
}

void main() async {
  List<String> input = File('input.txt').readAsStringSync().split(',');
  List<NIC> nics = <NIC>[];
  for (int i = 0; i < 50; i++) {
    nics.add(NIC(input)..input.add(i));
    nics[i].run(input: nics[i].input, output: nics[i].output);
  }
  int natX = -1, natY = -1;
  List<int> yVals = [];
  bool done = false;
  while (!done) {
    nics.forEach((nic) => nic.run(input: nic.input..add(-1), output: nic.output));
    Iterable<NIC> pendingSends = nics.where((nic) => nic.output.isNotEmpty);
    if (pendingSends.isEmpty) {
      if (yVals.contains(natY)) done = true;
      yVals.add(natY);
      nics[0].input.addAll([natX, natY]);
    } else {
      for (NIC nic in pendingSends) {
        int dest = nic.output.removeAt(0);
        int x = nic.output.removeAt(0);
        int y = nic.output.removeAt(0);
        if (dest < 50) {
          nics[dest].input.addAll([x, y]);
        } else {
          natX = x;
          natY = y;
        }
      }
    }
  }
  print('Part 1: ${yVals.first}');
  print('Part 2: ${yVals.last}');
}