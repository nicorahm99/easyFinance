import 'package:flutter/material.dart';
import 'package:ef/persistence.dart';


class BankBalance extends StatefulWidget{
  _BankBalanceState createState() => _BankBalanceState();
}

class _BankBalanceState extends State<BankBalance> {
  static GlobalKey<FormState> _formKeySBB = GlobalKey<FormState>();
  BankbalanceDTO _bankbalance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Set Bank-Balance"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            child: new Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: Form(
                  key: _formKeySBB,
                  child: new Center(
                      child: new Column(children: [
                    //titel
                    createDistance(140),
                    new Text(
                      'Please enter your bank-balance',
                      style: new TextStyle(color: Colors.green, fontSize: 25.0),
                    ),
                    createDistance(30),
                    buildBalanceInputField(),
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

  TextFormField buildBalanceInputField() {
    return new TextFormField(
                    key: Key('balanceInputField'),
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: "Amount",
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
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'This field is required';
                      } else if (RegExp(r"\d+(.\d+)?")
                              .allMatches(value)
                              .length ==
                          1) {
                        return null;
                      }
                      return 'Please enter a valid number';
                    },
                    onSaved: (String value) {
                      _bankbalance.currentbalance =
                          ((double.parse(value) * 100).floorToDouble()) / 100;
                    },
                  );
  }

  Future<void> save(BuildContext context) async {
    _bankbalance = await DBController().getBankbalance();
    
    if (!_formKeySBB.currentState.validate()) {
      return;
    }
    _formKeySBB.currentState.save();
    await DBController().updatebankbalance(_bankbalance);
    Navigator.pop(context);
  }

  Padding createDistance(double distance) {
    return Padding(padding: EdgeInsets.only(top: distance));
  }
}
