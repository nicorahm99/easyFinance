import 'package:flutter/material.dart';

class TransactionsPlaceholderList extends StatelessWidget{
  List<Widget> containers = List<Widget>();

  _buildItems(){
    for (var i = 0; i < 10; i++) {
      containers.add(
        Padding(padding: EdgeInsets.all(10),child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        ),  )
      );
    }
  }

  @override
  Widget build(BuildContext context){
    _buildItems();
    return SingleChildScrollView(
      child: Column(
        children: containers,
      ),
    );
  }
}