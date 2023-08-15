import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SnakeHomePage extends StatefulWidget {
  @override
  _SnakeHomePageState createState() => _SnakeHomePageState();
}

class _SnakeHomePageState extends State<SnakeHomePage> {
  final int squaresPerRow = 20;
  final int squaresPerCol = 20;
  final squareSize = 20.0;
  List<int> snakePosition = [85, 105, 125];
  int food = 300;
  var direction = 'down';
  var gameOn = true;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    const duration = Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      _moveSnake();
      if (_checkGameOver()) {
        timer.cancel();
        _showGameOverScreen();
      }
    });
  }

  void _moveSnake() {
    setState(() {
      switch (direction) {
        case 'up':
          if (snakePosition.first < squaresPerRow) {
            snakePosition.insert(
                0,
                snakePosition.first -
                    squaresPerRow +
                    squaresPerRow * squaresPerCol);
          } else {
            snakePosition.insert(0, snakePosition.first - squaresPerRow);
          }
          break;
        case 'down':
          if (snakePosition.first > squaresPerRow * (squaresPerCol - 1)) {
            snakePosition.insert(
                0,
                snakePosition.first +
                    squaresPerRow -
                    squaresPerRow * squaresPerCol);
          } else {
            snakePosition.insert(0, snakePosition.first + squaresPerRow);
          }
          break;
        case 'left':
          if (snakePosition.first % squaresPerRow == 0) {
            snakePosition.insert(0, snakePosition.first + squaresPerRow - 1);
          } else {
            snakePosition.insert(0, snakePosition.first - 1);
          }
          break;
        case 'right':
          if ((snakePosition.first + 1) % squaresPerRow == 0) {
            snakePosition.insert(0, snakePosition.first - squaresPerRow + 1);
          } else {
            snakePosition.insert(0, snakePosition.first + 1);
          }
          break;
        default:
          return;
      }
      if (snakePosition.first == food) {
        // Increase snake length
        setState(() {
          food = Random().nextInt(squaresPerRow * squaresPerCol);
        });
      } else {
        snakePosition.removeLast();
      }
    });
  }

  bool _checkGameOver() {
    print(snakePosition);
    if (!gameOn ||
        snakePosition.first < 0 ||
        snakePosition.first >= squaresPerRow * squaresPerCol ||
        snakePosition.skip(1).contains(snakePosition.first)) {
      return true;
    }
    return false;
  }

  void _showGameOverScreen() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text('Score: ${snakePosition.length}'),
            actions: <Widget>[
              TextButton(
                child: Text('Play Again'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    snakePosition = [45, 65, 85];
                    food = 300;
                    direction = 'down';
                    gameOn = true;
                    _startGame();
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game'),
      ),
      body: Column(
        children: <Widget>[
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
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: squaresPerRow,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (snakePosition.contains(index)) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(color: Colors.green),
                        ),
                      ),
                    );
                  } else if (index == food) {
                    return Container(
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(color: Colors.red),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () => direction = 'up',
                  child: Icon(Icons.arrow_upward),
                ),
                Row(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () => direction = 'left',
                      child: Icon(Icons.arrow_back),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      onPressed: () => direction = 'right',
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                FloatingActionButton(
                  onPressed: () => direction = 'down',
                  child: Icon(Icons.arrow_downward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
