import 'package:flutter/material.dart';
import 'container.dart';

class Settings extends StatelessWidget {

  Settings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: [
      //     Div(Colors.red),
      //     Div(Colors.green),
      //     Div(Colors.blue),
      //     Div(Colors.red)
      //   ]
      // )
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text('TestName'),
                leading: CircleAvatar(backgroundColor: Colors.green),
                trailing: Icon(Icons.edit),
              ),
            )
          ],
        )
      ),
    );
  }
}