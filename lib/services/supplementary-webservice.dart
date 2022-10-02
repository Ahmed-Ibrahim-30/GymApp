import 'dart:convert';

import 'package:gym_project/constants.dart';
import 'package:gym_project/models/supplementary.dart';
import 'package:http/http.dart' as http;

const portNum = '8000';
// const token =
//     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vZ3ltcHJvamVjdC50ZXN0L2FwaS9sb2dpbiIsImlhdCI6MTYzMjgxNjQ3NiwiZXhwIjoxNjMyOTAyODc2LCJuYmYiOjE2MzI4MTY0NzYsImp0aSI6IjlxRFV2NDIxQkhCVVQ0VnoiLCJzdWIiOjIzLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.Qsf1eIba2QDkQtdPCRgqJW-ROS2YOeBy2NN3VTKaC80';
final local = Constants.defaultUrl;

class SupplementaryWebService {
  String token;
  SupplementaryWebService(this.token);
  //get all supplementaries
  Future<List<Supplementary>> getAllSupplementaries() async {
    final response = await http.get(
      Uri.parse('$local/api/supplementaries'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
      },
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] == 'There are no supplementaries') return [];
      Iterable list = result['supplementaries'];
      return list
          .map((supplementary) => Supplementary.fromJson(supplementary))
          .toList();
    } else {
      throw Exception('Failed to get supplementaries.');
    }
  }

  //get supplementary by id
  Future<Supplementary> getSupplementaryById(int id) async {
    final response = await http.get(
      Uri.parse('$local/api/supplementaries/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
      },
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] == 'There is no Supplementary with this id')
        return null;
      return Supplementary.fromJson(result['Supplementary']);
    } else {
      throw Exception('Failed to get supplementaries.');
    }
  }

  //get branch supplementaries
  Future<List<Supplementary>> getBranchSupplementaries(int branch_id) async {
    final response = await http.get(
      Uri.parse('$local/api/branches/$branch_id/supplementaries'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
      },
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] == 'No supplementaries in this branch') return [];
      Iterable list = result['supplementaries'];
      return list
          .map((supplementary) => Supplementary.fromJson(supplementary))
          .toList();
    } else {
      throw Exception('Failed to get supplementaries.');
    }
  }

  //add supplementary
  Future<void> addSupplementary(
      String title, String description, int price, String picture) async {
    final response = await http.post(
      Uri.parse('$local/api/supplementaries/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
        'price': price.toString(),
        'picture': picture,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] == 'Supplementary Added correctly')
        return 'Supplementary Added correctly';
    } else {
      throw Exception('Failed to add supplementary.');
    }
  }

  //add supplementary to branch
  Future<void> addSupplementaryToBranch(
      int branch_id, int id, int quantity) async {
    final response = await http.post(
      Uri.parse('$local/api/branches/$branch_id/add/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'quantity': quantity.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] == 'Supplementary added correctly to branch')
        return 'Supplementary added correctly to branch';
    } else {
      throw Exception('Failed to add supplementary.');
    }
  }

  //edit supplementary
  Future<void> editSupplementary(int id, String title, String description,
      int price, String picture) async {
    final response = await http.post(
      Uri.parse('$local/api/supplementaries/edit/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
        'price': price.toString(),
        'picture': picture,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] == 'Supplementary updated correctly')
        return 'Supplementary updated correctly';
    } else {
      throw Exception('Failed to update supplementary.');
    }
  }

  //remove supplementary from branch
  Future<void> removeSupplementaryFromBranch(int branch_id, int id) async {
    final response = await http.post(
      Uri.parse('$local/api/branches/$branch_id/remove/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{}),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] == 'Supplementary removed correctly from branch')
        return 'Supplementary removed correctly from branch';
    } else {
      throw Exception('Failed to remove supplementary from branch.');
    }
  }

  //delete supplementary
  Future<void> deleteSupplementary(int id) async {
    final response = await http.delete(
      Uri.parse('$local/api/supplementaries/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] == 'Supplementary deleted correctly')
        return 'Supplementary deleted correctly';
    } else {
      throw Exception('Failed to delete supplementary.');
    }
  }
}
