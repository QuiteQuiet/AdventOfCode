import 'dart:io';

bool validTriangle(List<int> t) => t[0] + t[1] > t[2] && t[0] + t[2] > t[1] && t[1] + t[2] > t[0];
main() async {
  List<List<int>> triangles = new List.empty(growable: true);
  int vertical = 0;
  await new File('input.txt').readAsLines()
  .then((List<String> file) => triangles = file.map((s) => s.split(' ').where((s2) => s2.length > 0).toList().map(int.parse).toList()).toList());
  for (int i = 0; i < triangles.length; i += 3) {
    vertical += validTriangle([triangles[i][0], triangles[i + 1][0], triangles[i + 2][0]]) ? 1 : 0;
    vertical += validTriangle([triangles[i][1], triangles[i + 1][1], triangles[i + 2][1]]) ? 1 : 0;
    vertical += validTriangle([triangles[i][2], triangles[i + 1][2], triangles[i + 2][2]]) ? 1 : 0;
  }
  print('Part 1: ${triangles.where(validTriangle).toList().length}');
  print('Part 2: $vertical');
}
// Just because I can :)
//main() => print('Part1:${new File('input.txt').readAsLinesSync().map((s)=>s.split(' ').where((s2)=>s2.length>0).toList().map(int.parse).toList()..sort()).toList().where((t)=>t[0]+t[1]>t[2]).toList().length}');