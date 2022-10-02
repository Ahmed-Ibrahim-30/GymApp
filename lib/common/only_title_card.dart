import 'package:flutter/material.dart';

class OnlyTitleCard extends StatefulWidget {
  final String title;

  OnlyTitleCard(this.title);

  @override
  _OnlyTitleCardState createState() => _OnlyTitleCardState();
}

class _OnlyTitleCardState extends State<OnlyTitleCard> {
  int number = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xff181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
          minVerticalPadding: 10,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
