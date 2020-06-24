import 'package:ef/enterPassword_widget.dart';
import 'package:flutter/material.dart';


void main() => runApp(App());

class App extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     title: 'easyFinance',
     home: PasswordPage(),
   );
 }
}