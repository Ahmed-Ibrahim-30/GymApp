import 'dart:convert';

import 'package:gym_project/constants.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/viewmodels/groups-view-model.dart';
import 'package:gym_project/widget/global.dart';
import 'package:http/http.dart' as http;
import 'package:gym_project/models/group.dart';
import 'package:pretty_json/pretty_json.dart';

class GroupWebService {
  final String local = Constants.defaultUrl;
  String token = Global.token;
  Future<Tuple<int, List<Group>>> getGroups(int page, String searchText) async {
    String url = '$local/api/groups';
    if (page == 0) {
      if (searchText.isNotEmpty) url += '?text=$searchText';
    } else {
      url += '?page=$page';
      if (searchText.isNotEmpty) {
        url += '&text=$searchText';
      }
    }
    Tuple<int, List<Group>> res = Tuple();
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    var result = json.decode(response.body);
    String userName = result['data']['name'];
    Global.setUserName(userName);
    if (response.statusCode == 200) {
      Iterable list;
      if (page != 0 && searchText.isEmpty) {
        res.item1 = result['data']['groups']['last_page'];
        list = result['data']['groups']['data'];
      } else {
        res.item1 = 1;
        list = result['data']['groups'];
      }
      // print(list);
      List<Group> groups = list.map((group) => Group.fromJson(group)).toList();
      List<Group> newGroups = groups.cast<Group>().toList();
      res.item2 = newGroups;
      return res;
    } else {
      throw Exception('response failed');
    }
  }

  Future<List<Group>> fetchWeekGroups() async {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day);
    DateTime endTime = startTime.add(Duration(days: 7));
    print(startTime);
    print(endTime);
    final response = await http.get(
        Uri.parse(
          '$local/api/members/weekGroups?start_time=${startTime.toString()}&end_time=${endTime.toString()}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    // print(response.statusCode);
    String data = response.body;
    print(response.body);
    if (response.statusCode == 200) {
      Iterable jsonData = jsonDecode(data)['Week Groups'];
      List<Group> allGroups =
          jsonData.map<Group>((e) => Group.WeekGroupfromJson(e)).toList();
      List<Group> finalGroups = allGroups.cast<Group>().toList();
      return finalGroups;
    } else {
      throw Exception('response failed');
    }
  }

  Future<Group> getGroupDetails(int groupId) async {
    final response = await http.get(
      Uri.parse('$local/api/groups/$groupId/details'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    var body = json.decode(response.body);
    Group group = Group.detailsFromJson(body['group']);
    return group;
  }

  Future<Group> postGroup(
    Group group,
    List<dynamic> orderedObjects,
  ) async {
    final response = await http.post(
      Uri.parse('$local/api/groups'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(group.toMapForCreation(orderedObjects)),
    );
    var body = json.decode(response.body);
    Group createdGroup = Group.fromJson(body['group']);
    return createdGroup;
  }

  Future<bool> assignGroups(
    List<Map<String, dynamic>> groups,
    int memberId,
  ) async {
    final response = await http.post(
      Uri.parse('$local/api/coaches/assign-group-member'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'groups': groups,
        'member_id': memberId,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('response failed.');
    }
  }

  Future<Group> putGroup(
    Group group,
    List<dynamic> orderedObjects,
  ) async {
    final response = await http.put(
      Uri.parse('$local/api/groups/${group.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(group.toMapForCreation(orderedObjects)),
    );
    var body = json.decode(response.body);
    Group createdGroup = Group.fromJson(body['group']);
    return createdGroup;
  }

  Future<void> deleteGroup(Group group) async {
    await http.delete(
      Uri.parse('$local/api/sets/${group.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
