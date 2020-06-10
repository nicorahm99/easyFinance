import 'package:flutter/material.dart';

class TransactionItemPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
            child: SizedBox(height: 50,),
      ),
    );
  }
}
