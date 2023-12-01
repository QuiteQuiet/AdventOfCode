extension NumberParsing on String {
  int toInt({Function(String) onError = print }) => int.tryParse(this) ?? onError(this);
  double toDouble({Function(String) onError = print}) => double.tryParse(this) ?? onError(this);
}