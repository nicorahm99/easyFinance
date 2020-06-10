import 'package:flutter/material.dart';

class Password extends StatelessWidget {
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
                validator: (val) {
                  if(val.length==0) {
                    return "password cannot be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
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
                validator: (val) {
                  if(val.length==0) {
                    return "password cannot be empty";
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
                color: Colors.white,
                  //textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green, width: 1)
                  ),
                onPressed: () {
                  // Navigate back to first route when tapped.
                    Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ]
          )
        ),
      )

      // Column(
      //   children: <Widget>[
      //     Center(
      //       child: TextField(
      //         decoration: InputDecoration(
      //           border: InputBorder.none,
      //           hintText: 'Enter a password'
      //         ),
      //       ),
      //     ),          
      //     Center(
      //       child: RaisedButton(
      //         onPressed: () {
      //           // Navigate back to first route when tapped.
      //             Navigator.pop(context);
      //         },
      //         child: Text('Save'),
      //       ),
      //     ),
      //   ],
      // )
    );
  }

  Padding createDistance(double distance) {
    return Padding(padding: EdgeInsets.only(top: distance));
    // return Container(
    //               margin: const EdgeInsets.symmetric(horizontal: 8.0,),
    //               width: double.infinity,
    //               height: 1.0,
    //               color: Colors.grey.shade400,
    //             );
  }
}

