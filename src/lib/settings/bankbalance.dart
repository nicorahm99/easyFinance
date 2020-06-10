import 'package:flutter/material.dart';
import 'package:ef/persistence.dart';

class BankBalance extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BankbalanceDTO _bankbalance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Bank-Balance"),
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
                new Text('Please enter your bank-balance',
                style: new TextStyle(color: Colors.green, fontSize: 25.0),),
                createDistance(30),

                //textfield
                new TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    labelText: "Amount",
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

                  // validator
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'This field is required';
                    } else if (RegExp(r"\d+(.\d+)?").allMatches(value).length == 1) {
                      return null;
                    }
                    return 'Please enter a valid number';
                  },
                  onSaved: (String value) {
                    _bankbalance.currentbalance = ((double.parse(value) * 100).floorToDouble()) / 100;
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
                    save();
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ]
            )
          ),
        ),
    );
  }

  Future<void> save() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    await DBController().insertbankbalance(_bankbalance);
  }

  Padding createDistance(double distance) {
    return Padding(padding: EdgeInsets.only(top: distance));
  }
}