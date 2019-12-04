import 'dart:io';

int getFuel(int mass) {
  int fuel = mass ~/ 3 - 2;
  if (fuel <= 0) return 0;
  return fuel +  getFuel(fuel);
}

void main() async {
  int fuel = 0, fuel2 = 0;
  await new File('input.txt').readAsLines()
    .then((List<String> file) {
      file.forEach((String line) {
        int mass = int.parse(line);
        fuel += mass ~/ 3 - 2;
        fuel2 += getFuel(mass);
      });
  });

  print('Part 1: $fuel');
  print('Part 2: $fuel2');
}