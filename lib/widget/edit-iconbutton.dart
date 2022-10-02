import 'package:flutter/material.dart';

class EditIconButton extends StatefulWidget {
  //const EditIconButton({Key key}) : super(key: key);
  final Function onPressed;

  EditIconButton({this.onPressed});

  @override
  _EditIconButtonState createState() => _EditIconButtonState();
}

class _EditIconButtonState extends State<EditIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      //constraints: BoxConstraints(maxHeight: 15, maxWidth: 15),
      //iconSize: MediaQuery.of(context).size.width * 0.045,
      child: Icon(
        Icons.edit,
        size: MediaQuery.of(context).size.width * 0.045,
        color: Colors.grey,
      ),
    );
  }
}
