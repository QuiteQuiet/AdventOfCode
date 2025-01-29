import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/string.dart';

class BingoBoard {
  late List<List<int>> board;
  late List<List<int>> marked;
  BingoBoard() {
    board = [];
    marked = List.generate(5, (index) => []);
  }
}
void main() async {
  List<String> lines = await aoc.getInput();

  List<BingoBoard> boards = [];
  for (String line in lines.skip(1)) {
    if (line.isNotEmpty)
      boards.last.board.add(line.numbers());
    else
      boards.add(BingoBoard());
  }

  List<(BingoBoard, int)> order = [];
  for (int number in lines.first.numbers()) {
    List<int> winners = [];
    for (final (int i, BingoBoard b) in boards.indexed) {
      b.board.indexed.forEach((e) {
        for (int col = 0; col < e.$2.length; col++)
          if (e.$2[col] == number)
            b.marked[e.$1].add(col);
      });

      List<int> columns = [0, 0, 0, 0, 0];
      for (List<int> row in b.marked) {
        if (row.length == 5) {
          winners.add(i);
          break;
        }
        for (int n in row) columns[n]++;
      }
      if (columns.any((e) => e == 5))
        winners.add(i);
    }

    for (int winner in winners)
      order.add((boards[winner], number));
    for (int winner in winners.reversed)
      boards.removeAt(winner);
    winners.clear();
  }

  int score(BingoBoard board, int number) {
    int sum = 0;
    for (int x = 0; x < 5; x++)
      for (int y = 0; y < 5; y++)
        if (!board.marked[x].contains(y))
          sum += board.board[x][y];
    return sum * number;
  }

  print('Part 1: ${score(order.first.$1, order.first.$2)}');
  print('Part 2: ${score(order.last.$1, order.last.$2)}');
}
