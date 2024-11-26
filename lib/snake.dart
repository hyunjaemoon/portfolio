import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonbook/snake_ai.dart';

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final int squaresPerRow = 20;
  final int squaresPerCol = 20;
  final int squareSize = 20;

  List<int> snakePosition = [45, 65, 85, 105, 125];
  List<int> numbers = List.generate(400, (int index) => index);
  int food = 300;
  String direction = 'down';
  bool hasMoved = false;

  // Snake AI Logic
  SnakeAI ai = SnakeAI();
  bool isAIActive = false;

  void startAI() {
    setState(() {
      isAIActive = !isAIActive; // Toggle AI on and off
    });
  }

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startGame() {
    numbers.shuffle(Random());
    Timer.periodic(Duration(milliseconds: 300), (Timer timer) {
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
                    startGame();
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
    if (!mounted) {
      return;
    }
    setState(() {
      if (isAIActive) {
        direction = ai.getDirection(
            direction, snakePosition, food); // Let AI decide the direction
      }
      switch (direction) {
        case 'down':
          if (snakePosition.last > 379) {
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
        food =
            numbers.firstWhere((element) => !snakePosition.contains(element));
      } else {
        snakePosition.removeAt(0);
      }

      hasMoved = false; // Reset flag after each update
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
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (!hasMoved && event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
              direction != 'down') {
            direction = 'up';
            hasMoved = true;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
              direction != 'up') {
            direction = 'down';
            hasMoved = true;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
              direction != 'right') {
            direction = 'left';
            hasMoved = true;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
              direction != 'left') {
            direction = 'right';
            hasMoved = true;
          }
        }
      },
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (!hasMoved && direction != 'up' && details.delta.dy > 0) {
                    direction = 'down';
                    hasMoved = true;
                  } else if (direction != 'down' && details.delta.dy < 0) {
                    direction = 'up';
                    hasMoved = true;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (direction != 'left' && details.delta.dx > 0) {
                    direction = 'right';
                    hasMoved = true;
                  } else if (direction != 'right' && details.delta.dx < 0) {
                    direction = 'left';
                    hasMoved = true;
                  }
                },
                child: buildGridView(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (!hasMoved && direction != 'down') {
                            direction = 'up';
                            hasMoved = true;
                          }
                        },
                        child: Icon(Icons.arrow_upward),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding:
                              EdgeInsets.all(20.0), // Adjust the button size
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (!hasMoved && direction != 'right') {
                                direction = 'left';
                                hasMoved = true;
                              }
                            },
                            child: Icon(Icons.arrow_back),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(
                                  20.0), // Adjust the button size
                            ),
                          ),
                          SizedBox(
                              width: 80.0,
                              height: 80.0), // Placeholder for spacing
                          ElevatedButton(
                            onPressed: () {
                              if (!hasMoved && direction != 'left') {
                                direction = 'right';
                                hasMoved = true;
                              }
                            },
                            child: Icon(Icons.arrow_forward),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(
                                  20.0), // Adjust the button size
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (!hasMoved && direction != 'up') {
                            direction = 'down';
                            hasMoved = true;
                          }
                        },
                        child: Icon(Icons.arrow_downward),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding:
                              EdgeInsets.all(20.0), // Adjust the button size
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Toggle AI solving
                startAI();
              },
              child: Text(isAIActive ? "Disable AI" : "Let AI Solve"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
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
