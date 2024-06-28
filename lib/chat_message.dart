import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isLoading;

  const ChatMessage({super.key, required this.text, required this.isUser, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[100] : Colors.green[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                text,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}