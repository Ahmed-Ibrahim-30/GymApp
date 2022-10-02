import 'package:flutter/material.dart';

class CustomMaterialButton extends StatefulWidget {
  //const CustomMaterialButton({ Key key }) : super(key: key);
  final Function onPressed;
  final String text;
  final bool formButton;
  bool enable;

  CustomMaterialButton(
      {this.text, this.onPressed, this.formButton, this.enable = true});

  @override
  _CustomMaterialButtonState createState() => _CustomMaterialButtonState();
}

class _CustomMaterialButtonState extends State<CustomMaterialButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.formButton) widget.enable = true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.formButton
        ? MaterialButton(
            onPressed: widget.onPressed,
            height: 50,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            disabledColor: Color(0xFF404040),
            color: widget.enable ? Colors.amber : Color(0xFF404040),
            child: Text(
              widget.text,
              //'${widget.post_type} Question',
              style: TextStyle(
                color: widget.enable ? Colors.black : Colors.white,
                fontFamily: 'assets/fonts/Changa-Bold.ttf',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            elevation: 2,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: widget.enable ? Colors.amber : Color(0xFF404040)),
            ),
          )
        : MaterialButton(
            onPressed: widget.onPressed,
            child: Text(widget.text),
            color: Color(0xFFFFCE2B),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Color(0xFFFFCE2B),
              ),
            ),
          );
  }
}
