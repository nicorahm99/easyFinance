import 'package:ef/transactions/addButton_widget.dart';
import 'package:ef/transactions/transactionItemContainer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:ef/persistence.dart';
import 'package:flutter/foundation.dart';
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
    if (_transactions == null) {
      return buildLoadingScreen();
    }
    if (_transactions.isEmpty){
      return buildInitialTransactionPage();
    }
    return Scaffold(
        appBar: _buildAppBar('Transactions'),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(children: _buildTransactionItemContainerList()))),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: AddButton(_fetchData),
      ),
    );
  }

  Scaffold buildInitialTransactionPage(){
    return Scaffold(
        appBar: _buildAppBar('Transactions'),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
              child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20,
                color: Colors.green,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'No Transactions yet.\n',
                ),
                TextSpan(
                    text: 'Tap the Button to add one!',
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ],
            ),
          ))
        ]),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: 
              AddButton(_fetchData),
            ),
      );
  }

  Scaffold buildLoadingScreen(){
    return Scaffold(
        appBar: _buildAppBar('Transactions'),
        body: Container()
      );
  }

  AppBar _buildAppBar(String _title){
  return AppBar(
        elevation: 4.0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.lightGreen[200],
        title: Text(_title, style: TextStyle(
          color: Colors.green,
          fontSize: 20,
          fontWeight: FontWeight.bold, 
        ),),
      );
  }

  List<Widget> _buildTransactionItemContainerList() {
    List<Widget> transactionContainers = List<Widget>();

    List<TransactionDTO> manipulatedTransactions = _transactions;
    manipulatedTransactions.sort((b, a) => a.dateTime.compareTo(b.dateTime));

    while (manipulatedTransactions.isNotEmpty) {
      List<TransactionDTO> cutTransactions = getAllTransactionsHavingDate(
          manipulatedTransactions, manipulatedTransactions[0].dateTime);
      manipulatedTransactions =
          removeGivenTransactionsfrom(manipulatedTransactions, cutTransactions);

      transactionContainers.add(TransactionItemContainer(cutTransactions, _fetchData));
      transactionContainers.add(Divider(
        color: Color.fromRGBO(255, 255, 255, 0),
      ));
    }

    return transactionContainers;
  }

  List<TransactionDTO> getAllTransactionsHavingDate(
      List<TransactionDTO> manipulatedTransactions, int dateTime) {
    List<TransactionDTO> foundTransactions = List<TransactionDTO>();
    manipulatedTransactions.forEach((element) {
      if (_isSameDay(element.dateTime, dateTime)) {
        foundTransactions.add(element);
      }
    });
    return foundTransactions;
  }

  List<TransactionDTO> removeGivenTransactionsfrom(
      List<TransactionDTO> sourceTransactions,
      List<TransactionDTO> givenTransactions) {
    givenTransactions.forEach((element) {
      sourceTransactions.remove(element);
    });
    return sourceTransactions;
  }

  bool _isSameDay(int dateTime, int dateTime2) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateTime);
    DateTime date2 = DateTime.fromMillisecondsSinceEpoch(dateTime2);
    if (date.year == date2.year &&
        date.month == date2.month &&
        date.day == date2.day) {
      return true;
    }
    return false;
  }

}
