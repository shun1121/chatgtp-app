import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});
  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String apiKey = dotenv.env['API_KEY'] ?? 'APIキーが見つかりません';
  List<ChatMessage> messages = [];

  Future<String> getChatGPTResponse(String prompt) async {
    try {
      final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey'
          },
          body: jsonEncode({
            'model': 'gpt-3.5-turbo',
            'messages': [
              {'role': 'user', 'content': prompt}
            ]
          }),
          encoding: Encoding.getByName('utf-8'));
      if (response.statusCode == 200) {
        var decodedResponse = utf8.decode(response.bodyBytes);
        var data = jsonDecode(decodedResponse);
        return data['choices'][0]['message']['content'];
      } else {
        print('Error status code: ${response.statusCode}');
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to get response: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
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
                    decoration: const InputDecoration(hintText: 'テキスト入力'),
                  ),
                ),
                IconButton(
                    onPressed: handleSubmit, icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }

  void handleSubmit() async {
    if (_controller.text.isEmpty) return;

    String userMessage = _controller.text;
    ChatMessage message = ChatMessage(text: userMessage, isUser: true);
    setState(() {
      messages.add(message);
    });
    
    _controller.clear();
    String response = await getChatGPTResponse(userMessage);
    ChatMessage responseMessage = ChatMessage(text: response, isUser: false);
    setState(() {
      messages.add(responseMessage);
    });
  }

}
