// ignore: unused_import
import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moonbook/translation_game/api_interface.dart';
import 'package:moonbook/translation_game/disclaimer.dart';
import 'package:moonbook/translation_game/instructions.dart';

class TranslationGameWidget extends StatefulWidget {
  const TranslationGameWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TranslationGameWidgetState createState() => _TranslationGameWidgetState();
}

class _TranslationGameWidgetState extends State<TranslationGameWidget>
    with SingleTickerProviderStateMixin {
  late Instructions _instructions;
  late TextEditingController _textController;
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  final ApiService _apiService = ApiService();

  late String _primaryLanguage;
  late String _secondaryLanguage;

  String response = '';
  bool isKorean = true; // Track the current language direction

  @override
  void initState() {
    super.initState();
    dotenv.load(fileName: '.env');
    _textController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: const Offset(0, 0.1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _instructions = isKorean ? KoreanInstructions() : EnglishInstructions();

    _primaryLanguage = isKorean ? 'Korean' : 'English';
    _secondaryLanguage = isKorean ? 'English' : 'Korean';
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> sendAIRequest() async {
    try {
      final apiResponse = await _apiService.sendAIRequest(
        primaryLanguage: _primaryLanguage,
        secondaryLanguage: _secondaryLanguage,
        prompt: _instructions.prompt,
        userInput: _textController.text,
      );

      setState(() {
        response = apiResponse;
      });
    } catch (e) {
      setState(() {
        response = 'Error: ${e.toString()}';
      });
    }
  }

  void toggleLanguageDirection(value) {
    setState(() {
      isKorean = value; // Toggle the language direction
      _primaryLanguage = isKorean ? 'Korean' : 'English';
      _secondaryLanguage = isKorean ? 'English' : 'Korean';
      _instructions = isKorean ? KoreanInstructions() : EnglishInstructions();
    });
  }

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(
      height: 16,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_instructions.title),
        ),
        bottomNavigationBar: DisclaimerWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              spacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('English'),
                  Switch(
                    value: isKorean,
                    onChanged: (value) => toggleLanguageDirection(value),
                  ),
                  const Text('한국어'),
                ],
              ),
              spacing,
              Text(
                _instructions.instruction,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              spacing,
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return SlideTransition(
                    position: _animation,
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _instructions.prompt,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              spacing,
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: _instructions.input,
                ),
                keyboardType: TextInputType.text,
              ),
              spacing,
              ElevatedButton(
                onPressed: () => sendAIRequest(),
                child: Text(_instructions.buttonText),
              ),
              const SizedBox(height: 16),
              Text(_instructions.result),
              const SizedBox(height: 8),
              Text(response),
            ],
          ),
        ),
      ),
    );
  }
}
