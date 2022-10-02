import 'package:gym_project/models/nutritionist/item-meal.dart';
import 'package:gym_project/models/nutritionist/meal.dart';

class MealPlan {
  String title = '';
  int nutritionistID = 0;
  String day = '';
  String description = '';
  String type = '';
  int id = 0;
  List<ItemMeal> items;

  MealPlan({
    this.title,
    this.nutritionistID,
    this.day,
    this.type,
    this.description,
    this.id,
    this.items,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      title: json['title'],
      nutritionistID: json['nutritionist_id'],
      day: json['info']['day'],
      type: json['info']['type'],
      description: json['description'],
      items: json['items'],
    );
  }

  Meal toMeal() {
    return Meal(
      title: title,
      nutritionistID: nutritionistID,
      description: description,
      id: id,
      items: items,
    );
  }

  Map<String, Object> toMap() {
    Meal meal = toMeal();
    Map<String, Object> mealMap = meal.toMap();

    Map<String, Object> mealPlanMap = mealMap;
    mealPlanMap.addEntries([
      MapEntry('day', day),
      MapEntry('type', type),
    ]);

    return mealPlanMap;
  }

  String toString() {
    return toMap().toString();
  }
}
