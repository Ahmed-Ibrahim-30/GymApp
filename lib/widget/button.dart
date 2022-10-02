import 'package:flutter/material.dart';
import '../style/styling.dart';

class Button extends StatelessWidget {
  final String btnTxt;
  final Function onTap;
  final bool border;
  final Color borderColor;
  final bool roundedBorder;

  const Button(
      {Key key,
      this.roundedBorder = false,
      this.btnTxt,
      this.onTap,
      this.border = false,
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: border ? Colors.transparent : Color(0xFFFFCE2B),
      borderRadius: roundedBorder
          ? BorderRadius.circular(PadRadius.radius)
          : BorderRadius.circular(5),
      child: InkWell(
        highlightColor: Colors.grey,
        //  splashColor: border ? AppColor.pColor : null,
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: roundedBorder
              ? BorderRadius.circular(PadRadius.radius)
              : BorderRadius.circular(5),
        ),
        child: Container(
          height: 53,
          decoration: BoxDecoration(
              border: border ? Border.all(color: borderColor) : null,
              borderRadius: roundedBorder
                  ? BorderRadius.circular(PadRadius.radius)
                  : BorderRadius.circular(5)),
          width: double.infinity,
          child: Center(
            child: Text(
              btnTxt,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
