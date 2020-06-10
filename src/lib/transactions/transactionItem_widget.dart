import 'package:ef/transactions/editTransaction_widget.dart';
import 'package:ef/transactions/transactionItemPlaceholder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:ef/persistence.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatefulWidget {
  final TransactionDTO transactionDTO;
  const TransactionItem(this.transactionDTO);

  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  TransactionDTO transaction;
  CategoryDTO category;

  Widget _buildRealAmount() {
    String output = '';
    TextStyle textStyle = TextStyle();
    if (transaction.type == 'expense') {
      output += '-';
      textStyle = TextStyle(color: Colors.red[800], fontSize: 20);
    } else if (transaction.type == 'income') {
      output += '+';
      textStyle = TextStyle(color: Colors.green[900], fontSize: 20);
    }
    output += (' ' + transaction.amount.toString());
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          output,
          style: textStyle,
        ));
  }

  @override
  void initState() {
    super.initState();
    transaction = widget.transactionDTO;
    _fetchCategory();
  }

  void _fetchCategory() async {
    CategoryDTO categoryDTO =
        await DBController().getCategoryById(transaction.category);
    setState(() {
      category = categoryDTO;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (category != null) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditTransaction(transaction)));
        },
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ClipOval(
                      child: Container(
                        color: Colors.blue,
                        height: 40.0, // height of the button
                        width: 40.0, // width of the button
                        child: Center(
                            child: Text(category.category[0].toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30))),
                      ),
                    )),
                Text(category.category),
                Expanded(
                  child: Container(),
                ),
                _buildRealAmount(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  transaction.note,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            )
          ],
        ));
    }
    else
    {
      return TransactionItemPlaceholder();
    }
  }
}
