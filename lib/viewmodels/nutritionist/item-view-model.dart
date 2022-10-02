import 'package:flutter/material.dart';
import 'package:gym_project/models/nutritionist/item.dart';
import 'package:gym_project/models/nutritionist/items.dart';
import 'package:gym_project/services/nutritionist/item-webservice.dart';

class ItemViewModel with ChangeNotifier {
  Item item = Item(title: "Nice");

  String get title {
    return item.title;
  }

  String get level {
    return item.level;
  }

  int get calories {
    return item.cal;
  }

  String get description {
    return item.description;
  }

  String get image {
    return item.image;
  }

  int get nutritionistID {
    return item.nutritionistID;
  }

  int get id {
    return item.id;
  }

  Future<Item> fetchItem(int itemID, context) async {
    item = await ItemWebService().getItem(itemID, context);

    notifyListeners();

    return item;
  }

  Future<bool> createItem(context, Item item) async {
    var finished = await ItemWebService().createItem(context, item);

    notifyListeners();

    return finished;
  }

  Future<bool> editItem(context, Item item) async {
    var finished = await ItemWebService().editItem(context, item);

    notifyListeners();

    return finished;
  }

  Future<bool> deleteItem(context, int itemID) async {
    var finished = await ItemWebService().deleteItem(context, itemID);

    notifyListeners();

    return finished;
  }

  ///////////////////////////
  ///
  Items items = Items(data: []);

  List<Item> get data {
    return items.data;
  }

  Future<Items> fetchItems(context,
      {String searchText = '', int currentPage = 1}) async {
    items = await ItemWebService().getItems(context, searchText, currentPage);

    notifyListeners();

    return items;
  }
}
