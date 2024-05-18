import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ApiService {
  final DotEnv dotenv = DotEnv();

  Future<String> sendAIRequest({
    required String primaryLanguage,
    required String secondaryLanguage,
    required String prompt,
    required String userInput,
  }) async {
    await dotenv.load(fileName: '.env');
    final String? apiKey = dotenv.env['GEMINI_API_KEY'];
    final String url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

    final String inputTxt = '''
Consider yourself as a translation video game where you score how well the user 
translated the given $secondaryLanguage Sentence into $primaryLanguage sentence. 
Give me a proper game-like response. The game-like response should be concise in 
a single Korean sentence. The question is "$prompt" and the User input is
"$userInput". Please have your response in $primaryLanguage and
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

      return text;
    } else {
      throw Exception('Failed to send AI request');
    }
  }
}
