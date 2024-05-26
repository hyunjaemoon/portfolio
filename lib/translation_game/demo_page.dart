// ignore: unused_import
import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:moonbook/translation_game/api_interface.dart';
import 'package:moonbook/translation_game/disclaimer.dart';
import 'package:moonbook/translation_game/instructions.dart';

class TranslationGameDemoWidget extends StatefulWidget {
  const TranslationGameDemoWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TranslationGameDemoWidgetState createState() =>
      _TranslationGameDemoWidgetState();
}

class _TranslationGameDemoWidgetState extends State<TranslationGameDemoWidget>
    with SingleTickerProviderStateMixin {
  late Instructions _instructions;
  late TextEditingController _textController;
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  final ApiService _apiService = ApiService();

  late String _primaryLanguage;
  late String _secondaryLanguage;

  String response = '';
  int score = 0;
  bool isKorean = false; // Track the current language direction
  bool isLoading = false; // Track if Gemini API Request is loading.

  @override
  void initState() {
    super.initState();
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
    setState(() {
      isLoading = true;
    });
    try {
      final apiResponse = await _apiService.sendAIRequest(
        primaryLanguage: _primaryLanguage,
        secondaryLanguage: _secondaryLanguage,
        prompt: _instructions.prompt,
        userInput: _textController.text,
      );

      setState(() {
        response = apiResponse.response;
        if (apiResponse is GameResponse) {
          score = apiResponse.score;
        } else {
          score = 0;
        }
      });
    } catch (e) {
      setState(() {
        response = 'Error: ${e.toString()}';
        score = 0;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void toggleLanguageDirection(value) {
    setState(() {
      isKorean = value; // Toggle the language direction
      _textController
          .clear(); // Clear the text field when the language direction changes
      _primaryLanguage = isKorean ? 'Korean' : 'English';
      _secondaryLanguage = isKorean ? 'English' : 'Korean';
      _instructions = isKorean ? KoreanInstructions() : EnglishInstructions();
      response = ''; // Clear the response when the language direction changes
      score = 0; // Reset the score when the language direction changes
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
        backgroundColor: const Color(0xff0e0419),
        bottomNavigationBar: DisclaimerWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              spacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${_instructions.languageToggle}: ',
                      style: TextStyle(color: Colors.white)),
                  const Text('English', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 8),
                  Transform.scale(
                    scale: 1.0,
                    child: Switch(
                      value: isKorean,
                      onChanged: (value) => toggleLanguageDirection(value),
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                  ),
                  SizedBox(width: 8),
                  const Text('한국어', style: TextStyle(color: Colors.white)),
                ],
              ),
              spacing,
              Text(
                _instructions.instruction,
                style: const TextStyle(
                  color: Colors.white,
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
                style: const TextStyle(color: Colors.white),
                controller: _textController,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.white),
                  labelText: _instructions.input,
                ),
                keyboardType: TextInputType.text,
                cursorColor: Colors.white,
              ),
              spacing,
              ElevatedButton(
                onPressed: () => {
                  if (!isLoading) {sendAIRequest()}
                },
                child: Text(_instructions.buttonText),
              ),
              const SizedBox(height: 16),
              Text(
                _instructions.result,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                response,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                _instructions.score,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                score.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
