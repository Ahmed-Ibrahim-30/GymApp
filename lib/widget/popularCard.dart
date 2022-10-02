import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/constants.dart';

class PopularCard extends StatelessWidget {
  final String asset;
  final String title;
  const PopularCard({Key key, this.asset, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 15.0.w, bottom: 10.0.h),
          child: Container(
            height: 152.h,
            width: 122.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                image: DecorationImage(
                  image: AssetImage('assets/images/$asset'),
                    fit: BoxFit.cover
                )
              ),
          ),
        ),
        //SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: myYellow2,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}
