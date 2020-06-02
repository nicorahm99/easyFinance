import 'package:charts_flutter/flutter.dart' as prefix0;
import 'package:flutter/material.dart';
import 'container.dart';

class Settings extends StatelessWidget {

  Settings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Settings title
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 4.0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.lightGreen[200],
        title: Text('Settings', style: TextStyle(
          color: Colors.green,
          fontSize: 20,
          fontWeight: FontWeight.bold, 
        ),),
      ),
      // body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            Card(// account view
              elevation: 4.0, // shadow
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
            Card(// page opening settings
              elevation: 4.0, // shadow
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.attach_money, color: Colors.green,),
                    title: Text('Set Initial Bank-Balance'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      //open set bank balance
                    },
                  ),
                  buildDevider(),
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
                  buildDevider(),
                  ListTile(
                    leading: Icon(Icons.security, color: Colors.green,),
                    title: Text('Security'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      //open change security settings
                    },
                  ),
                ],
              ),
            ),
            //notification settings
            const SizedBox(height: 10.0,),
            Text("Notification Settings", style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              ),
            ),
            SwitchListTile(
              //dense: true,
              activeColor: Colors.green,
              //contentPadding: const EdgeInsets.all(0),
              value: true,
              title: Text("Received notification"),
              onChanged: (val){},
            ),
            SwitchListTile(
              activeColor: Colors.green,
              //contentPadding: const EdgeInsets.all(0),
              value: false,
              title: Text("Bank Balance Warnings"),
              onChanged: (val){},
            ),
            SwitchListTile(
              activeColor: Colors.green,
              //contentPadding: const EdgeInsets.all(0),
              value: false,
              title: Text("Received Transaction"),
              onChanged: (val){},
            ),
            SwitchListTile(
              activeColor: Colors.green,
              //contentPadding: const EdgeInsets.all(0),
              value: false,
              title: Text("Received App Updates"),
              onChanged: null,
            ),
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