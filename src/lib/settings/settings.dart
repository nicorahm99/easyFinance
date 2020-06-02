import 'package:charts_flutter/flutter.dart' as prefix0;
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey.shade200,
        title: Text('Settings', style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            Card(
              elevation: 4.0, // shadow
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.all(8.0),
              color: Colors.green,
              child: ListTile(
                onTap: (){
                  //open edit profile
                },
                title: Text('TestName', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                leading: CircleAvatar(backgroundColor: Colors.lightGreen[200]),
                trailing: Icon(Icons.edit, color: Colors.white,),
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 4.0, // shadow
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.lock_outline, color: Colors.green,),
                    title: Text('Change Password'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      //open change Password
                    },
                  ),
                  buildDevider(),
                  ListTile(
                    leading: Icon(Icons.language, color: Colors.green,),
                    title: Text('Change Language'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      //open change language
                    },
                  ),
                  buildDevider(),
                  ListTile(
                    leading: Icon(Icons.location_on, color: Colors.green,),
                    title: Text('Change Location'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      //open change location
                    },
                  ),
                ],
              ),
            )

          ],
        )
      ),
    );
  }

  Container buildDevider() {
    return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0,),
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey.shade400,
                );
  }
}