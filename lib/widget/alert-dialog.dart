import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  //const CustomAlertDialog({Key key}) : super(key: key);
  final String text;
  final List<Widget> actions;

  CustomAlertDialog({this.text, this.actions});

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF181818),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF181818)),
      ),
      content: Text(
        widget.text,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'assets/fonts/Changa-Bold.ttf',
          fontSize: 15,
        ),
      ),
      actions: widget.actions,
    );
  }
}
