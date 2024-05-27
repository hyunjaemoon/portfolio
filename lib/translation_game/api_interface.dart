import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:moonbook/env.dart';

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
  final String envKey = 'GEMINI_API_KEY';
  late GenerativeModel model;
  String apiKey = '';
  String errorMessage = '';

  ApiService() {
    // Obtain the apiKey from env.dart
    model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: EnvService.apiKey,
        tools: [
          Tool(functionDeclarations: [translationEvaluationTool])
        ]);
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
a single sentence. The question is "$prompt" and the User input is
"$userInput". Also, please provide a score from 1 to 100. Be very strict with your 
scoring. Return the score and description (strictly in $primaryLanguage) of the translation 
evaluation.
''');

    var response = await chat.sendMessage(content);

    final functionCalls = response.functionCalls.toList();
    if (functionCalls.isNotEmpty) {
      final functionCall = functionCalls.first;
      if (functionCall.name == 'findTranslationEvaluation') {
        final result = await findTranslationEvaluation(functionCall.args);
        String description = result['description'].toString();
        int score = int.parse(result['score'].toString());
        return GameResponse(response: description, score: score);
      } else {
        return ErrorResponse("Invalid function call: ${functionCall.name}");
      }
    } else {
      return ErrorResponse("No function calls found");
    }
  }
}
