import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moonbook/translation_game/disclaimer.dart';
import 'package:moonbook/translation_game/demo_page.dart';

class TranslationGameHomePage extends StatefulWidget {
  const TranslationGameHomePage({super.key});

  @override
  TranslationGameHomePageState createState() => TranslationGameHomePageState();
}

class TranslationGameHomePageState extends State<TranslationGameHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DisclaimerWidget(),
      body: Container(
        color: const Color(0xff0e0419),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 500,
                height: 500,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.translate(
                      offset: Offset(
                          0, 10 * sin(_animationController.value * 2 * pi)),
                      child: child,
                    );
                  },
                  child: Image.asset('assets/translation_video_game_logo.png'),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const TranslationGameDemoWidget(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = 0.0;
                        var end = 1.0;
                        var curve = Curves.easeInCubic;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return ScaleTransition(
                          scale: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Demo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Endless Mode (Coming Soon)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Story Mode (Coming Soon)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
