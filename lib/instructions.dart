abstract class Instructions {
  String get title;
  String get instruction;
  String get prompt;
  String get input;
  String get buttonText;
  String get result;
}

class KoreanInstructions implements Instructions {
  @override
  String title = "번역 게임 데모 powered by Gemini AI";
  @override
  String instruction = "다음 문장을 한국어로 번역하시오.";
  @override
  String prompt = "How is everyone doing? I hope you are all doing well.";
  @override
  String input = "여기 입력하시오:";
  @override
  String buttonText = "제출";
  @override
  String result = "결과:";
}

class EnglishInstructions implements Instructions {
  @override
  String title = "Translation Game powered by Gemini AI Demo";
  @override
  String instruction = "Translate the following sentence into Korean.";
  @override
  String prompt = "다들 어떻게 지내? 너희들이 다 잘 지내고 있길 바랄게.";
  @override
  String input = "Enter your translation here:";
  @override
  String buttonText = "Submit";
  @override
  String result = "Result:";
}
