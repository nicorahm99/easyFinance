import 'package:flutter/material.dart';
import 'package:ef/persistence.dart';

class Password extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SettingDTO _setting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Password"),
        backgroundColor: Colors.green,
      ),
      body: 
      new Container (
        padding: const EdgeInsets.all(30.0),
        color: Colors.white,
        child: new Center(
          child: new Column(
            children : [
              //titel
              createDistance(140),
              new Text('Please enter your password',
              style: new TextStyle(color: Colors.green, fontSize: 25.0),),
              createDistance(30),

              //textfield oldPW
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "old Password",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                ),
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),

                //validator
                validator: (val) {
                  //check if PW correct
                  if(val.length<5) {
                    return "password too short";
                  }else{
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
                    borderSide: new BorderSide(
                    ),
                  ),
                ),
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),

                //validator
                validator: (val) {
                  if(val.length<5) {
                    return "password too short";
                  }else{
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
                    side: BorderSide(color: Colors.green, width: 1)
                  ),
                onPressed: () {
                  // Navigate back to first route when tapped.
                  save(context);
                },
                child: Text('Save'),
              ),
            ]
          )
        ),
      )
    );
  }

  Future<void> save(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    await DBController().insertSettings(_setting);
    Navigator.pop(context);
  }


  Padding createDistance(double distance) {
    return Padding(padding: EdgeInsets.only(top: distance));
  }
}

