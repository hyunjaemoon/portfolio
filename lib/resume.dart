import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              Uri url = Uri.parse('https://www.linkedin.com/in/hyunjaemoon/');
              if (!await launchUrl(url)) {
                throw Exception("Could not launch $url");
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
            ),
            child: Text('Open Linkedin Profile'),
          ),
        ],
      ),
    );
  }
}
