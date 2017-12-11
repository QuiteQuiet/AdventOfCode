import 'dart:io';

class Node {
  int w, subw = 0, diff;
  String id;
  List<String> subtree;
  Node(this.id, this.w) { this.subtree = new List<String>();}
  void add(String n) => this.subtree.add(n);
}

int calcTreeWeight(Node root, Map<String, Node> allNodes) {
  if (root.subtree.length < 1) return root.w;
  List<int> subtreeWeights = new List<int>();
  for (String sub in root.subtree) {
    int w = calcTreeWeight(allNodes[sub], allNodes);
    subtreeWeights.add(w);
    if (subtreeWeights.any((i) => i != w)) {
      // bestest way ever to return something, throw an error!
      Node uneven = allNodes[sub];
      uneven.diff = w - subtreeWeights.firstWhere((i) => uneven.w != i);
      throw uneven;
    }
  }
  return root.w + subtreeWeights.reduce((a, b) => a + b);
}

main() async {
  Map<String, Node> allNodes = new Map<String, Node>();
  Map<String, bool> inSubtree = new Map<String, bool>();
  RegExp weightFind = new RegExp(r'\d+');
  await new File('advent7/input.txt').readAsLines()
  .then((List<String> file) {
    file.forEach((String line) {
      if (!line.contains('->')) {
        String nodeid = line.split(' ')[0];
        allNodes[nodeid] = new Node(nodeid, int.parse(weightFind.firstMatch(line).group(0)));
        return;
      }
      List<String> stuff = line.split('->');
      String node = stuff[0], nodeid = node.split(' ')[0];
      allNodes[nodeid] = new Node(nodeid, int.parse(weightFind.firstMatch(node).group(0)));
      for (String bit in stuff[1].trim().split(', ')) {
        allNodes[nodeid].add(bit);
        inSubtree[bit] = true;
      }
    });
    String unique;
    for (String id in allNodes.keys) {
      if (!inSubtree.containsKey(id)) {
        unique = id;
        break;
      }
    }
    print('Part 1: ${unique}');
    Stopwatch time = new Stopwatch()..start();
    try {
      calcTreeWeight(allNodes[unique], allNodes);
    } catch (e) {
      print('Part 2: ${e.w - e.diff} in ${time.elapsed}');
    }
  });

}