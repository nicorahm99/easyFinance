import 'package:ef/persistence.dart';
import 'package:ef/settings/deleteCategories.dart';
import 'package:flutter/material.dart';

class DeleteQuestion extends StatelessWidget {
  String _name;
  int _id;
  List<CategoryDTO> _categories;

  DeleteQuestion(String name, int index, List<CategoryDTO> cats) {
    this._name = name;
    this._categories = cats;
    this._id = _categories[index].id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Delete " + _name),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: new Column(
            children: [
            // createDistance(140),
            RaisedButton(
              color: Colors.white,
              //textColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.green, width: 1)),
              onPressed: () {
                // Navigate back to first route when tapped.
                if (_id != 1 || _name == 'Miscellaneous'){DBController().deleteCategory(_id);}
                Navigator.pop(context);
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

}
