import 'package:flutter/material.dart';

class Questions extends StatelessWidget {
  var text;
  Questions(this.text);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      margin: EdgeInsets.all(20),
      child: Text(
        this.text,
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    ));
  }
}
