import 'package:flutter/cupertino.dart';
import 'package:ef/persistence.dart';

class TransactionItem extends StatelessWidget {
  final TransactionDTO transaction;
  const TransactionItem(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('$transaction.type $transaction.amount'),
            Text('$transaction.dateTime')
          ],
        ),
        Row(
          children: <Widget>[
            Text('$transaction.category'),
            Text('$transaction.note')
          ],
        )
      ],
    )));
  }
}
