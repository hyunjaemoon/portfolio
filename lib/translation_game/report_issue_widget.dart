import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportIssue extends StatelessWidget {
  final String email = 'calhyunjaemoon@gmail.com';
  final String buttonText;

  const ReportIssue({super.key, required this.buttonText});

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Bug Report',
        'body': 'Please describe the issue you encountered:',
      },
    );

    if (await launchUrl(emailUri)) {
      return;
    } else {
      throw 'Could not launch email client';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _sendEmail,
        child: Text(
          buttonText,
          style: const TextStyle(
              color: Colors.purple, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
