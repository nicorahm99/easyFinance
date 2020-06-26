import 'package:ef/persistence.dart';
import 'package:ef/transactions/categoryPicker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EditTransaction extends StatefulWidget {
  final TransactionDTO transaction;
  final Function callback;
  const EditTransaction(this.transaction, this.callback);

  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  TransactionDTO _transaction;
  BankbalanceDTO _bankBalance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _transaction = widget.transaction;
  }

  Widget _buildAmount() {
    return TextFormField(
      initialValue: _transaction.amount.toString(),
      decoration: InputDecoration(labelText: 'Amount'),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return 'This field is required';
        } else if (RegExp(r"\d+(.\d+)?").allMatches(value).length == 1) {
          return null;
        }
        return 'Please enter a valid number';
      },
      onSaved: (String value) {
        _transaction.amount =
            ((double.parse(value) * 100).floorToDouble()) / 100;
      },
    );
  }

  Widget _buildType() {
    return Wrap(
        alignment: WrapAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: <Widget>[
          RadioListTile<String>(
            title: const Text('Income'),
            value: 'income',
            groupValue: _transaction.type,
            onChanged: (String value) {
              setState(() {
                _transaction.type = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Expense'),
            value: 'expense',
            groupValue: _transaction.type,
            onChanged: (String value) {
              setState(() {
                _transaction.type = value;
              });
            },
          )
        ]);
  }

  Widget _buildCategory() {
    return CategoryPicker(_transaction.category, setCategory);
  }

  void setCategory(int value) {
    setState(() {
      _transaction.category = value;
    });
  }

  Widget _buildNote() {
    return TextFormField(
      initialValue: _transaction.note,
      decoration: InputDecoration(labelText: 'Note'),
      maxLength: 255,
      onSaved: (String value) {
        _transaction.note = value;
      },
    );
  }

  Widget _buildDateTime() {
    return Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Colors.grey),
        )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              _transaction.getGermanDateTimeString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RaisedButton(
                onPressed: () => _showDatePicker(),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.green,
                )),
          ],
        ));
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now().subtract(new Duration(days: 365)),
        maxTime: DateTime.now(),
        theme: DatePickerTheme(
            headerColor: Colors.white,
            backgroundColor: Colors.green,
            itemStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.green, fontSize: 16)),
        onConfirm: (date) {
      setState(() {
        _transaction.dateTime = date.millisecondsSinceEpoch;
      });
    }, currentTime: DateTime.now(), locale: LocaleType.de);
  }

  Future<void> update() async {
    TransactionDTO _oldtransaction = await DBController().getTransactionById(_transaction.id);
    _bankBalance = await DBController().getBankbalance();
    double _currentbalance = _bankBalance.currentbalance;
    double _oldbalance;
    if (_oldtransaction.type == "income") {
      _oldbalance = _currentbalance - _oldtransaction.amount;
    } else {
      _oldbalance = _currentbalance + _oldtransaction.amount;
    }
    
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    double _newBalanceValue;

    if (_transaction.type == "income") {
      _newBalanceValue = _oldbalance + _transaction.amount;
    } else {
      _newBalanceValue = _oldbalance - _transaction.amount;
    }
    _bankBalance.currentbalance = _newBalanceValue;

    await DBController().updatebankbalance(_bankBalance);
    await DBController().updateTransaction(_transaction);
    Navigator.pop(context);
    widget.callback();
  }

  Future<void> delete() async {
    TransactionDTO _oldtransaction = await DBController().getTransactionById(_transaction.id);
    _bankBalance = await DBController().getBankbalance();
    double _currentbalance = _bankBalance.currentbalance;
    double _newbalance;
    if (_oldtransaction.type == "income") {
      _newbalance = _currentbalance - _oldtransaction.amount;
    } else {
      _newbalance = _currentbalance + _oldtransaction.amount;
    }
    _bankBalance.currentbalance = _newbalance;
    
    await DBController().updatebankbalance(_bankBalance);
    await DBController().deleteTransaction(_transaction.id);
    Navigator.pop(context);
    widget.callback();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Edit Transaction'), backgroundColor: Colors.green),
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildAmount(),
                _buildType(),
                _buildCategory(),
                _buildNote(),
                _buildDateTime(),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                      onPressed: () => update(),
                      child: Icon(Icons.save),
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: RaisedButton(
                      onPressed: () => delete(),
                      child: Icon(Icons.delete, color: Colors.red),
                    ))
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
