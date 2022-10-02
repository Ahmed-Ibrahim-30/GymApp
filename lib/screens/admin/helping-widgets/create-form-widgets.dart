import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants.dart';

Widget field(
    String title,
    String placeHolder,
    TextEditingController textController,
    {TextInputType keyboardType=TextInputType.text,
      bool passwordVisibility=false,
      changePasswordVisibility,
      String textError="You must fill this field !!",
      bool enable=true,
      int maxLines=3,
      int minLines=1,
      onTabFunction,
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      new Text(
        title,
        style: TextStyle(
          fontSize: 16.0.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 2.h,),
      new TextFormField(
        onTap: onTabFunction,
        minLines: minLines,
        maxLines: maxLines,
        enabled: enable,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        obscureText: title.contains('Password')?!passwordVisibility:false,
        controller: textController,
        keyboardType: keyboardType,
        validator: (value){
          if(value!=null && value.isEmpty){
            return textError;
          }
          else{
            return null;
          }
        },
        decoration: InputDecoration(
          suffixIcon: title.contains('Password')?IconButton(
            icon: Icon(passwordVisibility?Icons.visibility:Icons.visibility_off,color: Colors.black),
            onPressed: changePasswordVisibility,
          ):null,
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFFFCE2B),
              width: 2.0,
            ),
          ),
          hintText: placeHolder,
          hoverColor: Colors.amber,
          hintStyle: TextStyle(color: Colors.grey,fontSize: 14.sp)
        ),
      ),
      SizedBox(height: 20.h,),
    ],
  );
}
