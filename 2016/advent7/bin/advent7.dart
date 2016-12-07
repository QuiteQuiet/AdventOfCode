import 'dart:io';
main() async {
  RegExp TLS = new RegExp(r'([a-z])(?!\1)([a-z])\2\1'), HYPER = new RegExp(r'\[.*?\]'), SSL = new RegExp(r'(?=((.)(?!\2)(.)\2)).');
  int tlssupport = 0, sslsupport = 0;
  await new File('input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      Iterable<Match> hyper = HYPER.allMatches(line);
      if (TLS.hasMatch(line) && !hyper.any((Match m) => m.group(0).contains(TLS))) {
          tlssupport++;
      }
      hyper.forEach((Match m) => line = line.replaceFirst(m.group(0), '|'));
      if (SSL.allMatches(line).any((Match m) => hyper.any((Match m2) => m2.group(0).contains('${m.group(1)[1]}${m.group(1)[0]}${m.group(1)[1]}')))) {
        sslsupport++;
      }
    });
  });
  print('Part 1: $tlssupport');
  print('Part 2: $sslsupport');
}
