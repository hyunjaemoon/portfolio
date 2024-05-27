import 'package:easy_loading_button/easy_loading_button.dart';
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

    return EasyButton(
      type: EasyButtonType.elevated,
      idleStateWidget: Text(buttonText,
          style: const TextStyle(color: Colors.white, fontSize: 20)),
      loadingStateWidget: const CircularProgressIndicator(),
      useWidthAnimation: true,
      useEqualLoadingStateWidgetDimension: true,
      width: 150.0,
      height: 40.0,
      borderRadius: 4.0,
      elevation: 0.0,
      contentGap: 6.0,
      buttonColor: Colors.purpleAccent,
      onPressed: isLoading ? null : onButtonPressed,
    );
  }
}
