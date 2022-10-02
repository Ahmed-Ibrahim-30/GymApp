import 'package:gym_project/models/nutritionist/item.dart';

class Items {
  List<Item> data = [];

  Items({this.data});

  factory Items.fromJson(List<dynamic> json) {
    List<Item> tempResult = [];
    for (var i = 0; i < json.length; i++) {
      Map<String, dynamic> entry = json[i] as Map<String, dynamic>;
      tempResult.add(Item.fromJson(entry));
    }

    return Items(
      data: tempResult,
    );
  }
}
