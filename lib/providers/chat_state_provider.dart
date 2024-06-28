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
}

// 例

// class BannerStateProvider extends ChangeNotifier {
//   int _currentIndex = 0;
// 
//   int get currentIndex => _currentIndex;
// 
//   void setIndex(int index) {
//     _currentIndex = index;
//     notifyListeners();
//   }
// }