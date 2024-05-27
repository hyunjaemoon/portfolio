import 'package:flutter/material.dart';

class PromptWidget extends StatelessWidget {
  final String initialPrompt;
  final Function(String) onPromptChanged;
  final String promptEditorTitle;
  final String saveText;
  final String cancelText;

  const PromptWidget(
      {super.key,
      required this.initialPrompt,
      required this.onPromptChanged,
      required this.promptEditorTitle,
      required this.saveText,
      required this.cancelText});

  void _showPromptEditor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String userInput = '';
        return AlertDialog(
          title: Text(promptEditorTitle),
          content: TextField(
            onChanged: (value) {
              userInput = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Set the user input as the new prompt
                onPromptChanged(userInput);
                Navigator.of(context).pop();
              },
              child: Text(
                saveText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform any necessary operations when the user cancels the changes
                Navigator.of(context).pop();
              },
              child: Text(
                cancelText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showPromptEditor(context);
      },
      child: Text(
        initialPrompt,
        style: const TextStyle(
          color: Colors.purple,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
