import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/user/member_model.dart';
import 'package:gym_project/widget/global.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../all_data.dart';
import '../../bloc/newCreate/create_bloc.dart';
import '../../helper/dio_helper.dart';
import 'answers-webservice.dart';


void fetchImage(){
  http.get(Uri.parse("$local/api/fetch"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Global.token}'
  },
  );
}