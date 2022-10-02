import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/helper/general-helpers.dart';
import 'package:gym_project/models/nutritionist/plan.dart';
import 'package:gym_project/models/nutritionist/plans.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

const portNum = '8000';

class PlanWebService {
  final String local = Constants.defaultUrl;
  Future<Plan> getPlan(int planID, BuildContext context) async {
    final response = await http.get(
      Uri.parse('$local/api/plans/$planID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Authorization': 'Bearer ' +
            Provider.of<LoginViewModel>(context, listen: false).token,
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return Plan.fromJson(jsonDecode(response.body)['plan']);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Plan> getActivePlan(int memberID, BuildContext context) async {
    final response = await http.get(
      Uri.parse('$local/api/members/$memberID/getActivePlan'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Authorization': 'Bearer ' +
            Provider.of<LoginViewModel>(context, listen: false).token,
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['plan'].toString() == '[]') //no active plan
        return null;
      else
        return Plan.fromJson(jsonDecode(response.body)['plan']);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<bool> deleteActivePlan(int memberID, BuildContext context) async {
    final response = await http.put(
      Uri.parse('http://localhost:$portNum/api/members/$memberID/removePlan'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Authorization': 'Bearer ' +
            Provider.of<LoginViewModel>(context, listen: false).token,
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<bool> assignActivePlan(
      int memberID, BuildContext context, dynamic object) async {
    final response = await http.put(
      Uri.parse('http://localhost:$portNum/api/members/$memberID/addPlan'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Authorization': 'Bearer ' +
            Provider.of<LoginViewModel>(context, listen: false).token,
        'Accept': '*/*',
      },
      body: object,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<bool> deletePlan(BuildContext context, int planID) async {
    final response = await http.delete(
      Uri.parse('$local/api/plans/$planID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Authorization': 'Bearer ' +
            Provider.of<LoginViewModel>(context, listen: false).token,
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      throw Exception(response.statusCode);
    }
  }

  /////////////////////////

  Future<Plans> getPlans(
      BuildContext context, String searchText, int currentPage) async {
    final response = await http.get(
      searchText.isEmpty
          ? Uri.parse('$local/api/plans?page=$currentPage')
          : Uri.parse('$local/api/plans?text=$searchText&&page=$currentPage'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Authorization': 'Bearer ' +
            Provider.of<LoginViewModel>(context, listen: false).token,
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return Plans.fromJson(searchText.isEmpty
          ? jsonDecode(response.body)['plans']['data']
          : jsonDecode(response.body)['plans']);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Plan> postPlan(Plan plan, String token) async {
    final response = await http.post(
      Uri.parse('${Constants.defaultUrl}/api/plans/create'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(plan.toMapForCreation()),
    );
    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      Plan createdGroup = Plan.fromJson(body['plan']);
      return createdGroup;
    } else {
      print(response.body);
      throw Exception('Response failed');
    }
  }

  Future<Plan> putPlan(Plan plan, String token) async {
    final response = await http.put(
      Uri.parse('${Constants.defaultUrl}/api/plans/${plan.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(plan.toMapForCreation()),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      Plan createdPlan = Plan.fromJson(body['plan']);
      return createdPlan;
    } else {
      print(response.body);
      throw responseFailedException;
    }
  }
}
