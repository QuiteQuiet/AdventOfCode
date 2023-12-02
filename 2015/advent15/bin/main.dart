import 'dart:io';
import 'dart:math';

class Ingredient {
  int c, d, f, t, cal;
  Ingredient(this.c, this.d, this.f, this.t, this.cal);
}
int score(List<Ingredient> ingredients, List<int> distribution) {
  int c = 0, d = 0, f = 0, t = 0;
  for (int i = 0; i < ingredients.length; i++) {
    c += ingredients[i].c * distribution[i];
    d += ingredients[i].d * distribution[i];
    f += ingredients[i].f * distribution[i];
    t += ingredients[i].t * distribution[i];
  }
  return (max(0, c) * max(0, d) * max(0, f) * max(0, t)) as int;
}
int calories(List<Ingredient> ingredients, List<int> distribution) {
  int cal = 0;
  for (int i = 0; i < ingredients.length; i++) {
    cal += ingredients[i].cal * distribution[i];
  }
  return cal;
}

void main() {
  List<Ingredient> ingredients = new List<Ingredient>.empty(growable: true);
  List<int> dist = [1, 1, 1, 1], scores = new List<int>.empty(growable: true);
  new File('input.txt').readAsLinesSync().forEach((String line) {
    List<int> t = new RegExp(r'\-?[0-9]+').allMatches(line).map((m) => int.parse(m.group(0)!)).toList();
    ingredients.add(new Ingredient(t[0], t[1], t[2], t[3], t[4]));
  });
  while (dist.reduce((a, b) => a + b) < 100) {
    for (int i = 0; i < 4; i++) {
      scores.add(score(ingredients, new List.generate(4, (j) => i == j ? dist[j] + 1 : dist[j])));
    }
    int index = scores.indexOf(scores.reduce(max));
    dist[index]++;
    scores.clear();
  }
  print('Part 1: ${score(ingredients, dist)}');
}