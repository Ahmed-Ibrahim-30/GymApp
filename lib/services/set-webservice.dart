import 'package:gym_project/constants.dart';
import 'package:gym_project/models/set.dart';
import 'package:gym_project/models/tuple.dart';

import 'package:gym_project/widget/global.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SetWebService {
  final String local = Constants.defaultUrl;
  String token = Global.token;
  Future<Tuple<int, List<Set>>> getSets(
    int page,
    String searchText,
  ) async {
    String url = '$local/api/sets';
    if (page == 0) {
      if (searchText.isNotEmpty) url += '?text=$searchText';
    } else {
      url += '?page=$page';
      if (searchText.isNotEmpty) {
        url += '&text=$searchText';
      }
    }
    Tuple<int, List<Set>> res = Tuple();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print('response obtained!');
    print(response.statusCode);
    final result = json.decode(response.body);
    print(result);
    String userName = result['data']['name'];
    Global.setUserName(userName);
    Iterable list;
    if (response.statusCode == 200) {
      if (page != 0 && searchText.isEmpty) {
        print('now');
        res.item1 = result['data']['sets']['last_page'];
        // Iterable list = result['sets']['data'];
        list = result['data']['sets']['data'];
      } else {
        print('then');
        res.item1 = 1;
        // Iterable list = result['exercises']['data'];
        list = result['data']['sets'];
      }
      print(list);
      List<Set> sets = list.map<Set>((set) => Set.fromJson(set)).toList();
      List<Set> newSets = sets.cast<Set>().toList();
      res.item2 = newSets;
      return res;
    } else {
      throw Exception('response failed');
    }
  }

  Future<Set> getSetDetails(int setId) async {
    print('Am i here??');
    final response = await http.get(
        Uri.parse('$local/api/sets/$setId/details'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print('response obtained!');
    print(response.statusCode);
    final result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      final setJson = result['set'];
      return Set.detailsfromJson(setJson);
    } else {
      throw Exception('response failed');
    }
  }

  Future<Set> postSet(Set set) async {
    final response = await http.post(
      Uri.parse('$local/api/sets'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: set.toJsonForCreation(),
    );
    print('response obtained!');
    print(response.body);
    if (response.statusCode == 201) {
      final result = json.decode(response.body);
      final exerciseJson = result['set'];
      return Set.fromJson(exerciseJson);
    } else {
      throw Exception('response failed');
    }
  }

  Future<Set> putSet(Set set) async {
    final response = await http.put(
      Uri.parse('$local/api/sets/${set.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: set.toJsonForCreation(),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final setJson = result['set'];
      return Set.fromJson(setJson);
    } else {
      throw Exception('response failed');
    }
  }

  Future<void> deleteSet(Set set) async {
    final response = await http.delete(
      Uri.parse('${Constants.defaultUrl}/api/sets/${set.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('response failed');
    }
  }
}
