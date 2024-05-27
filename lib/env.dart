class EnvService {
  static const String apiKey =
      String.fromEnvironment("GEMINI_API_KEY", defaultValue: '');
}
