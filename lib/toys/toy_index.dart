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
                icon: Image.asset(
                  "assets/translation_video_game_logo.png",
                  fit: BoxFit.cover, // Zoom in the image to fit the IconButton
                ),
                onPressed: () {
                  launchUrlCheck('linguaghost');
                },
              ),
              IconButton(
                icon: ClipOval(
                  child: Image.asset(
                    "assets/chanceshift_title.gif",
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
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class LlmPoweredGame extends StatefulWidget {
  @override
  _LlmPoweredGameState createState() => _LlmPoweredGameState();
}

class _LlmPoweredGameState extends State<LlmPoweredGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LLM Powered Game'),
      ),
      body: Center(
        child: Text('This is the LLM powered game page.'),
      ),
    );
  }
}
