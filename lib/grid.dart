/// Two dimensional array implementation for Dart.
/// Contains standard iterator functions used for iterating
/// over lists, but applied as two dimensional.
class Grid<T> {
  List<T> _cells;
  int _w, _h;

  int get width => _w;
  int get height => _h;
  void set width(int i) => _w = i;
  void set height(int i) => _h = i;
  int get length => _cells.length;

  /// Get element from location `[x, y]` in the grid.
  T at(int x, int y) => _cells[y * _w + x];

  /// Set location `[x, y]` to `e`.
  T put(int x, int y, T e) => _cells[y * _w + x] = e;

  /// Increase grid size by one, without changing the dimensions of
  /// the grid.
  void add(T e) => this._cells.add(e);

  /// Default constructor
  Grid(this._w, this._h);
  /// Initiate a Grid of size `w` and height `h` filled with `e`.
  Grid.initiate(this._w, this._h, T e) { _cells = List.filled(_h * _w, e, growable: true); }

  String toString() {
    List<String> s = [];
    for (int i = 0; i < _h; i++) {
      for (int j = 0; j < _w; j++)
        s.add(at(j, i).toString());
      s.add('\n');
    }
    return s.join('');
  }

  /// Iterate over Grid, and apply `func` on every item.
  void enumerate(Function(int, int, T) func) {
    for (int i = 0; i < _h; i++)
      for (int j = 0; j < _w; j++)
        func(j, i, at(i, j));
  }

  /// Apply mapped function `func` on the entire collection.
  Iterable<T> map(Function func) => _cells.map(func);
  Iterator<T> get iterator => _cells.iterator;
}