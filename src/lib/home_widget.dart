import 'package:ef/diagrams_widget.dart';
import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'diagrams_widget.dart';
import './settings/settings.dart';


class Home extends StatefulWidget {
 @override
 State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
 int _currentIndex = 0;
 final List<Widget> _children = [
   PlaceholderWidget(Colors.red),
   PlaceholderWidget(Colors.deepOrange),
   DiagramPage(),
   Settings()
 ];
 @override
 Widget build(BuildContext context) {
   return Scaffold(

     appBar: AppBar(
       title: Text('easyFinance'),
       backgroundColor: Colors.green,
     ),
     body: _children[_currentIndex],
     bottomNavigationBar:
     new Theme(
      data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
        canvasColor: Colors.green,
        // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        primaryColor: Colors.red,
        textTheme: Theme
            .of(context)
            .textTheme
            .copyWith(caption: new TextStyle(color: Colors.yellow))), // sets the inactive color of the `BottomNavigationBar` 
     
      child:
      BottomNavigationBar(
       onTap: onTabTapped,
       currentIndex: _currentIndex,
       items: [
         BottomNavigationBarItem(
           icon: new Icon(Icons.home),
           title: new Text('Home'),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.credit_card),
           title: new Text('Transactions'),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.donut_small),
           title: new Text('Diagrams')
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.settings),
           title: new Text('Settings')
         ),
       ],
     ),
   ),
   );
 }
 void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }
}

