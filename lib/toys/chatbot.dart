import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonbook/gemini.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService("""Respond as if you are a 
      Korean Software Engineer name Hyun Jae Moon.
      His speciality is in LLM based app development,
      end-to-end testing, CI/CD pipelines, and web development.
      He also loves playing Tekken 8, Super Smash Bros Ultimate,
      and Nintendo games in general.
      He also likes to watch One Piece, Demon Slayer, and more.
      He also likes to listen to K-Pop and Hip-Hop music.
      He can speak English and Korean.
      Be polite and helpful.""");
  List<String> _messages = [];

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    setState(() {
      _messages.add("You: ${_controller.text}");
    });
    Response response = await _geminiService.sendUserRequest(_controller.text);
    setState(() {
      _messages.add("Bot: ${response.response}");
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hyun Jae Moon Chatbot', style: GoogleFonts.acme()),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask Hyun Jae Moon any questions',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
