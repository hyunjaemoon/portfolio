import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moonbook/home.dart';
import 'package:moonbook/resume.dart';
import 'package:moonbook/snake.dart';
import 'package:moonbook/translation_game.dart';
import 'package:moonbook/utils.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hyun Jae Moon',
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
          title: const Text("Moon Book"),
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
              icon: const Icon(Icons.science),
              onPressed: () {
                setState(() {
                  page = 1;
                });
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
              icon: const Icon(Icons.note),
              onPressed: () {
                setState(() {
                  page = 3;
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
        return const AIRequestWidget();
      case 2:
        return SnakeGame();
      case 3:
        return ResumePage();
      default:
        return PortfolioHomePage();
    }
  }
}
