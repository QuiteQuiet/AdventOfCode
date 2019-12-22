import 'dart:io';

List<int> deal(List<int> deck) => deck.reversed.toList();
List<int> shift(List<int> deck, int index) {
  if (index < 0) {
    int i = (deck.length + index) % deck.length;
    return deck.sublist(i)..addAll(deck.sublist(0, i));
  } else {
    int i = index % deck.length;
    return deck.sublist(i)..addAll(deck.sublist(0, i));
  }
}
List<int> spread(List<int> deck, int size) {
  List<int> newDeck = List.generate(deck.length, (i) => null);
  int index = 0;
  for (int i = 0; i < deck.length; i++) {
    newDeck[index] = deck[i];
    index = (index + size) % deck.length;
  }
  return newDeck;
}

void main() {
  List<String> input = File('input.txt').readAsLinesSync();
  List<int> deck = List.generate(10007, (i) => i);
  for (String line in input) {
    if (line == 'deal into new stack')
      deck = deal(deck);
    else if (line.startsWith('cut'))
      deck = shift(deck, int.parse(line.substring(4)));
    else if (line.startsWith('deal with increment'))
      deck = spread(deck, int.parse(line.substring(20)));
  }
  print('Part 1: ${deck.indexOf(2019)}');

  // the "I don't understand math enough for this" part
  BigInt cards = BigInt.from(119315717514047);
  BigInt shuffles = BigInt.from(101741582076661);
  BigInt offsetDiff = BigInt.from(0), incMul = BigInt.from(1);

  BigInt inv(BigInt n) => n.modPow(cards - BigInt.from(2), cards);
  for (String line in input) {
    if (line == 'deal into new stack') {
      incMul *= BigInt.from(-1);
      incMul %= cards;
      offsetDiff += incMul;
      offsetDiff %= cards;
    } else if (line.startsWith('cut')) {
      offsetDiff += incMul * BigInt.from(int.parse(line.substring(4)));
      offsetDiff %= cards;
    } else if (line.startsWith('deal with increment')) {
      incMul *= inv(BigInt.from(int.parse(line.substring(20))));
      incMul %= cards;
    }
  }
  BigInt inc = incMul.modPow(shuffles, cards);
  BigInt offset = offsetDiff * (BigInt.from(1) - inc) * inv((BigInt.from(1) - incMul) % cards);
  BigInt card = (offset + inc * BigInt.from(2020)) % cards;
  print('Part 2: $card');
}