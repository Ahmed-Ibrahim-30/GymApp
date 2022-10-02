import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_project/constants.dart';
import 'package:http/http.dart' as http;
import '../../all_data.dart';
import '../../bloc/Admin_cubit/admin_cubit.dart';
import '../../bloc/newCreate/create_bloc.dart';
import '../../models/admin-models/nutritionist-Sessions/nutritionistSession-model.dart';
import '../../widget/global.dart';
import '../answers-webservice.dart';

class NutritionistSessionsServices{
  static Future<void> fetchNutritionistSessions() async{
    await http.get(Uri.parse('$local/api/nutSessions/getAll'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Global.token}'
    }).then((value){
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        jsonData['sessions'].forEach((item){
          nutritionistSessions.add(NutritionistSession.fromJson(item));
        });
      }
      else{

      }
    }).catchError((error){
      print("Fetch sessions error ${error.toString()}");
    });

  }

  NutritionistSession fetchNutritionistSessionById(int id)  {
    http.get(Uri.parse('$local/api/nutSessions/show/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Global.token}'
    }).then((value) {
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        Map<String, Object> sessionJsonData = jsonData['session'];
        NutritionistSession nutritionistSession = NutritionistSession.fromJson(sessionJsonData);
        return nutritionistSession;
      }
    }).catchError((error){
      print(error.toString());
    });
    return null;
  }
  static void addNutritionistSession({
    @required int nutritionistId,
    @required int memberId,
    @required String date,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit
  }) {
    createCubit.loading1();
    http.post(
      Uri.parse('$local/api/nutSessions/store'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Global.token}'
      },
      body: jsonEncode(<String, dynamic>{
        'nutritionist_id': nutritionistId,
        'member_id': memberId,
        'date': date,
      }),
    ).then((value){
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        nutritionistSessions.add(NutritionistSession.fromJson(jsonData['Session']));
        createCubit.finishLoading();
        myToast(message: "Added Successfully",color: Colors.green);
        Navigator.pop(context);
        adminCubit.addNutritionistSessionsSuccess();
      }
      else{
        createCubit.finishLoading();
        myToast(message: jsonData['msg'],color: Colors.red);
      }
    }).catchError((error){
      print("Add nutritionistSessions Error :${error.toString()}");
      createCubit.finishLoading();
      Navigator.pop(context);
      adminCubit.addNutritionistSessionsError();
    });
  }
  //edit NutritionistSession
  static void editNutritionistSession({
    @required int id,
    @required int index,
    @required int nutritionist_id,
    @required int member_id,
    @required String date,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit
  }) {
    createCubit.loading1();
    http.put(
      Uri.parse('$local/api/nutSessions/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Global.token}'
      },
      body: jsonEncode(<String, dynamic>{
        'nutritionist_id': nutritionist_id,
        'member_id': member_id,
        'date': date,
      }),
    ).then((value){
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        nutritionistSessions[index]=NutritionistSession.fromJson(jsonData['session']);
        createCubit.finishLoading();
        myToast(message: "Updated Successfully",color: Colors.green);
        Navigator.pop(context);
        adminCubit.editNutritionistSessionsSuccess();
      }
      else{
        createCubit.finishLoading();
        myToast(message: jsonData['msg'],color: Colors.red);
      }
    }).catchError((error){
      print("edit nutritionistSessions Error :${error.toString()}");
      createCubit.finishLoading();
      Navigator.pop(context);
      myToast(message: "Updated Failed",color: Colors.green);
      adminCubit.editNutritionistSessionsError();
    });

  }
  //
  //delete NutritionistSession
  static int deleteIndex=-1;
  static void deleteNutritionistSession({
    @required int id,
    @required int index,
    @required AdminCubit adminCubit
  }) {
    deleteIndex=index;
    adminCubit.deleteNutritionistSessionsLoading();
    http.delete(
      Uri.parse('$local/api/nutSessions/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Global.token}'
      },
    ).then((value){
      var jsonData = jsonDecode(value.body);
      print(jsonData);
      if(jsonData['status']==true){
        nutritionistSessions.removeAt(index);
        adminCubit.deleteNutritionistSessionsSuccess();
        myToast(message: "Deleted Successfully",color: Colors.green);
      }
    }).catchError((error){
      print(error.toString());
      adminCubit.deleteNutritionistSessionsError();
      myToast(message: "Deleted Failed",color: Colors.red);
    });
  }
}