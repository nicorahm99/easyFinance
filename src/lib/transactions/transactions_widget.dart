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
    if (_transactions == null || _transactions.isEmpty) {
      _loadInitialValuesForCategories();
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
          child: AddButton(_fetchData),
        ),
      );
    }

    return Scaffold(
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

  List<Widget> _buildTransactionItemContainerList() {
    List<Widget> transactionContainers = List<Widget>();

    List<TransactionDTO> manipulatedTransactions = _transactions;
    manipulatedTransactions.sort((a, b) => a.dateTime.compareTo(b.dateTime));

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

  Future<void> _loadInitialValuesForCategories() async {
    List<CategoryDTO> potential = await DBController().categories();
    if (potential.isEmpty) {
      DBController().addBasicCategories();
    }
  }
}
