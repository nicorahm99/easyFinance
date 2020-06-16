import 'package:flutter/material.dart';
import 'package:ef/persistence.dart';

class Account extends StatelessWidget {
  static GlobalKey<FormState> _formKeySA = GlobalKey<FormState>();
  SettingDTO _setting;// liegt hier dran, das müsste final sein
  SettingDTO currentAccount;

  //  @override
  // void initState() { //built in function of stateful widget
  //   super.initState();
  //   _fetchCategories(); // fetch function
  // }

  // Future<void> _fetchCategories() async { // async but void so theres no need to wait for it
  //   SettingDTO incomingAccount = await DBController().getSettingById(1); // get value from database
  //   setState(() {// set value
  //     currentAccount = incomingAccount;
  //   });
  // }// Page can be loaded and if ready, value will be adapted

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Account"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            child: new Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: Form(
                  key: _formKeySA,
                  child: new Center(
                      child: new Column(children: [
                    //titel
                    createDistance(140),
                    new Text(
                      'Please enter your username',
                      style: new TextStyle(color: Colors.green, fontSize: 25.0),
                    ),
                    createDistance(30),

                    //textfield
                    new TextFormField(
                      decoration: new InputDecoration(
                        labelText: "username", //currentAccount.username
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),

                      // validator
                      validator: (val) {
                        if (val.length == 0) {
                          return "username cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String value) {
                        _setting.username = value;
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
                        child: Text(
                          'Save',
                        ) //style: TextStyle(fontSize: 10),
                        ),
                  ])),
                ))));
  }

  Future<void> save(BuildContext context) async {
    if (!_formKeySA.currentState.validate()) {
      return;
    }
    _formKeySA.currentState.save();// hier springt es raus, validator ok

    await DBController().updateSettings(_setting);
    Navigator.pop(context);
  }

  Padding createDistance(double distance) {
    return Padding(padding: EdgeInsets.only(top: distance));
  }
}
