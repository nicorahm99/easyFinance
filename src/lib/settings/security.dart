import 'package:flutter/material.dart';

class Security extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Security"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
              Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}