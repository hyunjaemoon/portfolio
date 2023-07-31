import 'package:flutter/material.dart';
import 'package:moonbook/home.dart';
import 'package:moonbook/resume.dart';
import 'package:moonbook/timeline.dart';

void main() {
  runApp(PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hyun Jae Moon',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.orange),
      ),
      home: PortfolioMainPage(),
    );
  }
}

class PortfolioMainPage extends StatefulWidget {
  @override
  State<PortfolioMainPage> createState() => _PortfolioMainPageState();
}

class _PortfolioMainPageState extends State<PortfolioMainPage> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Moon Book"),
          leading: IconButton(
            icon: Icon(Icons.dark_mode),
            onPressed: () {
              setState(() {
                page = 0;
              });
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.timeline),
              onPressed: () {
                setState(() {
                  page = 1;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.note),
              onPressed: () {
                setState(() {
                  page = 2;
                });
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
        return TimelinePage();
      case 2:
        return ResumePage();
      default:
        return PortfolioHomePage();
    }
  }
}
