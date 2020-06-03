import 'package:ef/transactions/addButton_widget.dart';
import 'package:ef/transactions/transaction_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:ef/persistence.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  final Widget child;

  TransactionPage({Key key, this.child}) : super(key: key);

  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<TransactionDTO> transactions;

  _fetchData() {
    DBController controller = new DBController();
    Future<List<TransactionDTO>> transactions = controller.transactions();
    transactions.whenComplete(
        () => this.transactions = transactions as List<TransactionDTO>);
  }

  @override
  void initState() {
    super.initState();
    transactions = List<TransactionDTO>();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Scaffold(
          appBar: null,
          body: Center(
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
          )),
          floatingActionButton: Align(
            alignment: Alignment.bottomRight,
            child: AddButton(),
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
    List<TransactionItem> items;
    transactions.map((transaction) => items.add(TransactionItem(transaction)));
    return items;
  }
}
