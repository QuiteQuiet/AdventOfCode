import 'package:AdventOfCode/aoc_help/get.dart' as aoc;
import 'package:AdventOfCode/grid.dart';
import 'package:AdventOfCode/space.dart';

class Cart {
  Point pos, dir;
  int turn;
  bool crashed = false, moved = false;
  Cart(this.pos, this.dir, [this.turn = 0]);
}

void main() async {
  Grid<String> track = Grid.string(await aoc.getInputString(), (e) => e);

  List<List<Cart>> minecarts = List.generate(track.height, (i) => []);
  track.every((x, y, e) {
    Cart? cart = switch (e) {
       '<' => Cart(Point(x, y), Point(-1, 0)),
       '^' => Cart(Point(x, y), Point(0, -1)),
       '>' => Cart(Point(x, y), Point(1, 0)),
       'v' => Cart(Point(x, y), Point(0, 1)),
       _ => null,
    };
    if (cart != null) {
      minecarts[y].add(cart);
      track.put(x, y, {'<': '-', '>': '-', '^': '|', 'v': '|'}[track.at(x, y)]!);
    }
  });

  Point? firstCrash;
  int cartCount = minecarts.fold(0, (s, e) => s + e.length);
  while (cartCount > 1) {
    List<List<Cart>> tmp = List.generate(minecarts.length, (i) => []);
    for (final List<Cart> carts in minecarts) {
      carts.sort((a, b) => (a.dir.x - b.dir.x).toInt());
      for (Cart cart in carts) {
        Point next = cart.pos + cart.dir;

        int ny = next.y.toInt();
        List<Cart> newPos = tmp[ny];
        if (minecarts[ny].any((e) => e.pos == next && !e.moved)) {
          firstCrash ??= next;
          cart.crashed = true;
          minecarts[ny].firstWhere((e) => e.pos == next).crashed = true;
        }
        if (newPos.any((e) => e.pos == next)) {
          cart.crashed = true;
          newPos.removeWhere((e) => e.pos == next);
        }
        if (cart.crashed) {
          continue;
        }
        Point direction = switch (track.atPoint(next)) {
          r'\' => Point(cart.dir.y, cart.dir.x),
          r'/' => Point(-cart.dir.y, -cart.dir.x),
          r'+' => switch (cart.dir.x) {
            0 => [Point(cart.dir.y, cart.dir.x), cart.dir, Point(-cart.dir.y, -cart.dir.x)][cart.turn++],
            _ => [Point(-cart.dir.y, -cart.dir.x), cart.dir, Point(cart.dir.y, cart.dir.x)][cart.turn++],
          },
          _ => cart.dir,
        };
        cart.moved = true;
        newPos.add(Cart(next, direction, cart.turn % 3));
      }
    }
    minecarts.clear();
    minecarts = tmp;
    cartCount = minecarts.fold(0, (s, e) => s + e.length);
  }
  print('Part 1: ${firstCrash!.x},${firstCrash.y}');
  Point last = minecarts.firstWhere((e) => e.length > 0).first.pos;
  print('Part 2: ${last.x},${last.y}');
}
