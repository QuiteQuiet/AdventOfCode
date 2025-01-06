import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

bool outsideRange(int v, int low, int high) => v < low || v > high;

void main() async {
  List<String> lines = await aoc.getInput()..add('');

  List<String> required = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'];
  Set<String> eyeColours = {'amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'};
  RegExp hairColour = RegExp(r'#[0-9a-f]{6}'), height = RegExp(r'(\d{2,3})(cm|in)');

  int allFields = 0, correctInfo = 0;
  Map<String, String> passport = {};
  for (String l in lines) {
    if (l.isNotEmpty) {
      l.split(' ').map((e) => e.split(':')).forEach((e) => passport[e[0]] = e[1]);
    } else {
      bool fieldsCorrect = true, infoCorrect = true;
      for (String field in required) {
        if (!passport.containsKey(field)) {
          fieldsCorrect = false;
          continue;
        }
        String value = passport[field]!;
        switch (field) {
          case 'byr': if (outsideRange(value.toInt(), 1920, 2002)) infoCorrect = false;
          case 'iyr': if (outsideRange(value.toInt(), 2010, 2020)) infoCorrect = false;
          case 'eyr': if (outsideRange(value.toInt(), 2020, 2030)) infoCorrect = false;
          case 'hgt':
            RegExpMatch? info = height.firstMatch(value);
            if (info != null)
              switch (info.group(2)) {
                case 'cm': if (outsideRange(info.group(1)!.toInt(), 150, 193)) infoCorrect = false;
                case 'in': if (outsideRange(info.group(1)!.toInt(), 59, 76)) infoCorrect = false;
              }
            else
              infoCorrect = false;
          case 'hcl': if (!hairColour.hasMatch(value)) infoCorrect = false;
          case 'ecl': if (!eyeColours.contains(value)) infoCorrect = false;
          case 'pid': if (value.length != 9 || int.tryParse(value) == null) infoCorrect = false;
          case 'cid': // ignored
        }
      }
      if (fieldsCorrect)
        allFields++;
      if (fieldsCorrect && infoCorrect)
        correctInfo++;
      passport.clear();
    }
  }

  print('Part 1: $allFields');
  print('Part 2: $correctInfo');
}
