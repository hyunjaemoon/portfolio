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
  late GenerativeModel model;
  late ChatSession chatSession;
  late List<MapEntry<String, String>> chatHistory;
  String errorMessage = '';

  GeminiService(String systemInstruction,
      {String modelType = 'gemini-1.5-flash', List<Tool> tools = const []}) {
    // Obtain the apiKey from env.dart
    model = GenerativeModel(
        model: modelType,
        apiKey: EnvService.apiKey,
        systemInstruction: Content.text(systemInstruction),
        tools: tools);
    chatHistory = [];
    chatSession = model.startChat();
  }

  Future<Response> sendUserRequest(String userInput) async {
    if (errorMessage.isNotEmpty) {
      return ErrorResponse(errorMessage);
    }
    chatHistory.add(MapEntry('user', userInput));

    final content = Content.text(userInput);

    final response = await chatSession.sendMessage(content);

    chatHistory.add(MapEntry('bot', response.text.toString()));

    return GeneralResponse(response.text.toString());
  }
}
