extension NumberParsing on String {
  int toInt({Function(String) onError = print }) => int.tryParse(this) ?? onError(this);
  double toDouble({Function(String) onError = print}) => double.tryParse(this) ?? onError(this);
}

extension Operations on String {
  String removeLast(int n) => substring(0, length - n);
}