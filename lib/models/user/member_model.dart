import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/user/user_model.dart';

import 'coach_model.dart';
import 'nutritionist_model.dart';

class Member extends User{
  int id; //member id
  int membership_id;
  int coach_id;
  num rate_count;
  num current_plan;
  bool isChecked;
  String startDate='';
  String endDate='';
  String medicalPhysicalHistory;
  String medicalAllergicHistory;
  num availableFrozenDays;
  num availableMembershipDays;
  num activeDays;
  Nutritionist nutritionist;
  Coach coach;

  Member({
    @required this.id,
    @required int index,
    @required int user_id,
    @required this.membership_id,
    @required this.coach_id,
    @required int branchId,
    @required String name,
    @required String number,
    @required String gender,
    @required String email,
    @required String role,
    @required File photo,
    @required String bio,
    @required this.rate_count,
    @required this.current_plan,
    @required this.isChecked,
    @required this.startDate,
    @required this.endDate,
    @required this.medicalPhysicalHistory,
    @required this.medicalAllergicHistory,
    @required this.availableFrozenDays,
    @required this.availableMembershipDays,
    @required this.activeDays,
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

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        id: json['id'] is String?int.parse(json['id']):json['id'],
        index: membersUsers.length,
        isChecked: json['is_checked']??false,
        startDate: "${json['start_date']}"??'',
        endDate: "${json['end_date']}"??'',
        medicalPhysicalHistory: "${json['medical_physical_history']}"??' ',
        medicalAllergicHistory: "${json['medical_allergic_history']}"??' ',
        availableFrozenDays: json['available_frozen_days'] is String ?num.parse(json['available_frozen_days']):json['available_frozen_days']??0,
        availableMembershipDays: json['available_membership_days'] is String ?num.parse(json['available_membership_days']):json['available_membership_days']??0,
        activeDays: json['active_days'] is String ?num.parse(json['active_days']):json['active_days']??0,
        coach_id: json['coach_id'] is String ?int.parse(json['coach_id']):json['coach_id']??0,
        rate_count: json['rate_count'] is String ?num.parse(json['rate_count']):json['rate_count']??0,
        user_id: json['user_id'] is String ?int.parse(json['user_id']):json['user_id'],
        membership_id: json['membership_id'] is String ?int.parse(json['membership_id']):json['membership_id'],
        current_plan: json['current_plan'] is String ?int.parse(json['current_plan']):json['current_plan']??0,
        databaseID: json['userinfo']['id'] is String ?int.parse(json['userinfo']['id']):json['userinfo']['id'],
        gender: "${json['userinfo']['gender']}"??'male',
        weight: json['userinfo']['weight'] is String ? int.parse(json['userinfo']['weight']):json['userinfo']['weight']??0,
        height: json['userinfo']['height'] is String ?int.parse(json['userinfo']['height']):json['userinfo']['height']??0,
        calories: handleApi(json['userinfo']['calories'])??0,
        age: handleApi(json['userinfo']['age'])??20,
        activity_level: handleApi(json['userinfo']['activity_level'])??0,
        bio: "${json['userinfo']['bio']}"??' ',
        branchId: handleApi(json['userinfo']['branch_id'])??-1,
        Protein: "${json['userinfo']['Protein']}"??' ',
        Carbs: "${json['userinfo']['Carbs']}"??' ',
        Fats: "${json['userinfo']['Fats']}"??' ',
        name: "${json['user']['name']}",
        number: "${json['user']['number']}",
        email: "${json['user']['email']}",
        role: "${json['user']['role']}",
    );
  }
  factory Member.fromJsonAdd(Map<String, dynamic> json) {
    return Member(
      id: handleApi(json['member']['id']),
      index: membersUsers.length,
      isChecked: json['member']['is_checked']=="1"?true:false??false,
      startDate: '',
      endDate: '',
      medicalPhysicalHistory: "${json['member']['medical_physical_history']}"??' ',
      medicalAllergicHistory: "${json['member']['medical_allergic_history']}"??' ',
      availableFrozenDays: handleApi(json['member']['available_frozen_days'])??0,
      availableMembershipDays: handleApi(json['member']['available_membership_days'])??0,
      activeDays: handleApi(json['member']['active_days'])??0,
      coach_id: handleApi(json['member']['coach_id'])??0,
      rate_count: handleApi(json['member']['rate_count']) ??0,
      user_id: handleApi(json['member']['user_id']),
      membership_id: handleApi(json['member']['membership_id']),
      current_plan: handleApi(json['member']['current_plan'])??0,

      databaseID: handleApi(json['memberinfo']['id']),
      name: "${json['memberinfo']['name']}",
      number: "${json['memberinfo']['number']}",
      email: "${json['memberinfo']['email']}",
      role: "${json['memberinfo']['role']}",

      gender: "${json['memberinfo']['user_infos']['gender']}"??'male',
      weight: 0,
      height: 0,
      calories:0,
      age: handleApi(json['memberinfo']['user_infos']['age']),
      activity_level: 0,
      bio: "${json['memberinfo']['user_infos']['bio']}"??' ',
      branchId: handleApi(json['memberinfo']['user_infos']['branch_id']) ??-1,
      Protein: "${json['memberinfo']['user_infos']['Protein']}"??' ',
      Carbs: "${json['memberinfo']['user_infos']['Carbs']}"??' ',
      Fats: "${json['memberinfo']['user_infos']['Fats']}"??' ',
    );
  }
}
