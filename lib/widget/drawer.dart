import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/admin/users/users_list.dart';
import 'package:gym_project/screens/coach/coach_profile.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:gym_project/screens/common/login-screen.dart';

import 'global.dart';

class MyDrawer extends StatelessWidget {
  final String name;
  final String email;
  MyDrawer(this.name, this.email);

  void logout(BuildContext context) {
    Provider.of<LoginViewModel>(context, listen: false)
        .fetchLogout()
        .then((value) {
      myToast(message: "Logout Successfully",color: Colors.green);
      goToAnotherScreenPushReplacement(context, Login());
    }).catchError((err) {
      myToast(message: "Logout Successfully",color: Colors.green);
      goToAnotherScreenPushReplacement(context, Login());
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: myBlack,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(290.r))
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  color: myBlue,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 25.w),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 52.r,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(52.r),
                              child: Image.asset('assets/images/blank.png'),
                            ),
                          ),
                          SizedBox(height: 16.h,),
                          Text(
                            name,
                            style: TextStyle(color: myYellow,fontWeight: FontWeight.bold,fontSize: 20.sp),
                          ),
                          Text(
                            email,
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "assets/fonts/Changa-Bold.ttf"),
                          ),
                        ],
                      )
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Wrap(
                    children: [
                      if(Global.role=='coach')ListTile(
                        leading: Icon(Icons.person,color: Colors.white,),
                        title:  Text(
                          'Profile',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.sp),
                        ),
                        onTap: () {
                          goToAnotherScreenPush(context, CoachProfile());
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.account_balance,color: Colors.white,),
                        title:  Text(
                          'About us',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.sp),
                        ),
                        onTap: () {
                          // Update the state of the app
                          // ...
                          // Then close the drawer
                          Navigator.pushNamed(context, '/about-us');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout,color: Colors.white,),
                        title: Text(
                          'logout',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.sp),
                        ),
                        onTap: () {
                          myAlertDialog(context: context, Body: Center(
                            child: Padding(
                              padding:EdgeInsets.fromLTRB(22.w, 0, 22.w, 0),
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30.h,horizontal: 40.w),
                                  child:Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        child: Text("Are you sure Logout ?",style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        )),
                                      ),
                                      SizedBox(height: 20.h,),
                                      FittedBox(
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 100.w,
                                                height: 35.h,
                                                child: new ElevatedButton(
                                                  child: new Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        fontSize: 16.sp
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                      shape: new RoundedRectangleBorder(
                                                        borderRadius:
                                                        new BorderRadius.circular(10.0.r),
                                                      ),
                                                      primary: Color(0xFFFFCE2B),
                                                      onPrimary: Colors.black,
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 10, vertical: 5),
                                                      textStyle: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                  onPressed: () {
                                                    FocusScope.of(context).requestFocus(new FocusNode());
                                                    logout(context);
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 20.w,),
                                              Container(
                                                width: 100.w,
                                                height: 35.h,
                                                child: new ElevatedButton(
                                                  child: new Text(
                                                    "NO",
                                                    style: TextStyle(
                                                        fontSize: 16.sp
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                      shape: new RoundedRectangleBorder(
                                                        borderRadius:
                                                        new BorderRadius.circular(10.0.r),
                                                      ),
                                                      primary: Color(0xFFFFCE2B),
                                                      onPrimary: Colors.black,
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 10, vertical: 5),
                                                      textStyle: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ));

                        },
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
