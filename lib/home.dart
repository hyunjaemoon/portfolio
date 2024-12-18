import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonbook/utils.dart';
import 'package:simple_icons/simple_icons.dart';

class PortfolioHomePage extends StatefulWidget {
  @override
  _PortfolioHomePageState createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimationProfile;
  late Animation<Offset> _offsetAnimationPen;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _offsetAnimationProfile = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _offsetAnimationPen = Tween<Offset>(
      begin: Offset(2.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = min(MediaQuery.of(context).size.width, 450);
    double screenHeight = min(MediaQuery.of(context).size.height, 800);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
            begin: Alignment.center,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Hyun Jae Moon',
                  style: GoogleFonts.openSans(
                      fontSize: screenWidth * 0.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: screenHeight * 0.025),
              Center(
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Software Engineer',
                      textAlign: TextAlign.center,
                      textStyle: GoogleFonts.openSans(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.5),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Stack(
                children: [
                  SlideTransition(
                    position: _offsetAnimationProfile,
                    child: Container(
                      width: screenWidth * 0.5,
                      height: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/profile_image.gif'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 6,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SlideTransition(
                      position: _offsetAnimationPen,
                      child: Container(
                        width: screenWidth * 0.125,
                        height: screenWidth * 0.125,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: "GitHub",
                    icon: Icon(
                      SimpleIcons.github,
                      color: SimpleIconColors.github,
                      size: screenWidth * 0.1,
                    ),
                    onPressed: () {
                      launchUrlCheck("github");
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  IconButton(
                    tooltip: "Android Open Source Project",
                    icon: Icon(
                      SimpleIcons.android,
                      color: Colors.black,
                      size: screenWidth * 0.1,
                    ),
                    onPressed: () {
                      launchUrlCheck("aosp");
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  IconButton(
                    tooltip: "LinkedIn",
                    icon: Icon(
                      SimpleIcons.linkedin,
                      color: Colors.black,
                      size: screenWidth * 0.1,
                    ),
                    onPressed: () {
                      launchUrlCheck("linkedin");
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  IconButton(
                    tooltip: "Resume",
                    icon: Icon(
                      Icons.edit_document,
                      color: Colors.black,
                      size: screenWidth * 0.1,
                    ),
                    onPressed: () {
                      launchUrlCheck("resumepdf");
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  IconButton(
                    tooltip: "Email",
                    icon: Icon(
                      Icons.email,
                      color: Colors.black,
                      size: screenWidth * 0.1,
                    ),
                    onPressed: () {
                      sendEmail();
                    },
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
            ]),
          ),
        ),
      ),
    );
  }
}
