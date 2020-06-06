import 'package:ef/persistence.dart';
import 'package:flutter/material.dart';

class CategoryPicker extends StatefulWidget{
  final int categoryId;
  final Function(int) callback;
  const CategoryPicker(this.categoryId, this.callback);

  _CategoryPickerState createState() => _CategoryPickerState();
}
 
class _CategoryPickerState extends State<CategoryPicker>{
  CategoryDTO dropdownValue;
  List<CategoryDTO> categories = List<CategoryDTO>();

  @override
  void initState() {
    super.initState();
    _fetchCategory();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    List<CategoryDTO> incomingCategories = await DBController().categories();
    setState(() {
      categories = incomingCategories;
    });
  }

Future<void> _fetchCategory() async {
  CategoryDTO categoryDTO = await DBController().getCategoryById(widget.categoryId);
  setState(() {
    dropdownValue = categoryDTO;
  });
}

List<DropdownMenuItem<int>> _buildDropdownItemList(){
  List<DropdownMenuItem<int>> result = List<DropdownMenuItem<int>>();
  categories.forEach((CategoryDTO category) {
    DropdownMenuItem<int> item = 
      DropdownMenuItem<int>(
        value: category.id,
        child: Text(category.category),
      );
    result.add(item);
    });
  return result;
}
   

  @override
  Widget build(BuildContext context) {
    if (dropdownValue != null && categories.isNotEmpty){
    return DropdownButton<int>(
      value: dropdownValue.id,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (int newValue) {
        setState(() {
          dropdownValue.id = newValue;
          widget.callback(newValue);
        });
      },
      items: _buildDropdownItemList(),
    );
    }
    return Placeholder();
  }
}