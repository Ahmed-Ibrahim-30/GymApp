import 'package:gym_project/models/nutritionist/item.dart';

class ItemMeal {
  int id;
  int cal = 0;
  String title = '';
  String description;
  String image;
  String level = '';
  int nutritionistID = 0;
  int quantity = 0;

  ItemMeal({
    this.id,
    this.cal,
    this.title,
    this.description,
    this.image,
    this.level,
    this.nutritionistID,
    this.quantity,
  });

  factory ItemMeal.fromJson(Map<String, dynamic> json) {
    return ItemMeal(
      id: json['id'],
      cal: json['cal'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      level: json['level'],
      nutritionistID: json['nutritionist_id'],
      quantity: json['info']['quantity'],
    );
  }

  Map<String, Object> toMap() {
    return {
      'id': id,
      'cal': cal,
      'title': title,
      'description': description,
      'image': image,
      'level': level,
      'nutritionist_id': nutritionistID,
      'quantity': quantity,
    };
  }

  String toString() {
    return toMap().toString();
  }

  Item toItem() {
    return Item(
      id: id,
      cal: cal,
      title: title,
      description: description,
      image: image,
      level: level,
      nutritionistID: nutritionistID,
    );
  }
}
