import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final int squaresPerRow = 20;
  final int squaresPerCol = 20;
  final int squareSize = 20;

  List<int> snakePosition = [45, 65, 85, 105, 125];
  int food = 300;
  String direction = 'down';

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Game Over'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Play Again'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      snakePosition = [45, 65, 85, 105, 125];
                      direction = 'down';
                    });
                  },
                )
              ],
            );
          },
        );
      }
    });
  }

  void updateSnake() {
    List<int> numbers = List.generate(squaresPerRow * squaresPerCol - 1, (int index) => index);
    numbers.shuffle(Random());
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 399) {
            snakePosition.add(snakePosition.last + 20 - 400);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;
        case 'up':
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last - 20 + 400);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;
        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        case 'right':
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
        default:
          break;
      }

      if (snakePosition.last == food) {
        // Generate new food position
        food = numbers.firstWhere((element) => !snakePosition.contains(element));
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    for (var i = 0; i < snakePosition.length; i++) {
      if (snakePosition.lastIndexOf(snakePosition[i]) != i) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (direction != 'up' && details.delta.dy > 0) {
                direction = 'down';
              } else if (direction != 'down' && details.delta.dy < 0) {
                direction = 'up';
              }
            },
            onHorizontalDragUpdate: (details) {
              if (direction != 'left' && details.delta.dx > 0) {
                direction = 'right';
              } else if (direction != 'right' && details.delta.dx < 0) {
                direction = 'left';
              }
            },
            child: buildGridView(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (direction != 'down') direction = 'up';
                },
                child: Text("Up"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (direction != 'up') direction = 'down';
                },
                child: Text("Down"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (direction != 'right') direction = 'left';
                },
                child: Text("Left"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (direction != 'left') direction = 'right';
                },
                child: Text("Right"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildGridView() {
    return AspectRatio(
      aspectRatio: squaresPerRow / (squaresPerCol + 5),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: squaresPerRow * squaresPerCol,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: squaresPerRow,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (snakePosition.contains(index)) {
            return partOfSnake();
          } else if (index == food) {
            return partOfFood();
          } else {
            return emptySquare();
          }
        },
      ),
    );
  }

  Widget partOfSnake() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget partOfFood() {
    return Container(
      padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget emptySquare() {
    return Container(
      padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.grey[900],
        ),
      ),
    );
  }
}
