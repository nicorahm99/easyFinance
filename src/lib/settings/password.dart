import 'package:flutter/material.dart';

class Password extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Password"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
              Navigator.pop(context);
          },
          child: Text('Save'),
        ),
        // TextField(
        //   decoration: InputDecoration(
        //     border: InputBorder.none,
        //     hintText: 'Enter a search term'
        //   ),
        // ),
      ),
    );
  }
}