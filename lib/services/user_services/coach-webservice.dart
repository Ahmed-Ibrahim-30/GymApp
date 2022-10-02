import 'dart:convert';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/classes.dart';
import 'package:gym_project/models/event.dart';
import 'package:gym_project/models/privatesession.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/widget/global.dart';
import 'package:http/http.dart' as http;
import '../../models/user/coach_model.dart';
import '../../models/user/member_model.dart';
import '../answers-webservice.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:http_parser/http_parser.dart';
import '../../all_data.dart';
import '../../bloc/newCreate/create_bloc.dart';
import '../../helper/dio_helper.dart';

class CoachWebService {
  static Future<void> fetchCoaches()async {
    await http.get(Uri.parse('$local/api/coaches/getAll'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Global.token}'
    }).then((value) async{
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        jsonData['Coaches'].forEach((item) async {
          Coach coach=Coach.fromJson(item);
          coach.getAllMember(item);
          coachesUsers.add(coach);
        });
      }
    }).catchError((error){
      print("fetch coachesUsers error ${error.toString()}");
    });
  }
  static void addCoach({
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
        url: 'api/coaches/store',
        data: formData
    ).then((value) {
      var jsonData =value.data;
      if(jsonData['status']==true){
        Coach coach=Coach.fromJsonAdd(jsonData['Coaches']);
        coachesUsers.add(coach);
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
      print("add Coach error ${error.toString()}");
      createCubit.finishLoading();
      myToast(message: "Created Failed",color:Colors.red);
      Navigator.pop(context);
      adminCubit.addUserError();
    });
  }

  static void updateCoach({
    @required int id,
    @required int coachIndex,
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
        url: 'api/coaches/update/$id',
        data: formData
    ).then((value) {
      var jsonData =value.data;
      if(jsonData['status']==true){
        Coach coach=Coach.fromJson(jsonData['Coaches'][0]);
        coach.index=coachesUsers[coachIndex].index;
        coachesUsers[coachIndex]=coach;
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
      print("update Coaches error ${error.toString()}");
      createCubit.finishLoading();
      myToast(message: "Updated Failed",color:Colors.red);
      Navigator.pop(context);
      adminCubit.updateUserError();
    });
  }

  //delete User
  static void deleteCoach({
    @required int id,
    @required int coachIndex,
    @required int userIndex,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
  })  {
    createCubit.loading1();
    String token = Global.token;
    http.delete(
      Uri.parse('$local/api/coaches/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    ).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      if(jsonData['status']==true){
        coachesUsers.removeAt(coachIndex);
        for(int i=0;i<coachesUsers.length;i++){
          coachesUsers[i].index=i;
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
      print("Deleted member error ${error.toString()}");
      createCubit.finishLoading();
      myToast(message: "Deleted Failed",color:Colors.red);
      Navigator.pop(context);
      adminCubit.deleteUserError();
    });
  }

  static void assignMember({
    @required Coach coach,
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
      Uri.parse('${Constants.defaultUrl}/api/coaches/assignMember/${coach.id}'),
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
        coachesUsers[coach.index].allMembers.add(member);
        membersUsers[member.index].coach=coach;
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


  Future<Tuple2<List<PrivateSession>, List<Classes>, List<Event>>>
      fetchSchedule() async {
    Tuple2<List<PrivateSession>, List<Classes>, List<Event>> res = Tuple2();
    final response = await http.get(
        Uri.parse('$local/api/coaches/schedule/self'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      String data = response.body;
      var schedule = jsonDecode(data)['schedule'];
      Iterable privateSessionsList = schedule['sessions'];
      print(privateSessionsList);
      List<PrivateSession> allPrivateSessions = privateSessionsList
          .map<PrivateSession>((e) => PrivateSession.fromJsonwithDate(e))
          .toList();
      List<PrivateSession> finalPrivateSessions =
          allPrivateSessions.cast<PrivateSession>().toList();
      res.item1 = finalPrivateSessions;
      Iterable classesList = schedule['classes'];
      List<Classes> allClasses =
          classesList.map<Classes>((e) => Classes.fromJson(e)).toList();
      List<Classes> finalClasses = allClasses.cast<Classes>().toList();
      res.item2 = finalClasses;

      Iterable eventsList = schedule['events'];
      List<Event> allEvents =
          eventsList.map<Event>((e) => Event.fromJson(e)).toList();
      List<Event> finalEvents = allEvents.cast<Event>().toList();
      res.item3 = finalEvents;

      return res;
    } else {
      throw Exception('response failed');
    }
  }
}
