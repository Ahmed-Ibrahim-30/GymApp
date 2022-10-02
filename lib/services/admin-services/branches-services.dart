import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/admin-models/branches/branch-model.dart';
import 'package:gym_project/models/admin-models/branches/branches-list-model.dart';
import 'package:gym_project/models/admin-models/equipments/equipment-model.dart';
import 'package:gym_project/screens/admin/equipment/show_branch_equipments.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../all_data.dart';
import '../../bloc/Admin_cubit/admin_cubit.dart';
import '../../bloc/newCreate/create_bloc.dart';
import '../../helper/dio_helper.dart';
import '../../widget/global.dart';
import '../answers-webservice.dart';

class BranchService {
  static Future<void> fetchBranches() async{
    await http.get(Uri.parse('$local/api/branches/getAll'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }).then((value) {
      var data = jsonDecode(value.body);
      Branches branches = Branches.fromJson(data);
      branches.branches.forEach((element) {
        Branch branch=Branch.fromJson(element,isFetch: true);
        branchesList.add(branch);
      });
    }).catchError((error){
      print('fetch branch error = ${error.toString()}');
    });
  }

  static void deleteBranch({
    @required int id,
    @required int index,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
})  {
    createCubit.loading1();
    String token = Global.token;
    http.delete(
      Uri.parse('$local/api/branches/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    ).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      if(jsonData['status']==true){
        branchesList.removeAt(index);
        for(int i=0;i<branchesList.length;i++){
          branchesList[i].index=i;
        }
        createCubit.finishLoading();
        adminCubit.updateState();
        Navigator.pop(context);
        myToast(message: "Deleted Successfully",color:Colors.green);
      }
      else{
        myToast(message: jsonData['msg'],color:Colors.red);
        createCubit.finishLoading();
      }
    }).catchError((error){
      print(error.toString());
      myToast(message: "Deleted Failed",color:Colors.red);
      adminCubit.updateState();
    });
  }
  static Future<void> addBranch(
      {
        @required String title,
        @required String location,
        @required String number,
        @required int crowdMeter,
        @required File photo,
        @required String info,
        @required int membersNumber,
        @required int coachesNumber,
        @required BuildContext context,
        @required CreateCubit createCubit,
        @required AdminCubit adminCubit,
      })  async{
    createCubit.loading1();
    String fileName = photo.path.split('/').last;
    FormData formData = FormData.fromMap({
      "title": title,
      "location": location,
      "phone_number": number,
      "crowd_meter": crowdMeter,
      "info": info,
      "members_number": membersNumber,
      "coaches_number": coachesNumber,
      "picture": await MultipartFile.fromFile(
        photo.path,
        filename: fileName,
        contentType: new MediaType("image", "jpeg"), //important
      ),
    });
    DioHelper.postData(
        url: 'api/branches/store',
        data: formData
    ).then((value) {
      var jsonData =value.data;
      if(jsonData['status']==true){
        print(jsonData);
        Branch newBranch=Branch.fromJson(jsonData['Branch']);
        branchesList.add(newBranch);
        adminCubit.updateState();
        createCubit.finishLoading();
        Navigator.pop(context);
        myToast(message: "Created Successfully",color:Colors.green);
      }
      else{
        myToast(message: jsonData['msg'],color:Colors.red);
        createCubit.finishLoading();
      }
    }).catchError((error){
      print("body2 = ${error.toString()}");
      print(error.toString());
      createCubit.finishLoading();
      myToast(message: "Created Failed",color:Colors.red);
      adminCubit.updateState();
      Navigator.pop(context);
    });
  }


  static void updateBranch({
    @required int id,
    @required int index,
    @required String title,
    @required String location,
    @required String number,
    @required int crowdMeter,
    //@required File picture,
    @required String info,
    @required int membersNumber,
    @required int coachesNumber,
    @required BuildContext context,
    @required BuildContext detailsContext,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
  })  {
    String token = Global.token;
    createCubit.loading1();
    http.put(
        Uri.parse('$local/api/branches/update/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json',

          'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          'Accept': '*/*',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "title": title,
          "location": location,
          "phone_number": number,
          "crowd_meter": crowdMeter,
          //"picture": picture,
          "info": info,
          "members_number": membersNumber,
          "coaches_number": coachesNumber,
        })).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      print(jsonData);
      if(jsonData['status']==true){
        Branch newBranch=Branch.fromJson(jsonData['Branch']);
        newBranch.index=branchesList[index].index;
        branchesList[index]=newBranch;
        adminCubit.updateState();
        createCubit.finishLoading();
        Navigator.pop(context);
        Navigator.pop(detailsContext);
        myToast(message: "Updated Successfully",color:Colors.green);
      }
      else{
        myToast(message: jsonData['msg'],color:Colors.red);
        createCubit.finishLoading();
      }
    }).catchError((error){
      print("body = ${error.toString()}");
      createCubit.finishLoading();
      Navigator.pop(context);
      Navigator.pop(detailsContext);
      myToast(message: "Updated Failed",color:Colors.red);
      adminCubit.updateState();
    });

  }


  static Future<void> assignEquipment({
    @required Branch branch,
    @required int equipment_id,
    @required AdminCubit adminCubit,
  }) async{
    String token = Global.token;
    await http.put(
      Uri.parse(
          '$local/api/branches/assignEquipment/${branch.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      },
        body: jsonEncode({
          "equipment_id": equipment_id,
        })).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      if(jsonData['status']==true){
        branchesList[branch.index].allEquipment.add(Equipment.fromJson(jsonData['assignEquipment']['equipment']));
        adminCubit.updateState();
      }
    }).catchError((error){
      print("assign Equipment error = ${error.toString()}");
    });
  }

  static Future<void> assignManyEquipment ({
    @required Branch branch,
    @required List<branchEquipment> equipments,
    @required BuildContext context,
    @required CreateCubit createCubit,
    @required AdminCubit adminCubit,
})async{
    createCubit.loading1();
    await equipments.forEach((element) {
      if(element.isSelected){
         assignEquipment(branch: branch, equipment_id: element.id,adminCubit: adminCubit);
      }
    });
    await createCubit.finishLoading();
    await Navigator.pop(context);
  }

}
