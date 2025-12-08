import 'dart:io' as io;
import 'package:http/http.dart' as http;

/// Stuff requested by the aoc automation guidelines:
/// https://old.reddit.com/r/adventofcode/wiki/faqs/automation
Map<String, String> HEADERS = {
  'User-Agent': 'github.com/QuiteQuiet/AdventOfCode by (same)',
};

/// If you thought the hack to get the day and year was bad.
/// There is, as-far-as-I-can-Google, no good way to find this
/// specific folder locoation otherwise. Someone please
/// prove me wrong on this and give a more general method of
/// finding the aoc_help directory?
String _findThisDirectory() {
  return '../../lib/aoc_help';
}

/// Too lazy to figure out env variables so there will be a
/// file in this folder called "session_cookie" that
/// you need to add your session cookie to.
String getUserSession() => io.File('${_findThisDirectory()}/session_cookie').readAsStringSync();

String? fromDisk(String year, String day,) {
  io.File inputFile = io.File('input.txt');
  if (inputFile.existsSync()) {
    return inputFile.readAsStringSync();
  }
  return null;
}

/// Fetches the input data for year:day and stores in a local file
/// `input.txt`. We're just going to do one single request. If this
/// fails for any reason at all it needs to be manually restarted.
Future<String> fromSite(String year, String day) async {
  String user = getUserSession();

  Uri url = Uri.https('adventofcode.com', '$year/day/$day/input');
  HEADERS['Cookie'] = 'session=$user';
  http.Response response = await http.get(
    url,
    headers: HEADERS);

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch input from site. Check session cookie/connection and try again');
  } else {
    String input = response.body;
    await io.File('input.txt').writeAsString(input.substring(0, input.length - 1));
    return input;
  }
}