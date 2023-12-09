extension RangeIterable on int {
  Iterable<int> to(int count, {int step = 1}) sync* {
    for (int i = this; i <= count; i += step) {
      yield i;
    }
  }
}