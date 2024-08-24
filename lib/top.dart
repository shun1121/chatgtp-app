import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mixi_training/providers/chat_state_provider.dart';
import 'package:provider/provider.dart';
import 'chat_history_detail.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});
  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  void handleLoadHistory() {
    Provider.of<ChatStateProvider>(context, listen: false).loadMessageHistory();
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
        centerTitle: true,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  const Text('Load Messages'),
                  IconButton(
                    onPressed: () => handleLoadHistory(),
                    icon: const Icon(Icons.get_app),
                  ),
                ],
              ),
            ),
            Consumer<ChatStateProvider>(
              builder: (context, chatState, child) {
                return Flexible(
                  child: ListView.builder(
                    itemCount: chatState.allTexts.length,
                    itemBuilder: (context, index) {
                      final historyMessages = chatState.allTexts[index];
                      var descIndex = chatState.allTexts.length - index;
                      return ListTile(
                        textColor: Colors.black,
                        title: Text('Message #$descIndex'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatHistoryDetail(messages: historyMessages),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const ChatScreen(title: 'ChatGPT Chat');
              },
            ),
          );
        },
        child: const Icon(Icons.draw),
      ),
    );
  }
}
