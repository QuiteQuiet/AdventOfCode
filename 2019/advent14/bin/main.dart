import 'dart:io';
import 'dart:math';

class Chemical {
  int amount;
  String name;
  List<Chemical> inputs;
  Chemical(this.amount, this.name) { this.inputs = <Chemical>[]; }
  bool operator==(covariant Chemical o) => name == o.name;
  int get hashCode => name.hashCode;
}

void main() {
  List<String> input = File('input.txt').readAsLinesSync();
  Map<String, Chemical> chemicals = {};
  for (String line in input) {
    List<String> parts = line.split(' => ');
    List<Chemical> chems = parts.expand((el) => el.split(', '))
      .map((el) => Chemical(int.parse(el.split(' ')[0]), el.split(' ')[1])).toList();
    chems.last.inputs.addAll(chems.take(chems.length - 1));
   chemicals[chems.last.name] = chems.last;
  }

  int produce(String chem, int amount, Map<String, int> leftovers) {
    if (chem == 'ORE') return amount;
    int ore = 0;
    int needed = min(amount,  leftovers[chem] ??= 0);
    amount -= needed;
    leftovers[chem] -= needed;
    int prod = chemicals[chem].amount;
    int reactions = (amount / prod).ceil();
    for (Chemical c in chemicals[chem].inputs) {
      ore += produce(c.name, reactions * c.amount, leftovers);
    }
    leftovers[chem] += reactions * prod - amount;
    return ore;
  }
  Stopwatch time = Stopwatch()..start();
  int one = produce('FUEL', 1, {});
  print('Part 1: $one ${time.elapsed}');
  int trillion = 1000000000000, left = trillion, fuel = trillion ~/ one, ore;

  while (left > 0) {
    ore = produce('FUEL', fuel, {});
    fuel += max(1, (left = trillion - ore) ~/ (ore ~/ fuel));
  }
  while (ore > trillion) ore = produce('FUEL', --fuel, {});
  print('Part 2: $fuel ${time.elapsed}');
}