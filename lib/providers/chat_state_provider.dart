import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../chat_message.dart';

class ChatStateProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;
  List<List<Map<String, dynamic>>> allTexts = [];
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void removeLoadingMessage() {
    _messages.removeWhere((msg) => msg.isLoading);
    notifyListeners();
  }

  Future<void> endChat() async {
    List<Map<String, dynamic>> messagesData = _messages.map((message) => { 'text': message.text }).toList();

    if (_messages.length != 0) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('messages')
          .add({
        'messages': messagesData,
        'chatEndedAt': Timestamp.now(),
      });
    }

    _messages.clear();
    notifyListeners();
  }

  Future<void> loadMessageHistory() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('messages')
        .orderBy('chatEndedAt', descending: true)
        .get();

    var historyArr = [];
    for (var doc in snapshot.docs) {
      historyArr.add(doc.data());
    }

    List<List<Map<String, dynamic>>> loadedMessages = [];
    for (var obj in historyArr) {
      if (obj['messages'] != null) {
        var messages = obj['messages'] as List<dynamic>;
        loadedMessages.add(messages.cast<Map<String, dynamic>>());
      }
    }

    // チャットごとのメッセージ配列がある。
    allTexts = loadedMessages;
    notifyListeners();
  }
}
