import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/foundation.dart';
import 'package:gym_project/models/nutritionist/item-meal.dart';
import 'package:gym_project/models/nutritionist/item-plan.dart';

class Item {
  String title = '';
  String level = '';
  String description = '';
  String image = '';
  int nutritionistID = 0;
  int cal = 0;
  int id = 0;

  Item(
      {this.title,
      this.level,
      this.nutritionistID,
      this.cal,
      this.description,
      this.image,
      this.id});

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'level': level,
        'image': image,
        'cal': cal,
        'nutritionist_id': nutritionistID,
        'id': id,
      };

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'],
      level: json['level'],
      description: json['description'],
      image: json['image'],
      nutritionistID: json['nutritionist_id'],
      cal: json['cal'],
      id: json['id'],
    );
  }

  String toString() {
    AnsiPen pen = new AnsiPen()..green(); // Colors.green;
    return pen(json.encode(toJson()));
  }

  ItemMeal toItemMeal({@required int quantity}) {
    return ItemMeal(
      id: id,
      cal: cal,
      title: title,
      description: description,
      image: image,
      level: level,
      nutritionistID: nutritionistID,
      quantity: quantity,
    );
  }

  ItemPlan toItemPlan({int quantity, String day, String type}) {
    return ItemPlan(
      id: id,
      cal: cal,
      title: title,
      description: description,
      image: image,
      level: level,
      nutritionistID: nutritionistID,
      quantity: quantity,
      type: type,
    );
  }
}
