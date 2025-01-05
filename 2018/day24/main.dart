import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

class ArmyGroup {
  int units, unitHp, unitPower, initiative, curTarget = -1;
  String army, damageType;
  late Set<String> weakness, immunities;
  ArmyGroup(this.army, this.units, this.unitHp, String? effectiveness, this.unitPower, this.damageType, this.initiative) {
    weakness = immunities = {};
    if (effectiveness != null) {
      RegExpMatch? m = RegExp(r'immune to ([a-z, ]*)').firstMatch(effectiveness);
      if (m != null)
        immunities = Set.from(m.group(1)!.split(', '));
      m = RegExp(r'weak to ([a-z, ]*)').firstMatch(effectiveness);
      if (m != null)
        weakness = Set.from(m.group(1)!.split(', '));
    }
  }
  int get power => units * unitPower;
  int realDamage(int power, String type) {
    if (immunities.contains(type)) return 0;
    if (weakness.contains(type)) return power * 2;
    return power;
  }
  void removeUnits(int damage, String type) => units -= realDamage(damage, type) ~/ unitHp;
}

List<ArmyGroup> parseInput(List<String> lines) {
  RegExp sections = RegExp(r'(\d+) units.*with (\d+) hit points (\(.*\))?.*'
                           r'does (\d+) (.+) damage.*initiative (\d+)');
  List<ArmyGroup> armies = [];
  String cur = '';
  for (String line in lines) {
    if (line.startsWith('Immune System')) {
      cur = 'immune';
    } else if (line.startsWith('Infection')) {
      cur = 'infection';
    } else if (line.isNotEmpty) {
      RegExpMatch m = sections.firstMatch(line)!;
      armies.add(ArmyGroup(cur, m.group(1)!.toInt(), m.group(2)!.toInt(), m.group(3),
                           m.group(4)!.toInt(), m.group(5)!, m.group(6)!.toInt()));
    }
  }
  return armies;
}

(String, int) simulation(List<ArmyGroup> armies, int boost) {
  armies.where((e) => e.army == 'immune').forEach((e) => e.unitPower += boost);
  int countUnits() => armies.fold(0, (units, e) => units + e.units);

  while (armies.any((e) => e.army != armies[0].army)) {
    armies.sort((a, b) => a.power != b.power ? b.power - a.power : b.initiative - a.initiative);

    int unitsBefore = countUnits();
    for (ArmyGroup attacker in armies) {
      int bestDamage = 1;
      for (final (int ii, ArmyGroup target) in armies.indexed) {
        if (attacker.army == target.army || armies.any((e) => e.curTarget == ii)) continue;

        int damage = target.realDamage(attacker.power, attacker.damageType);
        if (damage > bestDamage) {
          attacker.curTarget = ii;
          bestDamage = damage;
        } else if (damage == bestDamage) {
          ArmyGroup cur = armies[attacker.curTarget];
          if (target.power > cur.power ||
              (target.power == cur.power && target.initiative > cur.initiative)) {
            attacker.curTarget = ii;
            bestDamage = damage;
          }
        }
      }
    }

    List<ArmyGroup> attackOrder = List.from(armies)..sort((a, b) => b.initiative - a.initiative);
    for (ArmyGroup attacker in attackOrder) {
      if (attacker.units <= 0 || attacker.curTarget == -1) continue;
      armies[attacker.curTarget].removeUnits(attacker.power, attacker.damageType);
      attacker.curTarget = -1;
    }
    armies.removeWhere((e) => e.units <= 0);

    if (unitsBefore == countUnits()) {
      return ('tie', -1); // Some boosts make both armies unable to kill any units, so combat never progress
    }
  }
  return (armies[0].army, countUnits());
}

void main() async {
  List<String> lines = await aoc.getInput();

  print('Part 1: ${simulation(parseInput(lines), 0).$2}');

  int low = 0, high = 1000;
  while (high - low != 1) {
    int middle = (low + high) ~/ 2;
    if (simulation(parseInput(lines), middle).$1 == 'immune')
      high = middle;
    else
      low = middle;
  }
  print('Part 2: ${simulation(parseInput(lines), high).$2}');
}
