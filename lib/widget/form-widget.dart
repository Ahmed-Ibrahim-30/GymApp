import 'package:flutter/material.dart';

import 'custom-back-button-2.dart';

class FieldTitle extends StatelessWidget {
  final String title;

  FieldTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class FormTitle extends StatelessWidget {
  final String title;

  FormTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  //---> topic
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[],
            )
          ],
        ));
  }
}

class PageTitle extends StatelessWidget {
  final String title;
  PageTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 100.0,
      color: Color(0xFF181818), //background color
      child: new Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomBackButton2(),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    //-->header
                    child: new Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'sans-serif-light',
                            color: Colors.white)),
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class CustomTextFieldWidget extends StatelessWidget {
  TextEditingController controller;
  String hintText;

  CustomTextFieldWidget(
    this.controller,
    this.hintText,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: new TextFormField(
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Value cannot be empty!';
                  }
                  return null;
                },
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                ),
              ),
            ),
          ],
        ));
  }
}

class CustomNumericalTextField extends StatelessWidget {
  CustomNumericalTextField({
    @required this.controller,
    @required this.hintText,
  });

  TextEditingController controller;
  String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: new TextFormField(
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Value cannot be empty!';
                  }

                  return null;
                },
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                ),
              ),
            ),
          ],
        ));
  }
}
