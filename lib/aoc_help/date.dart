RegExp FILE = RegExp(r'\((.+)\)');
RegExp DAY = RegExp(r"(?<!\d)(2[0-5]|1[0-9]|[1-9])(?!\d)");
RegExp YEAR = RegExp(r"201[5-9]|202[0-9]");

/// This will inspect the stack trace of the current caller
/// to find the file path for the date. This assumes we have
/// a reasonable naming scheme on the folders so it's possible
/// to pick out which day and year the current program is
/// trying to run.
({String year, String day}) getDayAndYear() {
  String main = StackTrace.current.toString().split('\n').firstWhere((e) => e.contains('main'));
  main = FILE.firstMatch(main)!.group(1)!;

  String year = YEAR.firstMatch(main)!.group(0)!;
  String day = DAY.firstMatch(main)!.group(0)!;

  return (year: year, day: day);
}