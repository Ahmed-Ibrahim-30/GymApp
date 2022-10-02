import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_project/models/login.dart';

import 'package:gym_project/models/set.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:gym_project/widget/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final local = Constants.defaultUrl;

class LoginAuthWebService {


  Future<Login> postLogin(String email, String password) async {
    // print('currently here');
    final response = await http.post(
      Uri.parse('$local/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    print("response = ${response.body}");

    if (response.statusCode == 200) {
      loadingStatus=LoadingStatus.Completed;
      Fluttertoast.showToast(
          msg: "Login Successfully",
          fontSize: 16,
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green,
          textColor: Colors.white
      );
      print(response.body);
      // print(jsonDecode(response.body)['data']['token'].toString());
      return Login.fromJson(jsonDecode(response.body)['data'],email);
    } else {
      loadingStatus=LoadingStatus.Empty;
      Fluttertoast.showToast(
          msg: jsonDecode(response.body)['msg'],
          fontSize: 16,
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.red,
      );
    }
  }

  Future<bool> postLogout() async {
    // print('currently here');
    String token = Global.token;
    final response = await http.post(
      Uri.parse('${Constants.defaultUrl}/api/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': "Bearer $token",
      },
    ).then((value) {}).catchError((error){
    });


    if (response.statusCode == 200) {
      return true;
    } else {
      // print(response.statusCode);
      throw Exception('Failed to login.');
    }
  }
}
