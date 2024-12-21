import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService {
  static String apiKey = kDebugMode
      ? dotenv.get('GEMINI_API_KEY')
      : const String.fromEnvironment("GEMINI_API_KEY", defaultValue: '');
}
