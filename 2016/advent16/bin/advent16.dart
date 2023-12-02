String curve(String data) => '${data}0${data.split('').reversed.map((s) => s == "0" ? "1" : "0").toList().join()}';
String sum(String data) {
  List<String> sum = new List.empty(growable: true);
  for (int i = 0; i < data.length; i +=2) {
    sum.add(data[i] == data[i+1] ? '1' : '0');
  }
  return sum.join();
}
void main() {
  String input = "10001001100000001", tmp;
  List<int> required = [272, 35651584];
  for (int i = 0; i < required.length; i++) {
    tmp = input;
    while (tmp.length < required[i]) {
      tmp = curve(tmp);
    }
    tmp = tmp.substring(0, required[i]);
    while (tmp.length % 2 == 0) {
      tmp = sum(tmp);
    }
    print('Part ${i+1}: $tmp');
  }
}
