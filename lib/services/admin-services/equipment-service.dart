import 'dart:convert';

import 'package:gym_project/constants.dart';
import 'package:gym_project/models/admin-models/equipments/equipment-model.dart';
import 'package:gym_project/models/admin-models/equipments/equipment-list-model.dart';
import 'package:http/http.dart' as http;

const token =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vZ3ltcHJvamVjdC50ZXN0L2FwaS9sb2dpbiIsImlhdCI6MTYzMjY0MjYzNywiZXhwIjoxNjMyNzI5MDM3LCJuYmYiOjE2MzI2NDI2MzcsImp0aSI6IlBIRTh6cThadGZQNVpXdXYiLCJzdWIiOjIzLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.bPYsQmnYY4xZsLzpp2QouAkFWu4a5hdxMeiaii6ClE4';

class EquipmentsWebservice {
  final String local = Constants.defaultUrl;
  //get all Equipments
  Future<List<Equipment>> fetchEquipments() async {
    final response = await http.get(
        Uri.parse('$local/api/equipments/getAll'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      Equipments equipments = Equipments.fromJson(jsonData);
      return equipments.equipments.map((e) => Equipment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to download Equipments');
    }
  }

  //get Equipments by id
  Future<Equipment> fetchEquipmentsById(int id) async {
    final response = await http.get(
        Uri.parse('$local/api/equipments/show/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      Equipment equipment = Equipment.fromJson(jsonData);
      return equipment;
    } else {
      throw Exception('Failed to download Equipment');
    }
  }

  //add Equipment
  Future<void> postEquipment(
      // ignore: non_constant_identifier_names
      String name,
      String description,
      String picture) async {
    print('adding Equipment');
    final response = await http.post(
      Uri.parse('$local/api/equipments/store'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'description': description,
        'picture': picture,
      }),
    );
  }

  //edit Equipment
  Future<void> editEquipment(
      int id, String name, String description, String picture) async {
    print('editing Equipment');
    // ignore: unused_local_variable
    final response = await http.post(
      Uri.parse('$local/api/equipments/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'description': description,
        'picture': picture,
      }),
    );
  }

  //delete Equipment
  Future<void> deleteEquipment(int id) async {
    print('deleting Equipment');
    final response = await http.delete(
      Uri.parse('$local/api/equipments/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
  }
}
