import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moonbook/translation_game/api_interface.dart';
import 'package:moonbook/translation_game/instructions.dart';
import 'package:moonbook/translation_game/prompt.dart';
import 'package:moonbook/translation_game/prompt_widget.dart';
import 'package:moonbook/translation_game/report_issue_widget.dart';
import 'package:moonbook/translation_game/result_widget.dart';
import 'package:moonbook/translation_game/submit_button_widget.dart';
import 'package:moonbook/translation_game/user_input_widget.dart';
import 'package:moonbook/utils.dart';

class TranslationGameDemoWidget extends StatefulWidget {
  const TranslationGameDemoWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TranslationGameDemoWidgetState createState() =>
      _TranslationGameDemoWidgetState();
}

class _TranslationGameDemoWidgetState extends State<TranslationGameDemoWidget>
    with SingleTickerProviderStateMixin {
  late Instructions _instructions;
  late Prompts _prompts;
  late TextEditingController _textController;
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late ApiService _apiService;

  late String _primaryLanguage;
  late String _secondaryLanguage;

  String response = '';
  int score = 0;
  bool isKorean = false; // Track the current language direction
  bool isLoading = false; // Track if Gemini API Request is loading.
  Random random = Random();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, -0.05),
      end: const Offset(0, 0.05),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _apiService = ApiService();

    _instructions = isKorean ? KoreanInstructions() : EnglishInstructions();
    _prompts = isKorean ? EnglishPrompts() : KoreanPrompts();

    _primaryLanguage = isKorean ? 'Korean' : 'English';
    _secondaryLanguage = isKorean ? 'English' : 'Korean';
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<Response> sendAIRequest() async {
    try {
      return await _apiService.sendAIRequest(
        primaryLanguage: _primaryLanguage,
        secondaryLanguage: _secondaryLanguage,
        prompt: _instructions.prompt,
        userInput: _textController.text,
      );
    } catch (e) {
      return ErrorResponse(e.toString());
    }
  }

  Future<void> processRequest() async {
    setState(() {
      isLoading = true;
    });
    Response aiResponse = ErrorResponse('Critical Error: No response');
    // Attempt sending AIRequest 5 times before giving up
    for (int i = 0; i < 5; i++) {
      aiResponse = await sendAIRequest();
      if (aiResponse is GameResponse) {
        break;
      }
    }
    setState(() {
      isLoading = false;
      response = aiResponse.response;
      score = aiResponse.score;
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
      _prompts = isKorean ? EnglishPrompts() : KoreanPrompts();
      response = ''; // Clear the response when the language direction changes
      score = 0; // Reset the score when the language direction changes
    });
  }

  void provideRandomSamplePrompt() {
    setState(() {
      _instructions.prompt = _prompts.promptMap[random.nextInt(100)]!;
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
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xff0e0419),
          title: Text(
            _instructions.title,
            textAlign: TextAlign.center,
            style: fitTextStyle(context).apply(
                color: Colors.purple,
                fontSizeFactor: 0.8,
                shadows: [
                  const Shadow(
                      color: Colors.black, offset: Offset(1, 1), blurRadius: 2)
                ]),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        bottomNavigationBar: ReportIssue(
          buttonText: _instructions.reportIssueText,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              spacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${_instructions.languageToggle}: ',
                      style: const TextStyle(color: Colors.black)),
                  const Text('English', style: TextStyle(color: Colors.black)),
                  spacing,
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
                  spacing,
                  const Text('한국어', style: TextStyle(color: Colors.black)),
                ],
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.purple,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _instructions.instruction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              spacing,
              PromptWidget(
                initialPrompt: _instructions.prompt,
                onPromptChanged: (String newPrompt) {
                  setState(() {
                    _instructions.prompt = newPrompt;
                  });
                },
                promptEditorTitle: _instructions.promptEditorText,
                saveText: _instructions.save,
                cancelText: _instructions.cancel,
              ),
              IconButton(
                onPressed: provideRandomSamplePrompt,
                icon: const Icon(Icons.shuffle),
                color: Colors.purple,
              ),
              spacing,
              UserInput(
                controller: _textController,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.black),
                  labelText: _instructions.input,
                ),
              ),
              spacing,
              SubmitButton(
                isLoading: isLoading,
                onPressed: () async {
                  if (!isLoading) {
                    await processRequest();
                  }
                },
                buttonText: _instructions.buttonText,
              ),
              const SizedBox(height: 16),
              ResultWidget(
                  score: score,
                  instructionResult: _instructions.result,
                  result: response,
                  instructionScore: _instructions.score)
            ],
          ),
        ),
      ),
    );
  }
}
