import 'package:flutter/material.dart';

class BankBalance extends StatelessWidget {
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
                new Text('Please Enter Your Username',
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
                  validator: (val) {
                    if(val.length==0) {
                      return "amount cannot be empty";
                    }else{
                      return null;
                    }
                  },
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                createDistance(10),

                //button
                RaisedButton(
                  onPressed: () {
                    // Navigate back to first route when tapped.
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

  Padding createDistance(double distance) {
    return Padding(padding: EdgeInsets.only(top: distance));
  }
}