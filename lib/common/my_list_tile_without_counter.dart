import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/constants.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}

class CustomListTileWithoutCounter extends StatelessWidget {
  final String path;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String subtitle3;
  final bool isUser;
  final bool isOnFunction;
  CustomListTileWithoutCounter(this.path, this.title, this.subtitle1, this.subtitle2, this.subtitle3,{this.isUser=false,this.isOnFunction=false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 7.h),
      decoration: BoxDecoration(
        color: HexColor("05595B"),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ListTile(
        minVerticalPadding: 9.h,
        leading: Container(
          width: 50.w,
          height: 50.h,
          decoration: const BoxDecoration(
              shape:BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                  spreadRadius: 2,
                )
              ]
          ),
          child: CircleAvatar(
            radius: 25.r,//Image.file(File(widget.path))
              backgroundColor: Colors.transparent,
            child: ClipRRect(
                borderRadius:BorderRadius.circular(25.r),
              child: path.contains('com.example.gymproject')?Image.file(File(path),width: 50.w,height: 50.h,fit: BoxFit.fill,):
              path.contains('assets')?Image.asset(path):
              Image.asset('assets/images/branch.png'),
            )
          ),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white,fontSize: 16.sp,fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if(isUser)Icon(Icons.phone,color: myYellow,size: 13.sp,),
                  if(isUser)SizedBox(width: 10.w,),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        if(isUser && isOnFunction)launchUrl(Uri.parse("tel://${subtitle1}"));
                      },
                      child: Text(
                        subtitle1,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white60,fontSize: 13.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h,),
              Row(
                children: [
                  if(isUser)Icon(Icons.workspace_premium,color: myYellow,size: 13.sp,),
                  if(isUser)SizedBox(width: 10.w,),
                  Expanded(
                    child: Text(
                      subtitle2,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white60,fontSize: 13.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h,),
              Row(
                children: [
                  if(isUser)Icon(Icons.email,color: myYellow,size: 13.sp,),
                  if(isUser)SizedBox(width: 10.w,),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        if(isUser && isOnFunction)_launchUrl(Uri.parse('mailto:${subtitle3}?'));
                      },
                      child: Text(
                        subtitle3,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(color: Colors.white60,fontSize: 13.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
