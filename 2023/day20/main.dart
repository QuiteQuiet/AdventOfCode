import 'package:AdventOfCode/aoc_help/get.dart' as aoc;

import 'dart:collection';

import 'package:dart_numerics/dart_numerics.dart' as numerics;

import 'package:AdventOfCode/int.dart';

class Module {
  String name;
  String type;
  int cycle = 1;
  bool powered = false;
  List<String> connected;
  Map<String, int> inputs = {};
  Module(this.name, this.type, this.connected);

  List<(String, String, int)> process(int pulse, String from, int press) {
    switch (type) {
      case '%':
        if (pulse == 0) {
          powered = !powered;
          return List.generate(
            connected.length, (i) => (name, connected[i], powered ? 1 : 0));
        }
      case '&':
        inputs[from] = pulse;
        int output = inputs.values.any((e) => e == 0) ? 1 : 0;
        if (powered && output == 1) {
          cycle = press;
        }
        return List.generate(
          connected.length, (i) => (name, connected[i], output));
      case 'b':
        return List.generate(
          connected.length, (i) => (name, connected[i], pulse));
    }
    return [];
  }
}

void main() async {
  List<String> input = await aoc.getInput();

  Map<String, Module> modules = {'rx': Module('rx', 'rx', [])};

  for (String module in input) {
    List<String> parts = module.split(' -> ');
    String name = parts[0].substring(1);
    modules[name] = Module(name, parts[0][0], parts[1].split(',').map((e) => e.trim()).toList());
  }
  for (Module mod in modules.values) {
    for (String name in mod.connected) {
      modules[name]!.inputs[mod.name] = 0;
    }
  }
  for (String start in modules['rx']!.inputs.keys) {
    for (String sender in modules[start]!.inputs.keys) {
      modules[sender]!.powered = true;
    }
  }

  Queue<(String, String, int)> processingQueue = Queue();
  List<int> counter = [0, 0];

  for (int i in 1.to(5000)) {
    processingQueue.add(('button', 'roadcaster', 0));
    while (processingQueue.isNotEmpty) {
      (String, String, int) event = processingQueue.removeFirst();
      if (i <= 1000) counter[event.$3]++;

      modules[event.$2]!.process(event.$3, event.$1, i).forEach(processingQueue.add);
    }
  }
  print('Part 1: ${counter[0] * counter[1]}');
  print('Part 2: ${modules.values.fold(1, (lcm, e) => numerics.leastCommonMultiple(lcm, e.cycle))}');
}