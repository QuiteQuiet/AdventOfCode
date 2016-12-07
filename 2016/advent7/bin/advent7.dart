void main() {
  // Dart regexp groups are broken, this can't be done easily :(
  bool valid = new RegExp('(.)\1').hasMatch('snyeeyubv');
  print(valid); // no match :|
}
