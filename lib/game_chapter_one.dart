import 'package:flutter/material.dart';
import 'package:moonbook/snake.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class MyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moon Saga: Chapter 1',
      home: IntroScreen(),
    );
  }
}

class RainDrop {
  double x;
  double y;
  double length;
  double width;

  RainDrop(
      {required this.x,
      required this.y,
      required this.length,
      required this.width});
}

class RainDropPainter extends CustomPainter {
  final double animationValue;
  final int numberOfDrops;
  final Color rainColor;
  final List<RainDrop> rainDrops;
  final double screenHeight;

  RainDropPainter({
    required this.animationValue,
    this.numberOfDrops = 100,
    this.rainColor = Colors.white70,
    required this.screenHeight,
  }) : rainDrops = List.generate(
          numberOfDrops,
          (index) => RainDrop(
            x: Random().nextDouble() * screenHeight,
            y: Random().nextDouble() * screenHeight,
            length: Random().nextDouble() * 10 + 5,
            width: Random().nextDouble() * 2 + 1,
          ),
        );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = rainColor;
    for (var drop in rainDrops) {
      drop.y += animationValue; // Move the raindrop down
      if (drop.y > size.height) {
        drop.y = -drop.length; // Reset the raindrop to the top
      }
      canvas.drawLine(
          Offset(drop.x, drop.y),
          Offset(drop.x, drop.y + drop.length),
          paint..strokeWidth = drop.width);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _titleAnimation;
  late Animation<double> _sentence1Animation;
  late Animation<double> _sentence2Animation;

  // Add a new animation controller for rain effect
  late AnimationController _rainController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..forward();

    // Initialize the rain animation controller
    _rainController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _titleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn), // Fade in
      ),
    );

    _sentence1Animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.7, curve: Curves.easeIn), // Fade in after title
      ),
    );

    _sentence2Animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 0.9,
            curve: Curves.easeIn), // Fade in after sentence 1
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NextScreen()),
        );
      }
    });

    // Play rain sound
    _playRainSound();
  }

  @override
  void dispose() {
    _controller.dispose();
    _rainController.dispose();
    _audioPlayer.stop();
    super.dispose();
  }

  Future<void> _playRainSound() async {
    final result = await _audioPlayer.play('assets/rain.mp3', volume: 0.5);
    if (result == 1) {
      // success
      Future.delayed(Duration(seconds: 6), () {
        _audioPlayer.stop();
      });
    } else {
      // error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        // Rain effect
        AnimatedBuilder(
          animation: _rainController,
          builder: (context, child) {
            return CustomPaint(
              painter: RainDropPainter(
                  animationValue: _rainController.value,
                  screenHeight: MediaQuery.of(context).size.height),
              size: MediaQuery.of(context).size,
            );
          },
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeTransition(
                opacity: _titleAnimation,
                child: Text(
                  'Moon Saga: Chapter 1',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              FadeTransition(
                opacity: _sentence1Animation,
                child: Text(
                  'An Epic Adventure',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              FadeTransition(
                opacity: _sentence2Animation,
                child: Text(
                  'Begins Now',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Currently in Construction!',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 20), // Add some space
            ElevatedButton(
              onPressed: () {
                // Navigate to the SnakeGame widget
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SnakeGame()),
                );
              },
              child: Text('Play Snake Game'),
            ),
          ],
        ),
      ),
    );
  }
}
