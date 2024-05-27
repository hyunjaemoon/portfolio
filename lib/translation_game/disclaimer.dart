import 'package:flutter/material.dart';
import 'package:moonbook/utils.dart';

class DisclaimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey[200],
      child: Center(
        child: Text(
          '''Disclaimer: This app is created for the purpose of exploring and learning LLM. I will not be participating in the Gemini API Developer Competition.''',
          style: fitTextStyle(context).apply(
            fontSizeFactor: 0.5,
            color: Colors.black,
          ),
          // style: TextStyle(
          //   fontSize: 15,
          //   fontWeight: FontWeight.bold,
          //   color: Colors.black,
          // ),
          textAlign: TextAlign.center,
          maxLines: 2, // Set the maximum number of lines
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ),
    );
  }
}
