import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonbook/snake.dart';
import 'package:moonbook/utils.dart';

class AiHomePage extends StatefulWidget {
  @override
  _AiHomePageState createState() => _AiHomePageState();
}

class _AiHomePageState extends State<AiHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Powered Toys",
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.count(
            crossAxisCount: 2 +
                (constraints.maxWidth > (constraints.maxHeight * 1.5)
                    ? 2
                    : (constraints.maxWidth > constraints.maxHeight ? 1 : 0)),
            children: [
              IconButton(
                tooltip: "Translation Game",
                icon: Image.asset(
                  "assets/translation_video_game_logo.png",
                  fit: BoxFit.cover, // Zoom in the image to fit the IconButton
                ),
                onPressed: () {
                  launchUrlCheck('linguaghost');
                },
              ),
              IconButton(
                tooltip: "ChanceShift",
                icon: ClipOval(
                  child: Image.asset(
                    "assets/chanceshift_title.png",
                    fit: BoxFit.cover, // Crop the image to fit the IconButton
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(
                              "ChanceShift is currently under construction",
                              style: GoogleFonts.openSans(),
                            ),
                          ));
                },
              ),
              IconButton(
                tooltip: "Snake Game",
                icon: LayoutBuilder(
                  builder: (context, constraints) {
                    return FaIcon(FontAwesomeIcons.staffSnake,
                        color: Colors.white, size: constraints.maxWidth / 2);
                  },
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SnakeGame()),
                  );
                },
              ),
              IconButton(
                tooltip: "Software Consulting Chatbot",
                icon: LayoutBuilder(
                  builder: (context, constraints) {
                    return Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: constraints.maxWidth / 2,
                    );
                  },
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(
                              "Software Consulting Chatbot is currently under construction",
                              style: GoogleFonts.openSans(),
                            ),
                          ));
                  // TODO: Implement the chatbot
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ChatbotScreen()),
                  // );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
