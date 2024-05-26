import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

abstract class Response {
  late final String response;
}

class GameResponse implements Response {
  @override
  late final String response;
  late final int score;

  GameResponse({required this.response, required this.score});
}

class ErrorResponse implements Response {
  @override
  late final String response;

  ErrorResponse(this.response);
}

class ApiService {
  final DotEnv dotenv = DotEnv();
  final String envKey = 'GEMINI_API_KEY';
  String apiKey = '';
  String errorMessage = '';

  ApiService() {
    // Obtain the Gemini API key from the .env file
    dotenv.load(fileName: '.env').then((_) {
      if (dotenv.env.containsKey(envKey)) {
        apiKey = dotenv.env[envKey]!;
      } else {
        errorMessage = 'API key not found';
      }
    }).catchError((error) {
      errorMessage = error;
    });
  }

  Future<Response> sendAIRequest({
    required String primaryLanguage,
    required String secondaryLanguage,
    required String prompt,
    required String userInput,
  }) async {
    if (errorMessage.isNotEmpty) {
      return ErrorResponse(errorMessage);
    }

    final String url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

    final String inputTxt = '''
Consider yourself as a translation video game where you score how well the user 
translated the given $secondaryLanguage Sentence into $primaryLanguage sentence. 
Give me a proper game-like response. The game-like response should be concise in 
a single $primaryLanguage  sentence. The question is "$prompt" and the User input is
"$userInput". Also, please provide a score from 1 to 100. 
Be very strict with your scoring.

Return a JSON object with the following format:
{"translation_score": integer, "game_response": "string"}
''';

    // TODO: Extract part of the inputTxt into tools.functionDeclarations
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

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final candidates = responseBody['candidates'];
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        if (content != null) {
          final parts = content['parts'];
          if (parts != null && parts.isNotEmpty) {
            final text = parts[0]['text'];
            if (text != null) {
              final gameResponseBody = jsonDecode(text);
              final gameResponse = gameResponseBody['game_response'];
              final translationScore = gameResponseBody['translation_score'];
              if (gameResponse != null && translationScore != null) {
                return GameResponse(
                    response: gameResponse, score: translationScore);
              }
            }
          }
        }
      }
      return ErrorResponse(
          "Invalid response format: ${responseBody.toString()}");
    } else {
      return ErrorResponse("Response Error: ${responseBody.toString()}");
    }
  }
}
