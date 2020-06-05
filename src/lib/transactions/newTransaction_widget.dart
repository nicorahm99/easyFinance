import 'package:ef/persistence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class NewTransaction extends StatefulWidget {
  final Widget child;

  NewTransaction({Key key, this.child}) : super(key: key);

  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  TransactionDTO _transaction;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildAmount() {
    return TextFormField(
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
    return TextFormField(
      decoration: InputDecoration(labelText: 'Category'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      onSaved: (String value) {
        _transaction.category = value;
      },
    );
  }

  Widget _buildNote() {
    return TextFormField(
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

  Future<void> submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    await DBController().insertTransaction(_transaction);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _transaction = TransactionDTO(
        type: 'expense', dateTime: DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('new Transaction'), backgroundColor: Colors.green),
        body: Container(
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
                RaisedButton(
                  onPressed: () => submit(),
                  child: Icon(Icons.check),
                )
              ],
            ),
          ),
        ));
  }
}
