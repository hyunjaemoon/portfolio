import 'package:flutter/material.dart';

class UserInput extends StatelessWidget {
  final InputDecoration decoration;
  final TextEditingController controller;

  const UserInput({
    Key? key,
    required this.decoration,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: decoration,
      keyboardType: TextInputType.text,
      cursorColor: Colors.white,
    );
  }
}
