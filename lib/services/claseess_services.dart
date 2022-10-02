import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_project/constants.dart';
import 'package:http/http.dart' as http;
import '../../all_data.dart';
import '../../bloc/Admin_cubit/admin_cubit.dart';
import '../../bloc/newCreate/create_bloc.dart';
import '../../widget/global.dart';
import '../bloc/coach_cubit/coach_cubit.dart';
import '../models/classes.dart';
import '../models/user/coach_model.dart';
import '../models/user/member_model.dart';
import 'answers-webservice.dart';


class ClassesServices{
  static Future<void> fetchClasses()  async{
    await http.get(Uri.parse('$local/api/classes/getAll'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      jsonData['classes'].forEach((item){
        Classes myClass=Classes.fromJson(item,isFetchAll: true);
        allClasses.add(myClass);
      });

    }).catchError((error){
      print(error.toString());
    });
  }
  static void addClass({
    @required String description,
    @required String title,
    @required String link,
    @required String level,
    @required num capacity,
    @required String price,
    @required String duration,
    @required String date,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
    @required CoachCubit coachCubit,
  }){
    createCubit.loading1();
    http.post(Uri.parse('$local/api/classes/store'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          'Accept': '*/*',
          'Authorization': 'Bearer ${Global.token}',
        },
        body: jsonEncode({
          "description": description,
          "title": title,
          "link": link,
          "level": level,
          "capacity": capacity,
          "price": price,
          "duration": duration,
          "date": date,
        })).then((value){
      var data=jsonDecode(value.body);
      print(data);
      if(data['status']==true){
        Classes myClass=Classes.fromJsonAdd(data['class']);
        allClasses.add(myClass);
        myToast(message: "Created Successfully",color: Colors.green);
        createCubit.finishLoading();
        Navigator.pop(context);
        if(Global.role=='coach') coachCubit.update();
        else adminCubit.addClassesSuccess();
      }
      else{
        myToast(message: data['msg'],color: Colors.red);
        createCubit.finishLoading();
      }
    }).catchError((error){
      print("Create Class Error = ${error.toString()}");
      myToast(message: "Created Failed",color: Colors.red);
      createCubit.finishLoading();
      Navigator.pop(context);
      if(Global.role=='coach')coachCubit.update();
      else adminCubit.addClassesError();
    });
  }

  static void updateClass({
    @required int id,
    @required String description,
    @required String title,
    @required String link,
    @required String level,
    @required int capacity,
    @required String price,
    @required String duration,
    @required String date,
    @required int index,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
  })  {
    createCubit.loading1();
    http.put(
        Uri.parse('$local/api/classes/update/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          'Accept': '*/*',
          'Authorization': 'Bearer ${Global.token}',
        },
        body: jsonEncode({
          "description": description,
          "title": title,
          "link": link,
          "level": level,
          "capacity": capacity,
          "price": price,
          "duration": duration,
          "date": date,
        })).then((value) {
      var data=jsonDecode(value.body);
      print(data);
      if(data['status']==true){
        Classes myClass=Classes.fromJson(data['class']);
        myClass.index=allClasses[index].index;
        allClasses[index]=myClass;
        myToast(message: "Updated Successfully",color: Colors.green);
        createCubit.finishLoading();
        Navigator.pop(context);
        adminCubit.editClassesSuccess();
      }
      else{
        myToast(message: data['msg'],color: Colors.red);
        createCubit.finishLoading();
      }
    }).catchError((error){
      print("update Class Error = ${error.toString()}");
      myToast(message: "Updated Failed",color: Colors.red);
      createCubit.finishLoading();
      Navigator.pop(context);
      adminCubit.editClassesError();
    });
  }

  static void deleteClass({
    @required int id,
    @required int index,
    @required BuildContext context,
    @required AdminCubit adminCubit,
  }){
    adminCubit.deleteClassesLoading();
    http.delete(
      Uri.parse('$local/api/classes/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',

        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer ${Global.token}',
      },
    ).then((value){
      var data=jsonDecode(value.body);
      print(data);
      if(data['status']==true){
        allClasses.removeAt(index);
        for(int i=0;i<allClasses.length;i++){allClasses[i].index=i;}
        myToast(message: "Deleted Successfully",color: Colors.green);
        Navigator.pop(context);
        adminCubit.deleteClassesSuccess();
      }
      else{
        myToast(message: data['msg'],color: Colors.red);
      }
    }).catchError((error){
      print("delete Class Error = ${error.toString()}");
      myToast(message: "Deleted Failed",color: Colors.red);
      Navigator.pop(context);
      adminCubit.deleteClassesError();
    });

  }

  static void attachMembersToClass({
    @required Member member,
    @required Classes classes,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
  }) {
    createCubit.loading1();
    http.post(Uri.parse('$local/api/classes/assignMember/${classes.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          'Accept': '*/*',
          'Authorization': 'Bearer ${Global.token}',
        },
        body: jsonEncode({
          "member_id": member.id,
        })
    ).then((value){
      var data=jsonDecode(value.body);
      if(data['status']==true){
        allClasses[classes.index].allMembers.add(membersUsers[member.index]);
        Navigator.pop(context);
        createCubit.finishLoading();
        adminCubit.updateState();
        myToast(message: "Assigned Success",color: Colors.green);
      }
      else{
        createCubit.finishLoading();
        myToast(message: data['msg'],color: Colors.red);
      }

    }).catchError((error){
      print("attach member to class error ${error.toString()}");
      Navigator.pop(context);
      createCubit.finishLoading();
      adminCubit.updateState();
      myToast(message: "Assigned Failed",color: Colors.red);
    });
  }


  static void attachCoachToClass({
    @required Coach coach,
    @required Classes classes,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
  }) {
    createCubit.loading1();
    http.post(Uri.parse('$local/api/classes/assignCoach/${classes.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          'Accept': '*/*',
          'Authorization': 'Bearer ${Global.token}',
        },
        body: jsonEncode({
          "coach_id": coach.id,
        })
    ).then((value){
      var data=jsonDecode(value.body);
      if(data['status']==true){
        allClasses[classes.index].allCoaches.add(coachesUsers[coach.index]);
        Navigator.pop(context);
        createCubit.finishLoading();
        adminCubit.updateState();
        myToast(message: "Assigned Success",color: Colors.green);
      }
      else{
        createCubit.finishLoading();
        myToast(message: data['msg'],color: Colors.red);
      }

    }).catchError((error){
      print("attach Coach to class error ${error.toString()}");
      Navigator.pop(context);
      createCubit.finishLoading();
      adminCubit.updateState();
      myToast(message: "Assigned Failed",color: Colors.red);
    });
  }

  static Future<List<Classes>> fetchCoachClasses({@required int id}) async {
    await http.get(
        Uri.parse('${Constants.defaultUrl}/api/coaches/classes/${id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Global.token}'
        }).then((value){
      String data = value.body;
      Iterable jsonData = jsonDecode(data)['coaches'];
      List<Classes> allClasses =
      jsonData.map<Classes>((e) => Classes.fromJson(e)).toList();
      List<Classes> finalClasses = allClasses.cast<Classes>().toList();
      print("Classes Fetched");
      return finalClasses;
    }).catchError((error){
      print("fetchCoachClasses error : ${error.toString()}");
    });
    return [];
  }
}