import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonbook/toys/toy_index.dart';
import 'package:moonbook/home.dart';
import 'package:moonbook/utils.dart';
import 'package:url_launcher/url_launcher.dart';

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

Future<void> _emailDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Send Email'),
        content: const Text('Sending email to calhyunjaemoon@gmail.com?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'calhyunjaemoon@gmail.com',
                query: 'subject=Inquiries from Moon Book',
              );
              await launchUrl(emailUri);
            },
            child: const Text('Send'),
          ),
        ],
      );
    },
  );
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
                tooltip: "Email",
                icon: const Icon(Icons.email),
                onPressed: () => _emailDialog(context),
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
        bottomNavigationBar: copyrightBottomAppBar(context));
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
