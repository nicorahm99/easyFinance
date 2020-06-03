import 'package:ef/transactions/addButton_widget.dart';
import 'package:ef/transactions/newTransaction_widget.dart';
import 'package:ef/transactions/transactionItem_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:ef/persistence.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  final Widget child;

  TransactionPage({Key key, this.child}) : super(key: key);

  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<TransactionDTO> _transactions;

  _fetchData() async {
    List<TransactionDTO> data = await DBController().transactions();
    setState(() {
      _transactions = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _transactions = List<TransactionDTO>();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if (_transactions == null && _transactions.isEmpty) {
      return Scaffold(
          appBar: null,
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
                child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.lightBlue,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Du hast noch nichts Ausgegeben.\n',
                  ),
                  TextSpan(
                      text: 'Herzlichen Glückwunsch!',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ],
              ),
            ))
          ]),
          floatingActionButton: Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewTransaction()),
                  ).then((v) => _fetchData());
                },
                child: AddButton(),
              ),
          ));
    }

    return Scaffold(
      body: Column(children: buildTransactionItemsList()),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: AddButton(),
      ),
    );
  }

  List<TransactionItem> buildTransactionItemsList() {
    List<TransactionItem> items = List<TransactionItem>();
    _transactions.forEach((transaction) {
      TransactionItem _transactionItem = TransactionItem(transaction);
      items.add(_transactionItem);
     });
    return items;
  }
}
