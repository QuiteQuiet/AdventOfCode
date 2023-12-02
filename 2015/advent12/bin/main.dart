import 'dart:convert';
import 'dart:io';

int list(List c) => c.fold(0, (t, e) => t + (e is Map ? map(e) : (e is List ? list(e) : (e is int ? e : 0))));
int map(Map m) => m.values.fold(0, (t, v) => t + (v is Map ? map(v) : (v is List ? list(v) : (v is int ? v : 0))));

int list2(List c) => c.fold(0, (t, e) => t + (e is Map ? map2(e) : (e is List ? list2(e) : (e is int ? e : 0))));
int map2(Map m) {
  if (m.containsValue('red')) return 0;
  return m.values.fold(0, (t, v) => t + (v is Map ? map2(v) : (v is List ? list2(v) : (v is int ? v : 0))));
}

void main() {
  Map input = json.decode(new File('input.txt').readAsLinesSync()[0]);
  print('Part 1: ${map(input)}');
  print('Part 2: ${map2(input)}');
}