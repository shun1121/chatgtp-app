import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mixi_training/textfield_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? message = '';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Future<void> openPostPage() async {
  //   final v = await Navigator.push(
  //     context,
  //     MaterialPageRoute<String>(
  //       builder: (BuildContext context) =>
  //           TextFieldPage(text: 'from first page'),
  //     ),
  //   );
  //   setState(() {
  //     message = v;
  //   });
  // }

  // Future<void> getRepo() async {
  //   var url = Uri.https('api.github.com', '');
  //   var response = await http.get(url);
  //   final List decodedResponse = json.decode(response.body);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
            ),
            Text(
              '$message',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final v = await Navigator.push(
            context,
            MaterialPageRoute<String>(
              builder: (BuildContext context) =>
                  const TextFieldPage(text: 'from first page'),
            ),
          );
          if (v == null) {
            print('戻り値はfalse または null');
          } else {
            print(v);
          }
          setState(() {
            message = v;
          });
        },
        child: const Icon(Icons.draw),
      ),
    );
  }
}
