import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../chat_message.dart';

class ChatStateProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void removeLoadingMessage() {
    _messages.removeWhere((msg) => msg.isLoading);
    notifyListeners();
  }

  Future<void> endChat() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    List<Map<String, dynamic>> messagesData = _messages
        .map((message) => {
              'text': message.text,
            })
        .toList();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('messages')
        .add({
      'messages': messagesData,
      'chatEndedAt': Timestamp.now(),
    });

    _messages.clear();
    notifyListeners();

  }
}
