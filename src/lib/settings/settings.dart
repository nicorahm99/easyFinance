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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text('Settings', style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.green,
              child: ListTile(
                title: Text('TestName', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                leading: CircleAvatar(backgroundColor: Colors.lightGreen[200]),
                trailing: Icon(Icons.edit, color: Colors.white,),
              ),
            )
          ],
        )
      ),
    );
  }
}