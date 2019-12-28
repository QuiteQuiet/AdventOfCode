extension NumberParsing on String {
  int toInt({Function(String) onError}) => int.tryParse(this) ?? onError(this);
  double toDouble({Function(String) onError}) => double.tryParse(this) ?? onError(this);
}

extension SplitCache on String {
  static Map<String, Map<Pattern, List<String>>> cache = {};
  /// Split string by `s` and return index `i` from the resulting
  /// List. Will throw `RangeError` error if `i` is greater
  /// than the length of the resulting string.
  ///
  /// Strings will only be split once, for repeated splits of string by
  /// `s`, a cached result will be returned.
  String splitOne(Pattern pattern, [int index = 0]) {
    if (cache[this]?.containsKey(pattern) == true)
      return cache[this][pattern][index];
    return ((cache[this] ??= {})[pattern] = this.split(pattern))[index];
  }
}