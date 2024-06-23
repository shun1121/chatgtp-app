import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mixi_training/textfield_page.dart';

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
            'Authorization':
                'Bearer $apiKey'
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
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: messages.length,
          //     itemBuilder: (context, index) {
          //       print('ddddddddddd');
          //       print(messages[index]);
          //       return messages[index];
          //     },
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // final message = messages[index];
                final message = messages[index];
                print("Message at index $index: ${message.text}");
                return ChatMessage(text: message.text, isUser: message.isUser);
                // return ListTile(
                //   title: Text(
                //     message.text,
                //     style: TextStyle(
                //       color: message.isUser ? Colors.blue : Colors.green,
                //     ),
                //   ),
                // );
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
    try {
      String response = await getChatGPTResponse(_controller.text);
      ChatMessage userMessage =
          ChatMessage(text: _controller.text, isUser: true);
      ChatMessage botMessage = ChatMessage(text: response, isUser: false);

      print("User message: ${userMessage.text}");
      print("Bot response: ${botMessage.text}");

      setState(() {
        messages.insert(0, botMessage);
        messages.insert(0, userMessage);
      });
      _controller.clear();
    } catch (e) {
      print('Error in handleSubmit: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }

  // void handleSubmit() async {
  //   if (_controller.text.isEmpty) return;

  //   ChatMessage message = ChatMessage(text: _controller.text, isUser: true);

  //   setState(() {
  //     messages.insert(0, message);
  //   });

  //   String response = await getChatGPTResponse(_controller.text);

  //   ChatMessage responseMessage = ChatMessage(text: response, isUser: false);

  //   setState(() {
  //     messages.insert(0, responseMessage);
  //   });

  //   _controller.clear();
  // }
}
