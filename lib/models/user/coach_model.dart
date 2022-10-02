import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/user/user_model.dart';
import '../../all_data.dart';
import 'member_model.dart';

class Coach extends User{
  int id;//coach id
  bool isChecked;
  String avg_rate;
  List<Member>allMembers=[];

  Coach({
    @required this.id,
    @required int user_id,
    @required int index,
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
    @required this.avg_rate,
  }):super(
    name: name,
    index: index,
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

  factory Coach.fromJson(Map<String ,dynamic>json){
    return Coach(//noimage
        id: handleApi(json['id']),
        index: coachesUsers.length,
        user_id: handleApi(json['user_id']),
        avg_rate: "${json['avg_rate']}",
        isChecked: json['is_checked']??false,
        name: "${json['user']['name']}",
        number: "${json['user']['number']}",
        email: "${json['user']['email']}",
        role: "${json['user']['role']}",
        branchId: handleApi(json['userinfo']['branch_id']),
        gender: "${json['userinfo']['gender']}"??'male',
        bio: "${json['userinfo']['bio']}"??" ",
        weight: handleApi(json['userinfo']['weight']) ??0,
        height: handleApi(json['userinfo']['height']) ??0,
        calories: handleApi(json['userinfo']['calories']) ??0,
        age: handleApi(json['userinfo']['age']) ??0,
        activity_level: handleApi(json['userinfo']['activity_level']) ??0,
        Protein: "${json['userinfo']['Protein']}"??'',
        Carbs: "${json['userinfo']['Carbs']}"??'',
        Fats: "${json['userinfo']['Fats']}"??'',
        databaseID: handleApi(json['userinfo']['id']),
      //photo: File(""),
    );
  }

  void getAllMember(Map<String ,dynamic>json){
    json['memberss'].forEach((item){
      int member_id=item['id'];
      membersUsers.forEach((element) {
        if(element.id==member_id){
          allMembers.add(element);
          element.coach=this;
        }
      }
      );}
    );
  }
  factory Coach.fromJsonAdd(Map<String ,dynamic>json){
    return Coach(
        id: handleApi(json['coach']['id']),
        index: coachesUsers.length,
        user_id: handleApi(json['coach']['user_id']),
        isChecked: json['coach']['is_checked']=="1"?true:false??false,
        avg_rate: "0",

        name: json['coachinfo']['name'],
        number: json['coachinfo']['number'],
        email: json['coachinfo']['email'],
        role: json['coachinfo']['role'],

        branchId: handleApi(json['coachinfo']['user_infos']['branch_id']),
        gender: json['coachinfo']['user_infos']['gender']??'male',
        bio: json['coachinfo']['user_infos']['bio']??" ",
        weight: handleApi(json['coachinfo']['user_infos']['weight']) ??0,
        height: handleApi(json['coachinfo']['user_infos']['height']) ??0,
        calories: handleApi(json['coachinfo']['user_infos']['calories']) ??0,
        age: handleApi(json['coachinfo']['user_infos']['age']) ??0,
        activity_level: handleApi(json['coachinfo']['user_infos']['activity_level'])??0,
        Protein: json['coachinfo']['user_infos']['Protein']??'',
        Carbs: json['coachinfo']['user_infos']['Carbs']??'',
        Fats: json['coachinfo']['user_infos']['Fats']??'',
        databaseID: handleApi(json['coachinfo']['user_infos']['id'])
    );
  }

}