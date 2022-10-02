import 'package:gym_project/all_data.dart';
import 'package:gym_project/models/user/user_model.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'member_model.dart';

class Nutritionist extends User{
  int id;//coach id
  bool isChecked;
  List<Member>allMembers=[];

  Nutritionist({
    @required this.id,
    @required int user_id,
    @required int branchId,
    @required String name,
    @required String number,
    @required String gender,
    @required String email,
    @required String role,
    File photo,
    @required String bio,
    @required this.isChecked,
    @required int weight,
    @required int height,
    @required int calories,
    @required int age,
    @required int activity_level,
    @required String Protein,
    @required String Carbs,
    @required String Fats,
    @required int databaseID,
  }):super(
    name: name,
    email: email,
    number: number,
    role: role,
    bio: bio,
    height: height,
    weight: weight,
    activity_level: activity_level,
    age: age,
    branchId: branchId,
    calories: calories,
    Carbs: Carbs,
    Fats: Fats,
    gender: gender,
    photo: photo,
    Protein: Protein,
    user_id:user_id,
  );

  factory Nutritionist.fromJson(Map<String ,dynamic>json){
    return Nutritionist(
        id: json['id'],
        user_id: json['user_id'],
        isChecked: json['is_checked']??false,
        name: json['user']['name'],
        number: json['user']['number'],
        email: json['user']['email'],
        role: json['user']['role'],
        branchId: json['userinfo']['branch_id'],
        gender: json['userinfo']['gender']??'male',
        bio: json['userinfo']['bio']??" ",
        weight: json['userinfo']['weight']??0,
        height: json['userinfo']['height']??0,
        calories: json['userinfo']['calories']??0,
        age: json['userinfo']['age']??0,
        activity_level: json['userinfo']['activity_level']??0,
        Protein: json['userinfo']['Protein']??'',
        Carbs: json['userinfo']['Carbs']??'',
        Fats: json['userinfo']['Fats']??'',
        databaseID: json['userinfo']['id'],
      );
  }
  void getAllMember(Map<String ,dynamic>json){
    json['members'].forEach((item){
      int member_id=item['id'];
      membersUsers.forEach((element) {
        if(element.id==member_id){
          allMembers.add(element);
          element.nutritionist=this;
        }
      }
      );}
    );
  }

  factory Nutritionist.fromJsonAdd(Map<String ,dynamic>json){
    return Nutritionist(
        id: json['Nutritionist']['id'],
        user_id: json['Nutritionist']['user_id'],
        isChecked: json['Nutritionist']['is_checked']=="1"?true:false??false,
        name: json['nutritionistinfo']['name'],
        number: json['nutritionistinfo']['number'],
        email: json['nutritionistinfo']['email'],
        role: json['nutritionistinfo']['role'],
        branchId: json['nutritionistinfo']['user_infos']['branch_id'],
        gender: json['nutritionistinfo']['user_infos']['gender']??'male',
        bio: json['nutritionistinfo']['user_infos']['bio']??" ",
        weight: json['nutritionistinfo']['user_infos']['weight']??0,
        height: json['nutritionistinfo']['user_infos']['height']??0,
        calories: json['nutritionistinfo']['user_infos']['calories']??0,
        age: json['nutritionistinfo']['user_infos']['age']??0,
        activity_level: json['nutritionistinfo']['user_infos']['activity_level']??0,
        Protein: json['nutritionistinfo']['user_infos']['Protein']??'',
        Carbs: json['nutritionistinfo']['user_infos']['Carbs']??'',
        Fats: json['nutritionistinfo']['user_infos']['Fats']??'',
        databaseID: json['nutritionistinfo']['user_infos']['id']
    );
  }

  void update(Map<String ,dynamic>json){
    name = json['name'];
    number= json['number'];
    branchId= json['user_infos']['branch_id'];
    bio=json['user_infos']['bio']??" ";
    weight= json['user_infos']['weight']??0;
    height= json['user_infos']['height']??0;
    calories= json['user_infos']['calories']??0;
    age=json['user_infos']['age']??0;
    activity_level= json['user_infos']['activity_level']??0;
    Protein= json['user_infos']['Protein']??'';
    Carbs = json['user_infos']['Carbs']??'';
    Fats = json['user_infos']['Fats']??'';
  }


}