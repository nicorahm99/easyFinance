import 'package:flutter/material.dart';


class Div extends StatelessWidget {
  final Color _color;

  Div(this._color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
      ),
      child: Text('Hello'),
    );
  }
}