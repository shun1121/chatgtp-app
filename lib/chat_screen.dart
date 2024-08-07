import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mixi_training/providers/chat_state_provider.dart';
import 'package:provider/provider.dart';
import 'answer.dart';
import 'chat_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});
  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String apiKey = dotenv.env['API_KEY'] ?? 'APIキーが見つかりません';

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
        Map<String, dynamic> body =
            json.decode(utf8.decode(response.bodyBytes));
        // jsonをAnswerモデルの型に変換する
        final answer = Answer.fromJson(body);
        return answer.choices.first.message.content;
      } else {
        print('Error status code: ${response.statusCode}');
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to get response: $e');
    }
  }

  void handleSubmit() async {
    if (_controller.text.isEmpty) return;

    String userMessage = _controller.text;
    ChatMessage message = ChatMessage(text: userMessage, isUser: true);

    Provider.of<ChatStateProvider>(context, listen: false).addMessage(message);
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('messages')
        .add({
      'message': message.text, // messageのtextフィールドを使用
      'isUser': message.isUser, // 必要に応じて他のフィールドも追加
      'timestamp': FieldValue.serverTimestamp()
    });
    _controller.clear();

    // ローディングメッセージを追加
    Provider.of<ChatStateProvider>(context, listen: false).addMessage(
        const ChatMessage(text: "", isUser: false, isLoading: true));

    String response = await getChatGPTResponse(userMessage);
    ChatMessage responseMessage = ChatMessage(text: response, isUser: false);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('messages')
        .add({
      'message': responseMessage.text, // responseMessageのtextフィールドを使用
      'isUser': responseMessage.isUser, // 必要に応じて他のフィールドも追加
      'timestamp': FieldValue.serverTimestamp()
    });

    Provider.of<ChatStateProvider>(context, listen: false)
        .removeLoadingMessage();
    Provider.of<ChatStateProvider>(context, listen: false)
        .addMessage(responseMessage);
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage(title: 'ログイン')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Consumer<ChatStateProvider>(
              builder: (context, chatStateProvider, child) {
                return ListView.builder(
                  itemCount: chatStateProvider.messages.length,
                  itemBuilder: (context, index) {
                    if (chatStateProvider.messages[index].isLoading) {
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      );
                    }
                    return chatStateProvider.messages[index];
                  },
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
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
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
}
