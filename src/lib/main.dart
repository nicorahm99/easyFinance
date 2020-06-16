import 'package:flutter/material.dart';
import 'main_widget.dart';


void main() => runApp(App());

class App extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     title: 'easyFinance',
     home: Main(),
   );
 }
}