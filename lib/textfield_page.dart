import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldPage extends StatefulWidget {
  const TextFieldPage({super.key, required this.text});
  final String text;

  @override
  State<TextFieldPage> createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.text),
            TextField(
              onChanged: (value) => {
                // setState(() {
                  _message = value
                // })
              },
            ),
            Text(_message),
            IconButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  _message
                );
              },
              icon: const Icon(Icons.arrow_back),
            )
          ],
        ),
      ),
    );
  }
}
