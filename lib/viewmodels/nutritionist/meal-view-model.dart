import 'package:flutter/material.dart';
import 'package:gym_project/helper/constants.dart';
import 'package:gym_project/helper/general-helpers.dart';
import 'package:gym_project/models/nutritionist/meal.dart';
import 'package:gym_project/models/nutritionist/meals.dart';
import 'package:gym_project/services/nutritionist/meal-webservice.dart';
import 'package:gym_project/helper/constants.dart';
import 'package:gym_project/services/nutritionist/meal-webservice.dart';


class MealViewModel with ChangeNotifier {
  Meal meal = Meal(title: "Nice");
  LoadingStatus loadingStatus = LoadingStatus.Completed;

  String get title {
    return meal.title;
  }

  String get description {
    return meal.description;
  }

  int get nutritionistID {
    return meal.nutritionistID;
  }

  Future<Meal> fetchMeal(int mealID, context) async {
    loadingStatus = LoadingStatus.Searching;
    meal = await MealWebService().getMeal(mealID, context);
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();

    return meal;
  }

  Future<bool> deleteMeal(context, int mealID) async {
    bool finished = await MealWebService().deleteMeal(context, mealID);

    notifyListeners();

    return finished;
  }

  //////////////////////////////

  Meals meals = Meals(data: []);

  List<Meal> get data {
    return meals.data;
  }

  Future<Meals> fetchMeals(context,
      {String searchText = '', int currentPage = 1}) async {
    meals = await MealWebService().getMeals(context, searchText, currentPage);

    notifyListeners();

    return meals;
  }

  Future<void> postMeal(Meal meal, String token) async {
    loadingStatus = LoadingStatus.Searching;
    // notifyListeners();
    Meal mealModel = await MealWebService().postMeal(meal, token);

    meals.data.add(mealModel);
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  Future<void> putMeal(Meal meal, String token) async {
    // loadingStatus = LoadingStatus.Searching;
    // notifyListeners();
    // Meal mealModel =
    await MealWebService().putMeal(meal, token);

    editMealInProvider(meal);
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  void editMealInProvider(Meal meal) {
    int updatedMealIndex = meals.data.indexWhere((m) => m.id == meal.id);
    if (updatedMealIndex != -1) {
      meals.data.removeAt(updatedMealIndex);
      meals.data.insert(updatedMealIndex, meal);
    }
  } 
}
