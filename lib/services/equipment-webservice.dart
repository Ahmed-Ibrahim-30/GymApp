import 'dart:convert';
import 'package:gym_project/constants.dart';
import 'package:http/http.dart' as http;
import '../models/admin-models/equipments/equipment-model.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/models/admin-models/equipments/equipment-model.dart';
import '../../all_data.dart';
import '../../bloc/Admin_cubit/admin_cubit.dart';
import '../../bloc/newCreate/create_bloc.dart';
import '../../widget/global.dart';
import 'answers-webservice.dart';

class EquipmentsService {

  static Future<void> fetchEquipments() async {
    int count=1,last_page=2;
    while(count<=last_page){
      String url=Uri.encodeFull('$local/api/equipments/getAll?page=${count++}');
      await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Global.token}'
      }).then((value) {
        var data = jsonDecode(value.body);
        last_page=data['equipment']['last_page'];
        if(data['status']==true){
          data['equipment']['data'].forEach((item){
            allEquipment.add(Equipment.fromJson(item));
          });
        }
      }).catchError((error){
        print("FetchEquipments Error = ${error.toString()}");
      });
    }
  }
  static void addEquipments({
    @required String name,
    @required String description,
    @required String picture,
    @required BuildContext context,
    @required AdminCubit adminCubit,
  }){
    adminCubit.addEquipmentsLoading();
    http.post(
        Uri.parse("$local/api/equipments/store"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Global.token}'
        },
        body: jsonEncode(<String,String>{
          'name':name,
          'description':description,
          'picture':picture,
        })
    ).then((value) {
      var data=jsonDecode(value.body);
      if(data['status']==true){
        allEquipment.add(Equipment.fromJson(data['equipment']));
        myToast(message: "Created Successfully",color: Colors.green);
        Navigator.pop(context);
        adminCubit.addEquipmentsSuccess();
      }
      else{
        myToast(message: data['msg'],color: Colors.red);
      }

    }).catchError((error){
      print(error.toString());
      Navigator.pop(context);
      myToast(message: 'Created Failed',color: Colors.red);
      adminCubit.addEquipmentsError();
    });
  }

  static void updateEquipments({
    @required int id,
    @required String name,
    @required String description,
    @required String picture,
    @required CreateCubit createCubit,
    @required BuildContext context,
    @required AdminCubit adminCubit,
  }){
    createCubit.loading2();
    http.put(
        Uri.parse("$local/api/equipments/update/$id"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Global.token}'
        },
        body: jsonEncode(<String,String>{
          'name':name,
          'description':description,
          'picture':picture,
        })
    ).then((value) {
      var data=jsonDecode(value.body);
      print(data);
      if(data['status']==true){
        for(int i=0;i<allEquipment.length;i++){
          if(allEquipment[i].id==id){
            allEquipment[i]=Equipment.fromJson(data['equipment']);
            break;
          }
        }
        createCubit.finishLoading();
        Navigator.pop(context);
        myToast(message: "Updated Successfully",color: Colors.green);
        adminCubit.editEquipmentsSuccess();
      }
      else{
        createCubit.finishLoading();
        myToast(message: data['msg'],color: Colors.red);
      }
    }).catchError((error){
      createCubit.finishLoading();
      Navigator.pop(context);
      print(error.toString());
      myToast(message: 'Updated Failed',color: Colors.red);
      adminCubit.editAnnouncementsError();
    });
  }

  static void deleteEquipments({
    @required int id,
    @required CreateCubit createCubit,
    @required BuildContext context,
    @required AdminCubit adminCubit,
  }){
    createCubit.loading1();
    http.delete(
      Uri.parse("$local/api/equipments/delete/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Global.token}'
      },

    ).then((value) {
      var data=jsonDecode(value.body);
      print(data);
      if(data['status']==true){
        for(int i=0;i<allEquipment.length;i++){
          if(allEquipment[i].id==id){
            allEquipment.removeAt(i);
            break;
          }
        }
        createCubit.finishLoading();
        Navigator.pop(context);
        myToast(message: "Deleted Successfully",color: Colors.green);
        adminCubit.deleteEquipmentsSuccess();
      }
      else{
        createCubit.finishLoading();
        myToast(message: data['msg'],color: Colors.red);
      }
    }).catchError((error){
      createCubit.finishLoading();
      Navigator.pop(context);
      print(error.toString());
      myToast(message: 'Deleted Failed',color: Colors.red);
      adminCubit.deleteEquipmentsError();
    });
  }
}
