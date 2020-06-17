import 'package:flutter/material.dart';
import 'package:ef/persistence.dart';


class Password extends StatefulWidget{
  _PasswordState createState() => _PasswordState();
}

  //  @override
  // void initState() { //built in function of stateful widget
  //   super.initState();
  //   _fetchCategories(); // fetch function
  // }

  // Future<void> _fetchCategories() async { // async but void so theres no need to wait for it
  //   SettingDTO incomingAccount = await DBController().getSettingById(1); // get value from database
  //   setState(() {// set value
  //     _currentAccount = incomingAccount;
  //   });
  // }// Page can be loaded and if ready, value will be adapted

class _PasswordState extends State<Password> {
  static GlobalKey<FormState> _formKeySP = GlobalKey<FormState>();
  SettingDTO _currentSetting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Set Password"),
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

                    //textfield oldPW
                    new TextFormField(
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
                        if (val.length < 5) {
                          return "password too short";
                        } else {
                          return null;
                        }
                      },
                    ),
                    createDistance(10),
                    //textfield newPW
                    new TextFormField(
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
                    ),
                    createDistance(10),

                    //button
                    RaisedButton(
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
                    ),
                  ])),
                ))));
  }

  Future<void> save(BuildContext context) async {
    _currentSetting = await DBController().getSettingById(1);
    
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
