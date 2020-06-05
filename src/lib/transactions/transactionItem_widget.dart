import 'package:ef/transactions/editTransaction_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:ef/persistence.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final TransactionDTO transaction;
  const TransactionItem(this.transaction);

  Widget _buildRealAmount(){
    String output = '';
    TextStyle textStyle = TextStyle();
    if (transaction.type == 'expense'){
      output += '-';
      textStyle = TextStyle(color: Colors.red[800], fontSize: 20);
    }
    else if (transaction.type == 'income'){
      output += '+';
      textStyle = TextStyle(color: Colors.green[900], fontSize: 20);
    }
    output += (' ' + transaction.amount.toString());
    return Text(output, style: textStyle,);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => EditTransaction(transaction)));},
            child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ClipOval(
          child: Container(
              color: Colors.blue,
              height: 40.0, // height of the button
              width: 40.0, // width of the button
              child: Center(child: Text(transaction.category[0].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 30))),
              ),
        ),
            Text(transaction.category),
            SizedBox(width: 80,),
            _buildRealAmount(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(transaction.note, style: TextStyle(color: Colors.grey),)
          ],
        )
      ],
    ));
  }
}
