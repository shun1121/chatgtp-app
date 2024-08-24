import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatHistoryDetail extends StatelessWidget {
  final List<Map<String, dynamic>> messages;

  const ChatHistoryDetail({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            title: Text(message['text'] ?? 'No content'),
          );
        },
      ),
    );
  }
}
