import 'dart:math';
import 'package:flutter/material.dart';
import 'package:moonbook/utils.dart';

class DisclaimerWidget extends StatelessWidget {
  const DisclaimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = min(MediaQuery.of(context).size.height, 800);
    return Container(
      height: screenHeight * 0.15,
      color: Colors.grey[200],
      child: Center(
        child: Text(
          'Disclaimer: This app is created for the purpose of exploring and learning LLM. I will not be participating in the Gemini API Developer Competition.',
          style: fitTextStyle(context).apply(color: Colors.black),
          textAlign: TextAlign.center,
          maxLines: 5, // Set the maximum number of lines
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ),
    );
  }
}
