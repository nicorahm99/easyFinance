import 'package:flutter/material.dart';
import 'package:ef/persistence.dart';
import 'deleteQuestion.dart';


class DeleteCategories extends StatefulWidget {
  @required final Function refresh;

  DeleteCategories({Key key, this.refresh}) : super(key: key);
  _DelCatState createState() => _DelCatState();
}


class _DelCatState extends State<DeleteCategories> {
  List<CategoryDTO> _categories;

  @override
  void initState() { //built in function of stateful widget
    super.initState();
    _fetchCategories(); // fetch function
  }

  Future<void> _fetchCategories() async { // async but void so theres no need to wait for it
    List<CategoryDTO> incomingCategories = await DBController().categories(); // get value from database
    setState(() {// set value
      _categories = incomingCategories;
    });
  }// Page can be loaded and if ready, value will be adapted

  ListTile _buildListTile(BuildContext context, int index){
    return ListTile(
                    //leading: Icon(Icons.category, color: Colors.green,),
                    title: Text(_categories[index].category),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      //open set bank balance
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DeleteQuestion(_categories[index].category, index, _categories, _fetchCategories))
                      );
                    },
                  );
  }

  List<Widget> _buildWidgetList(BuildContext context){
    List<Widget> list = List<Widget>();
    if (_categories != null){
      for (int i = 0; i<_categories.length; i++){
        list.add(_buildListTile(context, i));
        list.add(buildDevider());
      }
      return list;
    }
    return list;
  }

  Container buildDevider() {
    return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0,),
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey.shade400,
                );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Settings title
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
          title: Text("Delete Categories"),
          backgroundColor: Colors.green,
        ),
      // body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            Card(// page opening settings
              elevation: 4.0, // shadow
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: _buildWidgetList(context)
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        )
      ),
    );
  }

  Future<void> save(BuildContext context) async {
    // _currentAccount = await DBController().getSetting();
    
    // if (!_formKeySA.currentState.validate()) {
    //   return;
    // }
    // _formKeySA.currentState.save();// hier springt es raus, validator ok

    // await DBController().updateSettings(_currentAccount);
    // Navigator.pop(context);
    // widget.refresh();
  }

  Padding createDistance(double distance) {
    return Padding(padding: EdgeInsets.only(top: distance));
  }
}
