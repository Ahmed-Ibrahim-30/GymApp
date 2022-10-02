import 'dart:convert';
import 'package:gym_project/constants.dart';
import 'package:gym_project/widget/global.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../all_data.dart';
import '../../bloc/newCreate/create_bloc.dart';
import '../../helper/dio_helper.dart';
import '../../models/user/member_model.dart';
import '../../models/user/nutritionist_model.dart';
import '../answers-webservice.dart';

class NutritionistWebservice {
  static Future<void> fetchNutritionists()async{
    await http.get(Uri.parse('$local/api/nutritionists/getAll'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Global.token}'
    }).then((value) {
      var jsonData = jsonDecode(value.body);
      //print(jsonData);
      if(jsonData['status']==true){
        int count=0;
        jsonData['Nutritionist'].forEach((item){
          Nutritionist nutritionists=Nutritionist.fromJson(item);
          nutritionists.getAllMember(item);
          nutritionists.index=count++;
          nutritionistsUsers.add(nutritionists);
        });
      }
      print("Nutritionists size = ${nutritionistsUsers.length}");
    }).catchError((error){
      print("fetch nutritionistsUsers error ${error.toString()}");
    });
  }
  static void addNutritionist({
    @required String name,
    @required String email,
    @required String password,
    @required String gender,
    @required int branchId,
    @required String role,
    @required String number,
    @required File photo,
    @required String bio,
    @required int age,
    int is_checked=0,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
  })async{
    createCubit.loading1();
    String fileName = photo.path.split('/').last;
    FormData formData = FormData.fromMap({
      "name" : name,
      "email" : email,
      "password" : password,
      "role" : role,
      "gender" : gender,
      "branch_id" : branchId,
      "number" : number,
      "bio" : bio,
      "age" : age,
      "photo": await MultipartFile.fromFile(
        photo.path,
        filename: fileName,
        contentType: new MediaType("image", "jpeg"), //important
      ),
      "is_checked" :is_checked,
    });
    DioHelper.postData(
        url: 'api/nutritionists/store',
        data: formData
    ).then((value) {
      var jsonData =value.data;
      if(jsonData['status']==true){
        Nutritionist nutritionists=Nutritionist.fromJsonAdd(jsonData['Nutritionist']);
        nutritionists.index=nutritionistsUsers.length;
        nutritionistsUsers.add(nutritionists);
        adminCubit.addUserSuccess();
        Navigator.pop(context);
        createCubit.finishLoading();
        myToast(message: "Created Successfully",color:Colors.green);
      }
      else{
        myToast(message: jsonData['msg'],color:Colors.red);
        createCubit.finishLoading();
      }
    }).catchError((error){
      print("add Nutritionist error ${error.toString()}");
      createCubit.finishLoading();
      myToast(message: "Created Failed",color:Colors.red);
      Navigator.pop(context);
      adminCubit.addUserError();
    });
  }

  static void updateNutritionist({
    @required int id,
    @required int nutritionistsIndex,
    @required String name,
    @required String number,
    @required File photo,
    @required String bio,
    @required int age,
    int weight=0,
    int height=0,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
  })async{
    createCubit.loading2();
    String fileName = photo.path.split('/').last;
    FormData formData = FormData.fromMap({
      "name" : name,
      "number" : number,
      "bio" : bio,
      "age" : age,
      "weight" : weight,
      "height" : height,
      "photo": await MultipartFile.fromFile(
        photo.path,
        filename: fileName,
        contentType: new MediaType("image", "jpeg"), //important
      ),

    });
    DioHelper.postData(
        url: 'api/nutritionists/update/$id',
        data: formData
    ).then((value) {
      var jsonData =value.data;
      if(jsonData['status']==true){
        nutritionistsUsers[nutritionistsIndex].update(jsonData['Nutritionist'][0]);
        adminCubit.updateUserSuccess();
        Navigator.pop(context);
        createCubit.finishLoading();
        myToast(message: "Updated Successfully",color:Colors.green);
      }
      else{
        myToast(message: jsonData['msg'],color:Colors.red);
        createCubit.finishLoading();
      }
    }).catchError((error){
      print("update Nutritionists error ${error.toString()}");
      createCubit.finishLoading();
      myToast(message: "Updated Failed",color:Colors.red);
      Navigator.pop(context);
      adminCubit.updateUserError();
    });
  }


  //delete User
  static void deleteNutritionist({
    @required int id,
    @required int nutritionistsIndex,
    @required int userIndex,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
  })  {
    createCubit.loading1();
    String token = Global.token;
    http.delete(
      Uri.parse('$local/api/nutritionists/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    ).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      if(jsonData['status']==true){
        nutritionistsUsers.removeAt(nutritionistsIndex);
        for(int i=0;i<nutritionistsUsers.length;i++){
          nutritionistsUsers[i].index=i;
        }
        adminCubit.deleteUserSuccess();
        Navigator.pop(context);
        createCubit.finishLoading();
        myToast(message: "Deleted Successfully",color:Colors.green);
      }
      else{
        myToast(message: jsonData['msg'],color:Colors.red);
        createCubit.finishLoading();
      }
    }).catchError((error){
      print("Deleted nutritionists error ${error.toString()}");
      createCubit.finishLoading();
      myToast(message: "Deleted Failed",color:Colors.red);
      Navigator.pop(context);
      adminCubit.deleteUserError();
    });
  }


  static void assignMember({
    @required Nutritionist nutritionist,
    @required Member member,
    @required String startDate,
    @required String endDate,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
  }){
    String token =Global.token;
    createCubit.loading1();
    http.post(
        Uri.parse('${Constants.defaultUrl}/api/nutritionists/assignMember/${nutritionist.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'member_id': member.id,
          'start_date': startDate,
          'end_date': endDate,
        })
    ).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      if(jsonData['status']==true){
        nutritionistsUsers[nutritionist.index].allMembers.add(member);
        membersUsers[member.index].nutritionist=nutritionist;
        myToast(message: "Assigned Successfully",color:Colors.green);
        createCubit.finishLoading();
        adminCubit.assignMemberSuccess();
        Navigator.pop(context);
      }
      else{
        createCubit.finishLoading();
        myToast(message: jsonData['msg'],color:Colors.red);
      }
    }).catchError((error){
      createCubit.finishLoading();
      myToast(message: "Assigned Failed",color:Colors.red);
      print(error.toString());
      Navigator.pop(context);
      adminCubit.assignMemberError();
    });
  }

  //get Nutritionist  by id
  Future<Nutritionist> fetchNutritionistById(int id) async {
    final response = await http
        .get(Uri.parse('$local/api/nutritionists/show/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Global.token}'
    });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      Nutritionist nutritionist = Nutritionist.fromJson(jsonData);
      return nutritionist;
    } else {
      throw Exception('Failed to download nutritionist');
    }
  }

}
