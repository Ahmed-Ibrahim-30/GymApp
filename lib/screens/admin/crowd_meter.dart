import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CrowdMeter extends StatelessWidget {
  const CrowdMeter({
    Key key,
    @required this.checkedInMembers,
    @required this.totalMembers,
  }) : super(key: key);

  final int checkedInMembers;
  final int totalMembers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20.h),
        Text(
          'CROWD METER',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Changa',
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 20.h,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(100.r),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: checkedInMembers / totalMembers,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          'Current Members: $checkedInMembers',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}