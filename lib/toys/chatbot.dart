import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonbook/gemini.dart';
import 'package:moonbook/typing_indicator.dart';
import 'package:moonbook/utils.dart';
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

      He has worked at Google as a Senior Software Engineer on Network Simulation Software Tool for Android.

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

  Future<void> _scrollToBottom() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
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
      _messages.add(("Hyun Jae Moon", "typing_indicator"));
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
            textScaler: const TextScaler.linear(0.75),
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFE0F7FA),
      ),
      bottomNavigationBar: copyrightBottomAppBar(context),
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
                    subtitle: message == "typing_indicator"
                        ? SizedBox(
                            height: 60,
                            child: TypingIndicator(
                              showIndicator: true,
                            ),
                          )
                        : MarkdownBody(
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
                      hintText: 'Enter your message...',
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
                IconButton(
                    onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Send Email'),
                                content: const Text(
                                    '''Do you want to send the conversation via email to the real Hyun Jae Moon?
                                    \n진짜 문현재에게 이메일로 대화 내용을 보내시겠습니까?
                                    \ncalhyunjaemoon@gmail.com'''),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _sendEmail();
                                    },
                                    child: const Text('Send'),
                                  ),
                                ],
                              );
                            },
                          )
                        },
                    icon: const Icon(Icons.email))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
