import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mixi_training/textfield_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('First Page'),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => TextFieldPage(text: 'aaaaaa')
                  )
                );
              },
              icon: const Icon(Icons.arrow_forward),
            )
          ],
        ),
      ),
    );
  }
}
