import 'package:flutter/material.dart';

class AddCigarettePage extends StatelessWidget {
  final String accountName;

  AddCigarettePage({required this.accountName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Cigarette'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Cigarette smoked today...',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            // Altri widget per l'aggiunta della sigaretta
          ],
        ),
      ),
    );
  }
}
