import 'package:flutter/material.dart';
import 'package:ef/persistence.dart';

class Categories extends StatelessWidget {
  static GlobalKey<FormState> _formKeySC = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Your Own Categories"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            child: new Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: Form(
                  key: _formKeySC,
                  child: new Center(
                      child: new Column(children: [
                    //titel
                    createDistance(140),
                    new Text(
                      'Please type in a new category',
                      style: new TextStyle(color: Colors.green, fontSize: 25.0),
                    ),
                    createDistance(30),

                    //textfield
                    new TextFormField(
                      key: Key('categoryInputField'),
                      decoration: new InputDecoration(
                        labelText: "category",
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
                        if (val.length == 0) {
                          return "category cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String value) {
                        DBController().insertCategory(value);
                      },
                    ),
                    createDistance(10),

                    //button
                    RaisedButton(
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
                    ),
                  ])),
                ))));
  }

  Future<void> save(BuildContext context) async {
    if (!_formKeySC.currentState.validate()) {
      return;
    }
    _formKeySC.currentState.save();
    Navigator.pop(context);
  }

  Padding createDistance(double distance) {
    return Padding(padding: EdgeInsets.only(top: distance));
  }
}
