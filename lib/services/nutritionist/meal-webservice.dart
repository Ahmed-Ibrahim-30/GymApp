import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/helper/general-helpers.dart';
import 'package:gym_project/models/login.dart';
import 'package:gym_project/models/nutritionist/meal.dart';
import 'package:gym_project/models/nutritionist/meals.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

const portNum = '8000';

class MealWebService {
  final String local = Constants.defaultUrl;
  // Osama's implementation of fetching a meal
  Future<Meal> getMeal(int mealID, BuildContext context) async {
    final response = await http.get(
      Uri.parse('$local/api/meals/$mealID'),
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
      return Meal.fromJson(jsonDecode(response.body)['meal']);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Meal> postMeal(Meal meal, String token) async {
    final response = await http.post(
      Uri.parse('$local/api/meals/create'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: meal.toJsonForCreation(),
    );
    if (response.statusCode == 201) {
      final result = json.decode(response.body);
      final mealJson = result['meal'];
      return Meal.fromJson(mealJson);
    } else {
      print(response.body);
      throw Exception('response failed');
    }
  }

  Future<Meal> putMeal(Meal meal, String token) async {
    ansiPrint(meal.toString());
    final response = await http.put(
      Uri.parse('$local/api/meals/${meal.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: meal.toJsonForCreation(),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final mealJson = result['meal'];
      return Meal.fromJson(mealJson);
    } else {
      print(response.body);
      throw Exception('response failed');
    }
  }

  Future<bool> deleteMeal(BuildContext context, int mealID) async {
    final response = await http.delete(
      Uri.parse('$local/api/meals/$mealID'),
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

  ///////////////////////////

  Future<Meals> getMeals(
      BuildContext context, String searchText, int currentPage) async {
    final response = await http.get(
      searchText.isEmpty
          ? Uri.parse('$local/api/meals?page=$currentPage')
          : Uri.parse(
              '$local/api/meals?text=$searchText&&page=$currentPage'),
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
      return Meals.fromJson(searchText.isEmpty
          ? jsonDecode(response.body)['meals']['data']
          : jsonDecode(response.body)['meals']);
    } else {
      throw Exception(response.statusCode);
    }
  }
}
