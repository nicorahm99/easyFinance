import 'package:flutter/material.dart';
import 'package:ef/persistence.dart';


class Password extends StatefulWidget{
  _PasswordState createState() => _PasswordState();
}


class _PasswordState extends State<Password> {
  static GlobalKey<FormState> _formKeySP = GlobalKey<FormState>();
  SettingDTO _currentSetting;

  
  @override
  void initState() { //built in function of stateful widget
    super.initState();
    _fetchSettings(); // fetch function
  }

  Future<void> _fetchSettings() async { // async but void so theres no need to wait for it
    SettingDTO incomingAccount = await DBController().getSetting(); // get value from database
    setState(() {// set value
      _currentSetting = incomingAccount;
    });
  }// Page can be loaded and if ready, value will be adapted

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Change Password"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            child: new Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: Form(
                  key: _formKeySP,
                  child: new Center(
                      child: new Column(children: [
                    //titel
                    createDistance(140),
                    new Text(
                      'Please enter your password',
                      style: new TextStyle(color: Colors.green, fontSize: 25.0),
                    ),
                    createDistance(30),
                    buildOldPasswordInputField(),
                    createDistance(10),
                    buildNewPasswordInputField(),
                    createDistance(10),
                    buildSaveButton(context),
                  ])),
                ))));
  }

  RaisedButton buildSaveButton(BuildContext context) {
    return RaisedButton(
                    key: Key('saveButton'),
                    color: Colors.white,
                    //textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green, width: 1)),
                    onPressed: () {
                      // Navigate back to first route when tapped.
                      save(context);
                    },
                    child: Text('Save'),
                  );
  }

  TextFormField buildNewPasswordInputField() {
    return new TextFormField(
                    key: Key('newPasswordInputField'),
                    decoration: new InputDecoration(
                      labelText: "new Password",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),

                    //validator
                    validator: (val) {
                      if (val.length < 5) {
                        return "password too short";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (String value) {
                      _currentSetting.password = value;
                    },
                  );
  }

  TextFormField buildOldPasswordInputField() {
    return new TextFormField(
                    key: Key('oldPasswordInputField'),
                    decoration: new InputDecoration(
                      labelText:
                          "old Password", // check against value in database
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),

                    //validator
                    validator: (val) {
                      //check if PW correct
                      if (val != _currentSetting.password) {
                        return "incorrect password!";
                      } else {
                        return null;
                      }
                    },
                  );
  }

  Future<void> save(BuildContext context) async {
    if (!_formKeySP.currentState.validate()) {
      return;
    }
    
    _formKeySP.currentState.save(); // hier springt es raus, validator ok

    await DBController().updateSettings(_currentSetting);
    Navigator.pop(context);
  }

  Padding createDistance(double distance) {
    return Padding(padding: EdgeInsets.only(top: distance));
  }
}
