import 'package:ef/settings/deleteCategories.dart';

import 'account.dart';
import 'createCategories.dart';
import 'password.dart';
import 'security.dart';
import 'bankbalance.dart';
import 'deleteCategories.dart';
import 'package:flutter/material.dart';
import 'package:ef/persistence.dart';


class Settings extends StatefulWidget {
  _SettingsState createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {
  SettingDTO _currentSetting;
  //Settings();
 @override
  void initState() { //built in function of stateful widget
    super.initState();
    _fetchData(); // fetch function
  }

  Future<void> _fetchData() async { // async but void so theres no need to wait for it
    SettingDTO incomingSetting = await DBController().getSetting(); // get value from database
    setState(() {// set value
      _currentSetting = incomingSetting;
    });
  }// Page can be loaded and if ready, value will be adapted
  

  AppBar _buildAppBar(String _title){
  return AppBar(
        elevation: 4.0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.lightGreen[200],
        title: Text(_title, style: TextStyle(
          color: Colors.green,
          fontSize: 20,
          fontWeight: FontWeight.bold, 
        ),),
      );
  }

  Card _buildProfileCard(BuildContext context){
    return Card(// account view
              elevation: 4.0, // shadow
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              color: Colors.green,
              child: ListTile(
                onTap: (){
                  //open edit profile
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Account(refresh: _fetchData)),
                  );
                },
                title: Text(getAccountName(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                leading: CircleAvatar(backgroundColor: Colors.lightGreen[200]),
                trailing: Icon(Icons.edit, color: Colors.white,),
              ),
            );
  }

  String getAccountName(){
    if (_currentSetting == null){return "";}
    else{return _currentSetting.username;}
  }

  Card _buildMainCard(BuildContext context){
    return Card(// page opening settings
              elevation: 4.0, // shadow
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  listTile(context, 'Set Bank-Balance', Icons.attach_money, true,  BankBalance()),
                  buildDevider(),
                  listTile(context, 'Change Password', Icons.lock_outline, true, Password()),
                  buildDevider(),
                  listTile(context, 'Create Categories', Icons.category, true, Categories()),
                  buildDevider(),
                  listTile(context, 'Delete Categories', Icons.category, true, DeleteCategories()),
                  buildDevider(),
                  listTile(context, 'Change Language', Icons.language, false, Security()),
                  buildDevider(),
                  listTile(context, 'Change Location', Icons.location_on, false, Security()),
                  buildDevider(),
                  listTile(context, 'Security', Icons.security, false, Security()),
                  buildDevider(),
                  listTile(context, 'Reset', Icons.delete, false, DeleteCategories()),
                ],
              ),
            );
  }

  ListTile listTile(BuildContext context, String name, IconData icon, bool enabled, Widget myclass) {
    return ListTile(
                  leading: Icon(icon, color: Colors.green,),
                  title: Text(name),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  enabled: enabled,
                  onTap: (){
                    //open change Password
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => myclass),
                  );
                  },
                );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Settings title
      backgroundColor: Colors.grey.shade200,
      appBar: _buildAppBar('Settings'),
      // body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            _buildProfileCard(context),
            const SizedBox(height: 10.0),
            _buildMainCard(context),
            //notification settings
            const SizedBox(height: 10.0,),
            Text("Notification Settings", style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
              ),
            ),
            SwitchListTile(
              activeColor: Colors.green,
<<<<<<< HEAD
              //contentPadding: const EdgeInsets.all(0),
              value: false,
=======
              value: true,
>>>>>>> formatted code
              title: Text("Received notification"),
              onChanged: null,
            ),
            SwitchListTile(
              activeColor: Colors.green,
              value: false,
              title: Text("Bank Balance Warnings"),
              onChanged: null,
            ),
            SwitchListTile(
              activeColor: Colors.green,
              value: false,
              title: Text("Received Transaction"),
              onChanged: null,
            ),
            SwitchListTile(
              activeColor: Colors.green,
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

// AppBar _buildAppBar(){
  //   return AppBar(
  //       elevation: 4.0,
  //       brightness: Brightness.light,
  //       iconTheme: IconThemeData(color: Colors.black),
  //       backgroundColor: Colors.lightGreen[200],
  //       title: Text('Settings', style: TextStyle(
  //         color: Colors.green,
  //         fontSize: 20,
  //         fontWeight: FontWeight.bold, 
  //       ),),
  //     );
  // }