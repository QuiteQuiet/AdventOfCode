import 'package:AdventOfCode/int.dart';

/// Two dimensional array implementation for Dart.
/// Contains standard iterator functions used for iterating
/// over lists, but applied as two dimensional.
class Grid<T> {
  late List<T> _cells;
  late int _w, _h;

  int get width => _w;
  int get height => _h;
  void set width(int i) => _w = i;
  void set height(int i) => _h = i;
  int get length => _cells.length;

  Set<(int, int)> _highlight = {};

  /// Get element from location `[x, y]` in the grid.
  T at(int x, int y) => _cells[y * _w + x];

  /// Set location `[x, y]` to `e`.
  T put(int x, int y, T e) => _cells[y * _w + x] = e;

  /// Mark grid position when printing in terminal
  void mark(int x, int y) => _highlight.add((x, y));

  /// Unmark tile position when printing in terminal
  bool unmark(int x, int y) => _highlight.remove((x, y));

  /// Increase grid size by one, without changing the dimensions of
  /// the grid.
  void add(T e) => this._cells.add(e);

  /// Default constructor
  Grid(this._w, this._h);
  /// Initiate a Grid of size `w` and height `h` filled with `e`.
  Grid.filled(this._w, this._h, T e) { _cells = List.filled(_h * _w, e, growable: true); }
  /// Initiate a Grid of size `w` and height `h` that calls function `e` to generate each element.
  Grid.generate(this._w, this._h, T Function(int i) e) { _cells = List.generate(_h * _w, e, growable: true); }

  /// Create Grid<T> from a compatible iterable.
  Grid.from(Iterable<Iterable<T>> it) {
    _w = 0;
    _h = 0;
    _cells = [];
    for (Iterable<T> itt in it) {
      for (T t in itt)
        _cells.add(t);
      if (_w == 0) _w = _cells.length;
    }
    _h = _cells.length ~/ _w;
  }

  /// Create Grid from multi-line String.
  /// Additional argument is conversion function to convert values from
  /// String int <T>.
  /// For example a Grid<int> might call this as `Grid.string(input, int.parse)`.
  /// A Grid<String> can give `Grid.string(input, (e) => e)`.
  Grid.string(String from, T Function(String) f) {
    _w = 0;
    _cells = [];
    for (String row in from.split(RegExp(r'\r?\n'))) {
      for (String e in row.split(''))
        _cells.add(f(e));
      if (_w == 0) _w = _cells.length;
    }
    _h = _cells.length ~/ _w;
  }

  /// Copy an existing grid into
  Grid.copy(Grid<T> from) {
    _w = from._w;
    _h = from._h;
    _cells = [];
    for (int y in 0.to(from._h - 1))
      for (int x in 0.to(from._w - 1))
        _cells.add(from.at(x, y));
  }

  /// Get string representation of a Grid.
  String toString() {
    List<String> s = [];
    for (int i in 0.to(_h - 1)) {
      for (int j in 0.to(_w - 1)) {
        String toAdd = at(j, i).toString();
        if (_highlight.contains((j, i))) {
          toAdd = '\x1B[35m$toAdd\x1B[0m';
        }
        s.add(toAdd);
      }
      s.add('\n');
    }
    s.removeLast();
    return s.join('');
  }

  /// Returns true if coordinate is inside the bounds of the Grid.
  bool hasCoord(int x, int y) => x < 0 || x >= _w || y < 0 || y >= _h;

  /// Iterate over Grid, and apply `func` on every item.
  void every(Function(int x, int y, T e) func) {
    for (int y in 0.to(_h - 1))
      for (int x in 0.to(_w - 1))
        func(x, y, at(x, y));
  }

  /// Iterate over adjacent grid elements (the cross)
  /// accounting for borders.
  void adjacent(int x, int y, Function(int x, int y, T el) func) {
    if (x - 1 >= 0) func(x - 1, y, at(x - 1, y));
    if (x + 1 < _w) func(x + 1, y, at(x + 1, y));
    if (y - 1 >= 0) func(x, y - 1, at(x, y - 1));
    if (y + 1 < _h) func(x, y + 1, at(x, y + 1));
  }

  /// Iterate over all elements close to an index in all directions.
  /// The full grid this will cover is:
  /// . . . . .
  /// . + + + .
  /// . + x + .
  /// . + + + .
  /// . . . . .
  void neighbours(int x, int y, Function(int x, int y, T el) func) {
    for (int i in (x - 1).to(x + 1)) {
      for (int j in (y - 1).to(y + 1)) {
        // The center and bounds
        if ((i == x && j == y) ||
            (i < 0 || i >= _w) ||
            (j < 0 || j >= _h))
          continue;
        func(i, j, at(i, j));
      }
    }
  }

  /// Take elements starting from `[x, y] that `func` returns `true` for.
  Iterable<T> takeFromWhile(int x, int y, bool Function(T) func) sync* {
    for (int i in x.to(_h - 1))
      if (func(at(i, y)))
        yield at(i, y);
      else
        return;
  }

  /// Apply mapped function `func` on the entire collection.
  Iterable<T> map(T Function(T) func) => _cells.map(func);
  Iterator<T> get iterator => _cells.iterator;
}