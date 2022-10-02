import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_project/screens/admin/HomeScreen/piechart_card.dart';
import '../../../constants.dart';
import '../../../widget/global.dart';


class AdminHome extends StatelessWidget {
  AdminHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: myBlack,
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text("Hi, ${Global.username} 👋",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(color: Colors.white,
                    fontSize: 26.sp,fontWeight: FontWeight.bold
                ),),
              ),
              Column(
                children: [
                  PieChartSample3()
                ],
              ),
              Container(
                alignment: Alignment.center,
                width: 400.w,
                height: 200.h,
                child: Card(
                  color: Colors.black12,
                  elevation: 30,
                  child: Center(

                    child: Column(
                      children: [
                        Text('❞',style: TextStyle(fontSize: 50.sp,color:CupertinoColors.white),),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            '"Fit is not a destination. It is a way of life."',
                            //'Fitness is not about being better than someone else. It is about being better than you used to be.',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 20.sp,
                              color: Color(0xFFFFCE2B),

                            ),
                          ),
                        ),
                        SizedBox(height: 17.h,),
                        Container(
                          color:CupertinoColors.white,
                          width: 80,
                          height: 2,
                        ),],
                    ),
                  ),

                ),
              ),
              SizedBox(height: 20,)
            ],

          ),
        ),
      ),

    );

  }
}