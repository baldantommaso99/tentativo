import 'package:flutter/material.dart';

class DeleteAccountPage extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  DeleteAccountPage({required this.onDelete, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delete Account')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Do you want to delete this account?'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: onDelete,
                  child: Text('Yes'),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.grey,
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: onCancel,
                  child: Text('No'),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
