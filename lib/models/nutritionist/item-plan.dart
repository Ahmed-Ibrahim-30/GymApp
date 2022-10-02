import 'package:gym_project/models/nutritionist/item.dart';

class ItemPlan {
  int id;
  String title = '';
  int nutritionistID = 0;
  String day = '';
  String description = '';
  String type = '';
  int quantity = 0;
  String image = '';
  int cal = 0;
  String level = '';

  ItemPlan(
      {this.id,
      this.title,
      this.nutritionistID,
      this.day,
      this.type,
      this.description,
      this.quantity,
      this.cal,
      this.image,
      this.level});

  factory ItemPlan.fromJson(Map<String, dynamic> json) {
    return ItemPlan(
      id: json['id'],
      title: json['title'],
      nutritionistID: json['nutritionist_id'],
      day: json['info']['day'],
      type: json['info']['type'],
      quantity: json['info']['quantity'],
      description: json['description'],
      cal: json['cal'],
      level: json['level'],
      image: json['image'],
    );
  }

  Item toItem() {
    return Item(
      title: title,
      level: level,
      nutritionistID: nutritionistID,
      cal: cal,
      description: description,
      image: image,
      id: id,
    );
  }

  Map<String, Object> toMap() {
    Item item = toItem();
    Map<String, Object> itemMap = item.toJson();

    Map<String, Object> itemPlanMap = itemMap;
    itemPlanMap.addEntries([
      MapEntry('day', day),
      MapEntry('type', type),
    ]);

    return itemPlanMap;
  }

  String toString() {
    return toMap().toString();
  }
}
