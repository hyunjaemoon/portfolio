import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchGithub() async {
  Uri url = Uri.parse('https://www.github.com/hyunjaemoon/');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

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
    double screenWidth = min(MediaQuery.of(context).size.width, 600);
    double screenHeight = min(MediaQuery.of(context).size.height, 800);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
              Text(
                'Hyun Jae Moon',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Center(
                child: Text(
                  'Software Engineer & Mobile App Developer',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: screenWidth * 0.05,
                    color: Colors.white.withOpacity(0.8),
                  ),
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
                          image: AssetImage('assets/profile_image.jpg'),
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
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Text(
                  'Welcome to my portfolio app! I am an experienced software engineer with a passion for creating visually appealing and user-friendly applications. Please feel free to browse my projects and contact me for any inquiries.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              ElevatedButton(
                onPressed: () {
                  _launchGithub();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Let\'s build something together',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
