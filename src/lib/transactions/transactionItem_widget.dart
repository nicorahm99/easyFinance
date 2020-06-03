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
    return Expanded(
        child: Container(
            child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildRealAmount(),
            Text(transaction.getGermanDateTimeString())
          ],
        ),
        Row(
          children: <Widget>[
            Text(transaction.category),
            Text(transaction.note)
          ],
        )
      ],
    )));
  }
}
