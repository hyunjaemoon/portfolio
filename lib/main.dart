import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moonbook/home.dart';
import 'package:moonbook/snake.dart';
import 'package:moonbook/translation_game/demo_page.dart';
import 'package:moonbook/utils.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moon Book',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.orange),
      ),
      home: const PortfolioMainPage(),
    );
  }
}

class PortfolioMainPage extends StatefulWidget {
  const PortfolioMainPage({super.key});

  @override
  State<PortfolioMainPage> createState() => _PortfolioMainPageState();
}

class _PortfolioMainPageState extends State<PortfolioMainPage> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Moon Book", style: fitTextStyle(context)),
          leading: IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              setState(() {
                page = 0;
              });
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                "assets/translation_video_game_logo.png",
                width: 35, // Adjust the width to make the image smaller
                height: 35, // Adjust the height to make the image smaller
                fit: BoxFit.contain, // Zoom in the image to fit the IconButton
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Choose Version'),
                      content: Text(
                          'Do you want the old version or the new version?'),
                      actions: [
                        TextButton(
                          child: Text('Old Version'),
                          onPressed: () {
                            setState(() {
                              page = 1;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('New Version'),
                          onPressed: () {
                            launchUrlCheck('linguaghost');
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.staffSnake,
              ),
              onPressed: () {
                setState(() {
                  page = 2;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.shield),
              onPressed: () {
                launchUrlCheck('license');
              },
            ),
          ]),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (page) {
      case 0:
        return PortfolioHomePage();
      case 1:
        return const TranslationGameDemoWidget();
      case 2:
        return SnakeGame();
      default:
        return PortfolioHomePage();
    }
  }
}
