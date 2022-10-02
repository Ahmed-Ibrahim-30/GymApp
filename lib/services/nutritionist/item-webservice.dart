import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/nutritionist/item.dart';
import 'package:gym_project/models/nutritionist/items.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

const portNum = '8000';

class ItemWebService {
  final String local = Constants.defaultUrl;
  Future<Item> getItem(int itemID, BuildContext context) async {
    final response = await http.get(
      Uri.parse('$local/api/items/$itemID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Authorization': 'Bearer ' +
            Provider.of<LoginViewModel>(context, listen: false).token,
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body)['item']);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<bool> createItem(BuildContext context, Item item) async {
    try {
      item.nutritionistID =
          Provider.of<LoginViewModel>(context, listen: false).id;

      final response = await http.post(
        Uri.parse('$local/api/items/create'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          
          'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          'Authorization': 'Bearer ' +
              Provider.of<LoginViewModel>(context, listen: false).token,
          'Accept': '*/*',
        },
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteItem(BuildContext context, int itemID) async {
    final response = await http.delete(
      Uri.parse('$local/api/items/$itemID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Authorization': 'Bearer ' +
            Provider.of<LoginViewModel>(context, listen: false).token,
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<bool> editItem(BuildContext context, Item item) async {
    try {
      item.nutritionistID =
          Provider.of<LoginViewModel>(context, listen: false).id;

      final response = await http.put(
        Uri.parse('$local/api/items/edit/${item.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          
          'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          'Authorization': 'Bearer ' +
              Provider.of<LoginViewModel>(context, listen: false).token,
          'Accept': '*/*',
        },
        body: jsonEncode(item.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      return false;
    }
  }

  /////////////////////////

  Future<Items> getItems(
      BuildContext context, String searchText, int currentPage) async {
    final response = await http.get(
      searchText.isEmpty
          ? Uri.parse('$local/api/items?page=$currentPage')
          : Uri.parse(
              '$local/api/items?text=$searchText&&page=$currentPage'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Authorization': 'Bearer ' +
            Provider.of<LoginViewModel>(context, listen: false).token,
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      return Items.fromJson(searchText.isEmpty
          ? jsonDecode(response.body)['items']['data']
          : jsonDecode(response.body)['items']);
    } else {
      throw Exception(response.statusCode);
    }
  }
}
