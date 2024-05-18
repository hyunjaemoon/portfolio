import 'dart:convert';
import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class AIRequestWidget extends StatefulWidget {
  const AIRequestWidget({Key? key}) : super(key: key);

  @override
  _AIRequestWidgetState createState() => _AIRequestWidgetState();
}

class _AIRequestWidgetState extends State<AIRequestWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final DotEnv dotenv = DotEnv();

  late AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  String response = '';
  bool isKoreanToEnglish = true; // Track the current language direction

  @override
  void initState() {
    super.initState();
    dotenv.load(fileName: '.env');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> sendAIRequest(
      {String primaryLanguage = 'Korean',
      String secondaryLanguage = 'English'}) async {
    final String? apiKey = dotenv.env['GEMINI_API_KEY'];
    final String url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';
    final String inputTxt = '''
Consider yourself as a translation video game where you score how well the user 
translated the given $secondaryLanguage Sentence into $primaryLanguage sentence. 
Give me a proper game-like response. The game-like response should be concise in 
a single Korean sentence. The question is "How is 
everyone doing? I hope you are all doing well." and the User input is
"${_textController.text}". Please have your response in $primaryLanguage and
provide a score from 1 to 100. Be very strict with your scoring.''';

    final Map<String, dynamic> requestBody = {
      'contents': [
        {
          'parts': [
            {'text': inputTxt},
          ],
        },
      ],
    };
    final String requestBodyJson = jsonEncode(requestBody);

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: requestBodyJson,
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final candidates = responseBody['candidates'];
      final content = candidates[0]['content'];
      final parts = content['parts'];
      final text = parts[0]['text'];

      setState(() {
        this.response = text;
      });
    } else {
      throw Exception('Failed to send AI request');
    }
  }

  void toggleLanguageDirection() {
    setState(() {
      isKoreanToEnglish = !isKoreanToEnglish; // Toggle the language direction
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryLanguage = isKoreanToEnglish ? 'Korean' : 'English';
    final secondaryLanguage = isKoreanToEnglish ? 'English' : 'Korean';

    const spacing = SizedBox(
      height: 16,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Translation Game powered by Gemini AI Demo'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              spacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('English'),
                  Switch(
                    value: isKoreanToEnglish,
                    onChanged: (value) => toggleLanguageDirection(),
                  ),
                  const Text('한국어'),
                ],
              ),
              spacing,
              Container(
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
                child: const Text(
                  '다음 문장을 한국어로 번역하시오:\n'
                  '"How is everyone doing? I hope you are all doing well."',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              spacing,
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: '여기 입력하시오:',
                ),
                keyboardType: TextInputType.text,
              ),
              spacing,
              ElevatedButton(
                onPressed: () => sendAIRequest(
                  primaryLanguage: primaryLanguage,
                  secondaryLanguage: secondaryLanguage,
                ),
                child: const Text('번역'),
              ),
              const SizedBox(height: 16),
              const Text('결과:'),
              const SizedBox(height: 8),
              Text(response),
            ],
          ),
        ),
      ),
    );
  }
}
