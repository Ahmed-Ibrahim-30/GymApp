import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gym_project/helper/general-helpers.dart';
import 'package:gym_project/models/nutritionist/item-meal.dart';
import 'package:gym_project/models/nutritionist/item.dart';
import 'package:gym_project/models/nutritionist/meal-plan.dart';

class Meal {
  int id;
  String title = '';
  String description = '';
  int nutritionistID = 0;
  List<ItemMeal> items = [];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'nutritionist_id': nutritionistID,
        'id': id,
      };

  String toJsonForCreation() {
    List<Map<String, Object>> items = this.items.map((item) {
      return {
        'id': item.id,
        'quantity': item.quantity,
      };
    }).toList();

    Map<String, Object> mappedMeal = {
      'title': title,
      'description': description,
      'items': items,
    };
    return json.encode(mappedMeal);
  }

  Meal({
    this.id,
    this.title,
    this.description,
    this.nutritionistID,
    this.items,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    Meal meal = Meal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      nutritionistID: json['nutritionist_id'],
    );

    List<ItemMeal> itemMeals = [];
    List<dynamic> items = json['items'];
    for (var i = 0; i < items.length; i++) {
      Map<String, dynamic> itemJson = items[i] as Map<String, dynamic>;
      itemMeals.add(ItemMeal.fromJson(itemJson));
    }

    meal.items = itemMeals;

    return meal;
  }

  factory Meal.fromCreationJson(Map<String, Object> json) {
    return Meal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      nutritionistID: json['nutritionist_id'],
    );
  }

  Map<String, Object> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'nutritionist_id': nutritionistID,
      'items': items
    };
  }

  String toString() {
    return toMap().toString();
  }

  MealPlan toMealPlan({@required String day, @required String type}) {
    return MealPlan(
      id: id,
      title: title,
      description: description,
      nutritionistID: nutritionistID,
      items: items,
      day: day,
      type: type,
    );
  }
}
