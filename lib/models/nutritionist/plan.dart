import 'package:gym_project/helper/general-helpers.dart';
import 'package:gym_project/models/nutritionist/item-plan.dart';
import 'package:gym_project/models/nutritionist/meal-plan.dart';

class Plan {
  String title = '';
  String description = '';
  int nutritionistID = 0;
  List<ItemPlan> items = [];
  List<MealPlan> meals = [];
  int id = 0;
  String day = 'saturday';
  String type = 'breakfast';

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'nutritionist_id': nutritionistID,
        'id': id,
      };

  Plan(
      {
    this.title,
    this.description,
    this.nutritionistID,
    this.items,
    this.meals,
    this.id,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    Plan plan = Plan(
      title: json['title'],
      description: json['description'],
      nutritionistID: json['nutritionist_id'],
      id: json['id'],
    );

    List<ItemPlan> itemPlans = [];
    List<dynamic> items = json['items'];
    for (var i = 0; i < items.length; i++) {
      Map<String, dynamic> entry = items[i] as Map<String, dynamic>;
      itemPlans.add(ItemPlan(
        id: entry['id'],
        title: entry['title'],
        description: entry['description'],
        nutritionistID: entry['nutritionist_id'],
        cal: entry['cal'],
        image: entry['image'],
        level: entry['level'],
        day: entry['info']['day'],
        type: entry['info']['type'],
        quantity: entry['info']['quantity'],
      ));
    }

    plan.items = itemPlans;

    List<MealPlan> mealPlans = [];
    List<dynamic> meals = json['meals'];
    for (var i = 0; i < meals.length; i++) {
      Map<String, dynamic> entry = meals[i] as Map<String, dynamic>;
      mealPlans.add(MealPlan(
        id: entry['id'],
        title: entry['title'],
        description: entry['description'],
        nutritionistID: entry['nutritionist_id'],
        day: entry['info']['day'],
        type: entry['info']['type'],
      ));
    }

    plan.meals = mealPlans;

    return plan;
  }

  Map<String, Object> toMap() {
    List<Map<String, Object>> itemsMap =
        items.map((item) => item.toMap()).toList();
    List<Map<String, Object>> mealsMap =
        meals.map((meal) => meal.toMap()).toList();
    return {
      'id': id,
      'title': title,
      'description': description,
      'nutritionist_id': nutritionistID,
      'items': itemsMap,
      'meals': mealsMap,
    };
  }

  String toString() {
    return toMap().toString();
  }

  Map<String, Object> toMapForCreation() {
    List<Map<String, Object>> items = this
        .items
        .map((itemPlan) => {
              'id': itemPlan.id,
              'day': itemPlan.day,
              'type': itemPlan.type,
            })
        .toList();
    List<Map<String, Object>> meals = this
        .meals
        .map((mealPlan) => {
              'id': mealPlan.id,
              'day': mealPlan.day,
              'type': mealPlan.type,
            })
        .toList();
    return {
      'title': title,
      'description': description,
      'items': items,
      'meals': meals,
    };
  }
}
