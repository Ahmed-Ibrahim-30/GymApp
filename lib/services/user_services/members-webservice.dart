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

final String local = Constants.defaultUrl;
class MembersWebService {
  static Future<void>fetchMembers()async{
    await http.get(Uri.parse('$local/api/members/getAll'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Global.token}'
    }).then((value) {
      var jsonData = jsonDecode(value.body);

      if(jsonData['status']==true){
        jsonData['Members'].forEach((item){
          Member member=Member.fromJson(item);
          membersUsers.add(member);
        });
      }
      print("members size = ${membersUsers.length}");
    }).catchError((error){
      print("fetch membersUsers error ${error.toString()}");
    });
  }
  static void addMember({
    @required String name,
    @required String number,
    @required String gender,
    @required String email,
    @required String password,
    @required String role,
    @required File photo,
    @required String bio,
    @required int branchId,
    @required int membership_id,
    @required int age,
    int is_checked=0,
    String medical_physical_history='00',
    String medical_allergic_history='00',
    int available_frozen_days=20,
    int available_membership_days=20,
    int active_days=1,
    int current_plan=3,
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
      "medical_physical_history" : medical_physical_history,
      "medical_allergic_history" :medical_allergic_history,
      "available_frozen_days": available_frozen_days,
      "available_membership_days": available_membership_days,
      "active_days" : active_days,
      "membership_id" : membership_id,
      "current_plan" : current_plan,
    });
    DioHelper.postData(
        url: 'api/members/store',
        data: formData
    ).then((value) {
      var jsonData =value.data;
      if(jsonData['status']==true){
        Member member =Member.fromJsonAdd(jsonData['member']);
        membersUsers.add(member);
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
      print("add member error ${error.toString()}");
      createCubit.finishLoading();
      myToast(message: "Created Failed",color:Colors.red);
      Navigator.pop(context);
      adminCubit.addUserError();
    });
  }

  static void updateMember({
    @required int id,
    @required int memberIndex,
    @required String name,
    @required String number,
    //@required File photo,
    @required String bio,
    @required int age,
    int weight=0,
    int height=0,
    @required String medical_physical_history,
    @required String medical_allergic_history,
    @required int available_frozen_days,
    @required int available_membership_days,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
  })async{
    createCubit.loading2();
    //String fileName = photo.path.split('/').last;
    FormData formData = FormData.fromMap({
      "name" : name,
      "number" : number,
      "bio" : bio,
      "age" : age,
      "weight" : weight,
      "height" : height,
      // "photo": await MultipartFile.fromFile(
      //   photo.path,
      //   filename: fileName,
      //   contentType: new MediaType("image", "jpeg"), //important
      // ),
      "medical_physical_history" : medical_physical_history,
      "medical_allergic_history" :medical_allergic_history,
      "available_frozen_days": available_frozen_days,
      "available_membership_days": available_membership_days,
    });
    DioHelper.postData(
        url: 'api/members/update/$id',
        data: formData
    ).then((value) {
      var jsonData =value.data;
      if(jsonData['status']==true){
        Member member=Member.fromJson(jsonData['user'][0]);
        member.index=membersUsers[memberIndex].index;
        membersUsers[memberIndex]=member;
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
      print("update member error ${error.toString()}");
      createCubit.finishLoading();
      myToast(message: "Updated Failed",color:Colors.red);
      Navigator.pop(context);
      adminCubit.updateUserError();
    });
  }


  //delete User
  static void deleteMember({
    @required int id,
    @required int memberIndex,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
})  {
    createCubit.loading1();
    String token = Global.token;
    http.delete(
      Uri.parse('$local/api/members/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    ).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      if(jsonData['status']==true){
        membersUsers.removeAt(memberIndex);
        for(int i=0;i<membersUsers.length;i++){
          membersUsers[i].index=i;
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


  Future<List<Member>> fetchCoachMembers() async {
    String token = Global.token;
    print("Fetching members..");
    final response = await http.get(
        Uri.parse('$local/api/coaches/members/self'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      String data = response.body;
      Iterable jsonData = jsonDecode(data)['members'];
      List<Member> allMembers ;//= jsonData.map<Member>((e) => Member.myMembersfromJson(e)).toList();
      List<Member> finalMembers = allMembers.cast<Member>().toList();
      print("Members Fetched");
      return finalMembers;
    } else {
      throw Exception('response failed');
    }
  }

  Future<List<Member>> fetchNutritionistMembers() async {
    String token = Global.token;
    print("Fetching members..");
    final response = await http.get(
        Uri.parse('$local/api/nutritionists/members/self'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      String data = response.body;
      Iterable jsonData = jsonDecode(data)['members'];
      List<Member> allMembers ;//= jsonData.map<Member>((e) => Member.myMembersfromJson(e)).toList();
      List<Member> finalMembers = allMembers.cast<Member>().toList();
      print("Members Fetched");
      return finalMembers;
    } else {
      throw Exception('response failed');
    }
  }

  Future<Member> fetchUserById(int id) async {
    String token = Global.token;
    final response = await http
        .get(Uri.parse('$local/api/members/show/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      Member member ;//= Member.fromJson(jsonData);
      return member;
    } else {
      throw Exception('Failed to download Member');
    }
  }



}
