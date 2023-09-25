import 'dart:collection';

class SnakeAI {
  static const List<List<int>> directions = [
    [0, -1], // up
    [0, 1], // down
    [-1, 0], // left
    [1, 0], // right
  ];

  String getDirection(
      String currentDirection, List<int> snakePosition, int food) {
    int snakeHead = snakePosition.last;
    int snakeHeadX = snakeHead % 20;
    int snakeHeadY = snakeHead ~/ 20;
    int foodX = food % 20;
    int foodY = food ~/ 20;

    List<int> pathToFood =
        aStar(snakeHeadX, snakeHeadY, foodX, foodY, snakePosition);

    if (pathToFood.isNotEmpty) {
      int nextCell = pathToFood[0];
      if (nextCell == snakeHead + 1) return "right";
      if (nextCell == snakeHead - 1) return "left";
      if (nextCell == snakeHead + 20) return "down";
      if (nextCell == snakeHead - 20) return "up";
    }

    return currentDirection; // fallback to current direction if no valid path found
  }

  List<int> aStar(int startX, int startY, int endX, int endY, List<int> snake) {
    Set<int> closedSet = {};
    Queue<Map<String, dynamic>> openSet = Queue.from([
      {
        'x': startX,
        'y': startY,
        'g': 0,
        'h': _heuristic(startX, startY, endX, endY),
        'parent': null
      }
    ]);
    Map<String, Map<String, dynamic>> nodes = {};

    while (openSet.isNotEmpty) {
      var current = openSet.removeFirst();
      if (current['x'] == endX && current['y'] == endY) {
        return _reconstructPath(nodes, current);
      }

      closedSet.add(current['y'] * 20 + current['x']);

      for (var direction in directions) {
        int newX = current['x'] + direction[0];
        int newY = current['y'] + direction[1];

        if (newX < 0 || newY < 0 || newX >= 20 || newY >= 20)
          continue; // check boundaries

        int index = newY * 20 + newX;
        if (closedSet.contains(index) || snake.contains(index))
          continue; // check closedSet or snake body

        double tentativeG = current['g'] + 1;
        if (!nodes.containsKey('$newX|$newY') ||
            tentativeG < nodes['$newX|$newY']!['g']) {
          nodes['$newX|$newY'] = {
            'x': newX,
            'y': newY,
            'g': tentativeG,
            'h': _heuristic(newX, newY, endX, endY),
            'parent': current
          };
          if (!openSet.any((node) => node['x'] == newX && node['y'] == newY)) {
            openSet.add(nodes['$newX|$newY']!);
          }
        }
      }
      openSet = Queue.from(openSet.toList()
        ..sort((a, b) => (a['g'] + a['h']).compareTo(b['g'] + b['h'])));
    }

    return []; // Return empty list if no path found
  }

  double _heuristic(int x1, int y1, int x2, int y2) {
    return ((x1 - x2).abs() + (y1 - y2).abs()).toDouble();
  }

  List<int> _reconstructPath(
      Map<String, Map<String, dynamic>> nodes, Map<String, dynamic> current) {
    List<int> totalPath = [current['y'] * 20 + current['x']];
    while (nodes.containsKey('${current['x']}|${current['y']}') &&
        nodes['${current['x']}|${current['y']}']!['parent'] != null) {
      current = nodes['${current['x']}|${current['y']}']!['parent'];
      totalPath.insert(0, current['y'] * 20 + current['x']);
    }
    totalPath.removeAt(0); // remove current position
    return totalPath;
  }
}
