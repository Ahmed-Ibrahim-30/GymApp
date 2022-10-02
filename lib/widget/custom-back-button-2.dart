import 'package:flutter/material.dart';

class CustomBackButton2 extends StatelessWidget {
  const CustomBackButton2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: new Icon(
        Icons.arrow_back_ios,
        color: Color(0xFFFFCE2B),
        size: 22.0,
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
