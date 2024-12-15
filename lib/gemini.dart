import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:moonbook/env.dart';

abstract class Response {
  late final String response;
}

class GeneralResponse implements Response {
  @override
  late final String response;

  GeneralResponse(this.response);
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

class GeminiService {
  final String envKey = 'GEMINI_API_KEY';
  late GenerativeModel model;
  String apiKey = '';
  String errorMessage = '';

  GeminiService(String systemInstruction,
      {String model = 'gemini-1.5-flash', List<Tool> tools = const []}) {
    // Obtain the apiKey from env.dart
    this.model = GenerativeModel(
        model: model,
        apiKey: EnvService.apiKey,
        systemInstruction: Content.text(systemInstruction),
        tools: tools);
  }

  Future<Response> sendUserRequest(String userInput) async {
    if (errorMessage.isNotEmpty) {
      return ErrorResponse(errorMessage);
    }

    final chat = model.startChat();
    print(chat);

    final content = Content.text(
      userInput,
    );

    var response = await chat.sendMessage(content);

    return GeneralResponse(response.text.toString());
  }
}
