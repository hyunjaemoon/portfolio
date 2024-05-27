import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ResultWidget extends StatelessWidget {
  final String instructionResult;
  final String result;
  final String instructionScore;
  final int score;

  BoxDecoration boxDecoration = BoxDecoration(
    border: Border.all(color: Colors.purple),
    borderRadius: BorderRadius.circular(8),
  );

  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 20);

  ResultWidget(
      {super.key,
      required this.score,
      required this.instructionResult,
      required this.result,
      required this.instructionScore});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: boxDecoration,
          child: Text(
            instructionResult,
            style: textStyle,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(8),
          decoration: boxDecoration,
          child: Text(
            result,
            style: textStyle,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(8),
          decoration: boxDecoration,
          child: Text(
            instructionScore,
            style: textStyle,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(8),
          decoration: boxDecoration,
          child: Text(
            score.toString(),
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
