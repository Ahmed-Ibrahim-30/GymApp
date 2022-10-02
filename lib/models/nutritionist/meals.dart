import 'package:gym_project/models/nutritionist/meal.dart';

class Meals {
  List<Meal> data = [];

  Meals({this.data});

  factory Meals.fromJson(List<dynamic> json) {
    List<Meal> tempResult = [];
    for (var i = 0; i < json.length; i++) {
      Map<String, dynamic> entry = json[i] as Map<String, dynamic>;
      tempResult.add(Meal.fromJson(entry));
    }

    return Meals(
      data: tempResult,
    );
  }
}
