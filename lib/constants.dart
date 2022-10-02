import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Constants {
  // static String defaultUrl = 'http://159.122.172.202';
  //static String defaultUrl = 'https://itwinnow.com/';
  static String defaultUrl = 'https://najahnowgym.herokuapp.com/';
  //static String defaultUrl = 'https://asdwxz.herokuapp.com/';
  // static String defaultUrl = 'http://10.0.2.2:8000';
}
Color myYellow=Color(0xFFFFCE2B);
Color myYellow2=HexColor("F8B400");
Color myBlack=Color(0xff181818);
Color myGrey=HexColor("E2DCC8");
Color myBlue=HexColor("100720");
Color myPurple=HexColor("2A0944");
Color myPurple2=HexColor("4C3A51");
Color myPurple3=HexColor("774360");
Color myGreen=HexColor("1B2430");
Color myTealLight=HexColor("5FD068");
Color myTealDark=HexColor("05595B");

Widget backButton({@required BuildContext context}){
  return InkWell(
    onTap: () {
      Navigator.pop(context);
    },
    child: new Icon(
      Icons.arrow_back_ios,
      color: myYellow,
      size: 22.0.sp,
    ),
  );
}

Future<Object> goToAnotherScreenRemove(context,anotherScreen){
  return Navigator.pushAndRemoveUntil(context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: anotherScreen,
          inheritTheme: true,
          ctx: context),
          (route) => false
  );
}

Widget myText({@required String text,
  double fontSize=20,
  Color color=Colors.black,
  FontWeight fontWeight=FontWeight.normal,
}){
  return Text(
    text,
    style: GoogleFonts.poppins(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    ),
  );
}


Future<Object> goToAnotherScreenPush(context,anotherScreen,{PageTransitionType type=PageTransitionType.rightToLeft}){
  return Navigator.push(context,
    PageTransition(
        type: type,
        child: anotherScreen,
        inheritTheme: true,
        ctx: context),
  );
}


Future<Object> goToAnotherScreenPushReplacement(context,anotherScreen){
  return Navigator.pushReplacement(context,
    PageTransition(
        type: PageTransitionType.rightToLeft,
        child: anotherScreen,
        inheritTheme: true,
        ctx: context),
  );
}


void  myToast({String message,Color color}){
   Fluttertoast.showToast(
      msg: message,
      fontSize: 16.sp,
       gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: color,
      textColor: Colors.white,
  );
}

Widget myListTitle({
  @required String title,
  Color titleColor=Colors.white,
  @required double titleFontSize,
  int titleMaxLine=1,
  String subtitle='',
  double subtitleFontSize=14,
  int subtitleMaxLine=1,
  Widget leading=const SizedBox(),
  Widget trailing=const SizedBox(),
}){
  return ListTile(
    leading: Container(
      height: double.infinity,
      child: leading,
    ),
    title: Text(
      title,
      maxLines: titleMaxLine,
      style: TextStyle(
        fontSize: titleFontSize,
        fontWeight: FontWeight.w600,
        color: titleColor,
        overflow: TextOverflow.ellipsis,
        fontFamily: 'assets/fonts/Changa-Bold.ttf',
      ),
    ),
    subtitle: subtitle!=''?Text(
      subtitle,
      maxLines: subtitleMaxLine,
      style: TextStyle(
        fontSize: subtitleFontSize,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        fontFamily: 'assets/fonts/Changa-Bold.ttf',
      ),
    ):const SizedBox(),
    trailing: trailing,
    contentPadding: EdgeInsets.zero,
  );
}


void myAlertDialog({
  @required BuildContext context,
  @required Widget Body,
}){
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Body;
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}

int handleApi(item){
  return item is String?int.parse(item):item;
}

Widget myDropDownList({
  @required List<String>items,
  @required dynamic onChanged,
  @required String selectedItem,
  @required String labelText,
  bool showClearButton=false,

}){
  return DropdownSearch<String>(
      mode: Mode.MENU,
      showSelectedItems: true,
      items:items,
      showClearButton: showClearButton,
      popupItemDisabled: (String s) => s.startsWith('I'),
      onChanged: onChanged,
      validator: (String item) {
        if (item == null)
          return "Required field";
        else
          return null;
      },
      popupBarrierDismissible: true,
      dropdownSearchDecoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          hintText: "Enter Member Email",
          hintStyle: TextStyle(color: Colors.black),
          labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.bold
          )
      ),
      selectedItem: selectedItem??'');
}
