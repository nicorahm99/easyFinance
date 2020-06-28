import 'package:ef/persistence.dart';
import 'package:flutter/material.dart';


class DeleteQuestion extends StatefulWidget {
  final Function refresh;
  final String _name;
  final List<CategoryDTO> _categories;
  final int _index;

  DeleteQuestion(this._name, this._index, this._categories, this.refresh);

  _DeleteQuestionState createState() => _DeleteQuestionState();
}


class _DeleteQuestionState extends State<DeleteQuestion> {
  
  int _id;

// class DeleteQuestion extends StatelessWidget {
//   String _name;
//   List<CategoryDTO> _categories;
//   int _index;
//   int _id;
  
//   final Function refresh;

//   DeleteQuestion(this._name, this._index, this._categories, this.refresh);

  @override
  Widget build(BuildContext context) {
    _id = widget._categories[widget._index].id;
    return Scaffold(
        appBar: AppBar(
          title: Text("Delete " + widget._name),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: new Column(
            children: [
            createDistance(250),
            RaisedButton(
              key: Key('deleteButton'),
              color: Colors.white,
              //textColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.green, width: 1)),
              onPressed: () {
                // Navigate back to first route when tapped.
                checkforunCatTransaction(widget._name, _id);
                if (_id != 1 || widget._name != 'Miscellaneous'){DBController().deleteCategory(_id);}
                Navigator.pop(context);
                widget.refresh();
              },
              child: Text('Delete'),
            ),
            RaisedButton(
              color: Colors.white,
              //textColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.green, width: 1)),
              onPressed: () {
                // Navigate back to first route when tapped.
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ]),
        ));
  }

  Padding createDistance(double distance) {
    return Padding(padding: EdgeInsets.only(top: distance));
  }

  void checkforunCatTransaction(String _name, int _id) async {
    List<TransactionDTO> _transactions = await DBController().transactions();
    if (_id != 1 || _name != 'Miscellaneous') {
      _transactions.forEach((element) {
        if (element.category == _id) {
          element.category = 1;
          DBController().updateTransaction(element);
        }
       });
    }
  }
}
