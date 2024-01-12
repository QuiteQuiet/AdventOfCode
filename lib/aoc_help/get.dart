// Local helper scripts
import 'dart:convert';

import 'date.dart' as calendar;
import 'io.dart' as data;

/// Get input data for one Advent of Code day.
/// It will either guess what day is the "current"
/// day based on file names and such, or it can be
/// specified as input parameters if this doesn't work.
///
/// It will fetch the input from the site and store in a
/// local `input.txt` file. Future calls to this function
/// will read the local file rather than re-fetching the
/// input data from the site itself.
Future<String> getInputString({String? year, String? day}) async {
  if (year == null || day == null) {
    final date = calendar.getDayAndYear();
    year ??= date.year;
    day ??= date.day;
  }

  String? input = data.fromDisk(year, day);

  // Input being null means there was no local file so
  // it needs to be fetched from the aoc site.
  if (input == null) {
    input = await data.fromSite(year, day);
  }
  return input;
}

/// Get input data for one Advent of Code day.
/// It will either guess what day is the "current"
/// day based on file names and such, or it can be
/// specified as input parameters if this doesn't work.
///
/// It will fetch the input from the site and store in a
/// local `input.txt` file. Future calls to this function
/// will read the local file rather than re-fetching the
/// input data from the site itself.
Future<List<String>> getInput({String? year, String? day}) async =>
  LineSplitter().convert(await getInputString(year: year, day: day));