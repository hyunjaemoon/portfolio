import 'package:flutter/material.dart';

typedef FutureCallback = Future<void> Function();

class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final String buttonText;
  final FutureCallback onPressed;

  const SubmitButton({
    super.key,
    required this.isLoading,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    onButtonPressed() async {
      if (isLoading) {
        return;
      }
      await onPressed();
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purpleAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      onPressed: isLoading ? null : onButtonPressed,
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(
              buttonText,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
    );
  }
}
