import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mixi_training/chat_screen.dart';
import 'package:mixi_training/first_page.dart';

import 'my_home_page.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: 
      const ChatScreen(title: 'Chat Screen')
      // const FirstPage(),
      // const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

