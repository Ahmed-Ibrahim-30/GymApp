import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/constants.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myGreen,
        elevation: 2.0,
        leading: backButton(context: context),
        title: Text('About Us',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                fontFamily: 'sans-serif-light',
                color: Colors.white)),
      ),
      backgroundColor: myPurple2,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          new SingleChildScrollView(
            padding: EdgeInsets.only(left: 5, right: 20),
            scrollDirection: Axis.horizontal,
            child: new Row(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/images/equipment2.jpg',
                    fit: BoxFit.cover,
                  ),
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                Container(
                  child: Image.asset(
                    'assets/images/others-supplements.png',
                    fit: BoxFit.cover,
                  ),
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                Container(
                  child: Image.asset(
                    'assets/images/others-supplements.png',
                    fit: BoxFit.cover,
                  ),
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                Container(
                  child: Image.asset(
                    'assets/images/others-supplements.png',
                    fit: BoxFit.cover,
                  ),
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                Container(
                  child: Image.asset(
                    'assets/images/others-supplements.png',
                    fit: BoxFit.cover,
                  ),
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                // ...
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                child: Text(
                  "Gym Information",
                  style: TextStyle(
                    color: Color(0xFFFFCE2B),
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                  ),
                ),
              ),
            ],
          ),
          Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Text("About Us",
                  style: TextStyle(
                    color: Color(0xFFFFCE2B),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                  ))),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin psum dolor sit amet, consectetur adipiscing elconsectetur adipiscing elit. Proin dignipsum dolor sit amet, consectetur adipiscing elit. Proin dignipsum dolor sit amet, consectetur adipiscing elit. Proin dignipsum dolor s. Donec et eleifend quam, a sollicitudin magna.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13.0.sp,
                fontFamily: 'assets/fonts/ProximaNova-Regular.otf',
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Text("Contact Us",
                  style: TextStyle(
                    color: myYellow2,
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                  ))),
          Container(
            padding: EdgeInsets.only(left: 20.0.w, right: 20.0.w),
            child: Text(
              "Call : 01027709271\nEmail : ahmedibrahim55518@gmail.com",
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 15.0,
                fontFamily: 'assets/fonts/ProximaNova-Regular.otf',
              ),
            ),
          ),
          Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Text("Location",
                  style: TextStyle(
                    color: Color(0xFFFFCE2B),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                  ))),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              "12 example St, .... ",
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 15.0,
                fontFamily: 'assets/fonts/ProximaNova-Regular.otf',
              ),
            ),
          ),
          SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }
}
