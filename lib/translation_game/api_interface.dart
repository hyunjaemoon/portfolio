import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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

Future<Map<String, Object?>> findTranslationEvaluation(
  Map<String, Object?> arguments,
) async =>
    {
      'score': arguments['score'],
      'description': arguments['description'],
    };

final translationEvaluationTool = FunctionDeclaration(
    'findTranslationEvaluation',
    'Returns the score and description of the translation',
    Schema(SchemaType.object, properties: {
      'score': Schema(SchemaType.integer,
          description: 'The score of the translation evaluation'),
      'description': Schema(SchemaType.string,
          description: 'The description of the translation evaluation'),
    }, requiredProperties: [
      'score',
      'description'
    ]));

class ApiService {
  final DotEnv dotenv = DotEnv();
  final String envKey = 'GEMINI_API_KEY';
  late GenerativeModel model;
  String apiKey = '';
  String errorMessage = '';

  ApiService() {
    // Obtain the Gemini API key from the .env file
    dotenv.load(fileName: '.env').then((_) {
      if (dotenv.env.containsKey(envKey)) {
        apiKey = dotenv.env[envKey]!;
        model =
            GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey, tools: [
          Tool(functionDeclarations: [translationEvaluationTool])
        ]);
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

    final chat = model.startChat();

    final content = Content.text('''
Consider yourself as a translation video game where you score how well the user 
translated the given $secondaryLanguage Sentence into $primaryLanguage sentence. 
Give me a proper game-like response. The game-like response should be concise in 
a single $primaryLanguage  sentence. The question is "$prompt" and the User input is
"$userInput". Also, please provide a score from 1 to 100. 
Be very strict with your scoring.

Return a JSON object with the following format:
{"score": integer, "description": "string"}
''');

    var response = await chat.sendMessage(content);

    final functionCalls = response.functionCalls.toList();
    if (functionCalls.isNotEmpty) {
      final functionCall = functionCalls.first;
      if (functionCall.name == 'findTranslationEvaluation') {
        final result = await findTranslationEvaluation(functionCall.args);
        response = await chat
            .sendMessage(Content.functionResponse(functionCall.name, result));
      } else {
        return ErrorResponse("Invalid function call: ${functionCall.name}");
      }
    } else {
      return ErrorResponse("No function calls found");
    }

    final gameResponseBody = jsonDecode(response.text!);
    final gameResponse = gameResponseBody['description'];
    final translationScore = gameResponseBody['score'];
    if (gameResponse != null && translationScore != null) {
      return GameResponse(response: gameResponse, score: translationScore);
    } else {
      return ErrorResponse("Invalid response format: ${response.text}");
    }
  }
}
