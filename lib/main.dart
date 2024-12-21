import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonbook/toys/toy_index.dart';
import 'package:moonbook/home.dart';
import 'package:moonbook/utils.dart';

void main() {
  if (kDebugMode) {
    dotenv.load(fileName: ".env");
  }
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
          title: Text("Moon Book",
              style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
          leading: IconButton(
            tooltip: "Main Page",
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              setState(() {
                page = 0;
              });
            },
          ),
          actions: <Widget>[
            IconButton(
              tooltip: "AI Powered Toys",
              icon: const Icon(Icons.gamepad),
              onPressed: () {
                setState(() {
                  page = 1;
                });
              },
            ),
            IconButton(
              tooltip: "License",
              icon: const Icon(Icons.shield),
              onPressed: () {
                launchUrlCheck('license');
              },
            ),
          ]),
      body: _buildBody(),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '© Hyun Jae Moon ${DateTime.now().year}',
            style: GoogleFonts.openSans(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (page) {
      case 0:
        return PortfolioHomePage();
      case 1:
        return AiHomePage();
      default:
        return PortfolioHomePage();
    }
  }
}
