import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonbook/gemini.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final GeminiService _geminiService = GeminiService("""
      Respond as if you are a Korean Software Engineer named Hyun Jae Moon.

      His specialties include LLM-based app development, end-to-end testing, CI/CD pipelines, and web development. 
      He has experience working with Rust, Python, React, Flutter, and more.

      He has worked at Google as a Senior Software Engineer on Network Simulation Software Tool for Android, 
      and implemented an LLM-powered Network Analysis Bot.

      You can find his work in Android Open Source Project as hyunjaemoon@google.com.

      He has worked at Samsung and Naver as Software Engineer Intern for developing error detection models and researching various ML models.

      He holds a degree in Electrical Engineering & Computer Science from UC Berkeley, where he also served as an undergraduate student instructor for CS61A.

      You can also find his work on his GitHub and LinkedIn profiles.

      He is also into language learning and has developed a translation game called LinguaGhost.

      Github: https://github.com/hyunjaemoon
      LinkedIn: https://www.linkedin.com/in/hyunjaemoon/

      He also enjoys playing video games such as Tekken, Super Smash Bros, and mostly Nintendo Games.

      He is proficient in both English and Korean. 
      Be polite and helpful.

      Do NOT make up information.

      Note that your first message is already sent to the user as: 
      "Ask me anything! 한국말도 가능합니다!".
      """);
  final _messages = [("Hyun Jae Moon", "Ask me anything! 한국말도 가능합니다!")];
  bool _chatEnabled = true;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  void _sendMessage() async {
    _chatEnabled = false;
    var userInput = _controller.text;

    if (userInput.isEmpty) return;
    _controller.clear();
    setState(() {
      _messages.add(("You", userInput));
      _scrollToBottom();
    });
    setState(() {
      _messages.add(("Hyun Jae Moon", "Thinking..."));
      _scrollToBottom();
    });
    Response response = await _geminiService.sendUserRequest(userInput);
    setState(() {
      _messages.removeLast();
    });
    setState(() {
      _messages.add(("Hyun Jae Moon", response.response));
      _scrollToBottom();
    });
    _chatEnabled = true;
  }

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'calhyunjaemoon@gmail.com',
      query:
          'subject=Chatbot Conversation&body=${_messages.map((msg) => '${msg.$1}: ${msg.$2}').join('\n\n')}',
    );
    if (await launchUrl(emailUri)) {
      return;
    } else {
      throw 'Could not launch email client';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Software Consulting Chatbot',
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFE0F7FA),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '© Hyun Jae Moon ${DateTime.now().year}',
            style: GoogleFonts.openSans(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE0F7FA),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var (entity, message) = _messages[index];
                var boxDecoration = entity == "Hyun Jae Moon"
                    ? BoxDecoration(
                        color: Colors.teal.shade100,
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      )
                    : BoxDecoration(
                        color: Colors.teal.shade50,
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      );
                return Container(
                  decoration: boxDecoration,
                  margin: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 10.0),
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    title: Text(entity,
                        style:
                            GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                    subtitle: MarkdownBody(
                      data: message,
                      selectable: true,
                    ),
                  ),
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
                    onSubmitted: (value) =>
                        {if (value.isNotEmpty && _chatEnabled) _sendMessage()},
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => {
                    if (_controller.text.isNotEmpty && _chatEnabled)
                      _sendMessage()
                  },
                ),
                IconButton(onPressed: _sendEmail, icon: const Icon(Icons.email))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
