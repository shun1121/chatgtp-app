import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mixi_training/chat_screen.dart';
import 'package:mixi_training/providers/chat_state_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

void main() async {
  await dotenv.load(fileName: '.env');
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatStateProvider(),
      child: const MyApp(),
    ),
    // MultiProvider(
    //   providers: [],
    //   child: const MyApp(),
    // ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
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

