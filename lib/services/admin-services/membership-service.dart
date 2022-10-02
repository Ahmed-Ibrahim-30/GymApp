import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/admin-models/membership/membership-model.dart';
import 'package:http/http.dart' as http;

import '../../widget/global.dart';
import '../answers-webservice.dart';

String  token =Global.token;

class MembershipsWebservice {

  static Future<void> fetchMemberships() async {
    await http.get(Uri.parse('$local/api/memberships/getAll'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Global.token}'
    }).then((value) {
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        jsonData['Membership'].forEach((item){
          allMemberships.add(Membership.fromJson(item,isFetch:true));
        });
      }
    }).catchError((error){
      print("fetch memberships error = ${error.toString()}");
    });

  }

  //get Membership by id
  Future<Membership> fetchMembershipById(int id) async {
    final response =
        await http.get(Uri.parse('$local/api/memberships/show/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      Membership membership = Membership.fromJson(jsonData);
      return membership;
    } else {
      throw Exception('Failed to download Membership');
    }
  }

  //add Membership
  static void postMembership(
  {
    @required String title,
    @required int branch_id,
    @required double duration,
    @required String description,
    @required double price,
    @required int limit_of_frozen_days,
    int available_classes=0,
    @required double discount,
    @required BuildContext context,
    @required AdminCubit adminCubit,
    @required CreateCubit createCubit,
  }
  ){
    createCubit.loading1();
    http.post(
      Uri.parse('$local/api/memberships/store'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Global.token}'
      },
      body: jsonEncode(<String, dynamic>{
        'title':title,
        'branch_id': branch_id,
        'duration': duration,
        'description': description,
        'price': price,
        'limit_of_frozen_days': limit_of_frozen_days,
        'available_classes': available_classes,
        'discount': discount,
      }),
    ).then((value) {
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        allMemberships.add(Membership.fromJson(jsonData['Membership']));
        createCubit.finishLoading();
        Navigator.pop(context);
        myToast(message: "Added Successfully",color: Colors.green);
        adminCubit.addMembershipsSuccess();
      }
      else{
        myToast(message: jsonData['msg'],color: Colors.red);
        createCubit.finishLoading();
      }
    }).catchError((error){
      print("Add memberShips error = ${error.toString()}");
      createCubit.finishLoading();
      myToast(message: "Added Failed",color: Colors.red);
      Navigator.pop(context);
      adminCubit.addMembershipsError();
    });
  }

  //edit Membership
  static void editMembership(
  {
    @required int id,
    @required int index,
    @required double duration,
    @required String title,
    @required String description,
    @required double price,
    @required int limit_of_frozen_days,
    int available_classes=0,
    @required double discount,
    @required BuildContext context,
    @required AdminCubit adminCubit,
    @required CreateCubit createCubit,
})  {
    createCubit.loading1();
     http.post(
      Uri.parse('$local/api/memberships/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'title':title,
        'duration': duration,
        'description': description,
        'price': price,
        'limit_of_frozen_days': limit_of_frozen_days,
        'available_classes': available_classes,
        'discount': discount,
      }),
    ).then((value){
      var jsonData = jsonDecode(value.body);
      print(jsonData);
      if(jsonData['status']==true){
        allMemberships[index]=Membership.fromJson(jsonData['Membership']);
        createCubit.finishLoading();
        Navigator.pop(context);
        adminCubit.editMembershipsSuccess();
        myToast(message: "Edit Successfully",color: Colors.green);
      }
      else{
        createCubit.finishLoading();
        myToast(message:jsonData['msg'],color: Colors.red);
      }
    }).catchError((error){
      print("Update MemberShips error = ${error.toString()}");
      createCubit.finishLoading();
      myToast(message: "Update Failed",color: Colors.red);
      Navigator.pop(context);
      adminCubit.editMembershipsError();
    });
  }

  //delete Membership
  static Future<void> deleteMembership({
    @required int id,
    @required int index,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
}) async {
    createCubit.loading2();
    await http.delete(
      Uri.parse('$local/api/memberships/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    ).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      if(jsonData['status']==true){
        allMemberships.removeAt(index);
        createCubit.finishLoading();
        Navigator.pop(context);
        adminCubit.deleteMembershipsSuccess();
        myToast(message: "Deleted Successfully",color:Colors.green);
      }
      else{
        Navigator.pop(context);
        createCubit.finishLoading();
        myToast(message: "Deleted Failed",color:Colors.red);
      }
    }).catchError((error){
      print("delete Memberships error = ${error.toString()}");
      Navigator.pop(context);
      createCubit.finishLoading();
      myToast(message: "Deleted Failed",color:Colors.red);
    });
  }
}
