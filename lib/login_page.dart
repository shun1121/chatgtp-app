import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future _register() async {
    try {
      final credential =
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      print("User registered: ${credential.user}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ChatScreen(title: 'ChatGPT Chat')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future _login() async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("User logged in: ${credential.user}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ChatScreen(title: 'ChatGPT Chat')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
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
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'メールアドレス'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: 'パスワード'),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _login, child: const Text('ログイン')),
          TextButton(onPressed: _register, child: const Text('会員登録')),
        ],
      ),
    );
  }
}
