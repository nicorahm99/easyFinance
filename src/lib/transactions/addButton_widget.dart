import 'package:ef/transactions/newTransaction_widget.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTransaction()),
          );
        },
        child: ClipOval(
          child: Container(
              color: Colors.blue,
              height: 60.0, // height of the button
              width: 60.0, // width of the button
              child: FittedBox(
                fit: BoxFit.contain,
                child: Center(child: Icon(Icons.add, color: Colors.white)),
              )),
        ));
  }
}
