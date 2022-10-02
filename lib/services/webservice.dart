import 'dart:convert';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/exercise.dart';
import 'package:gym_project/models/set.dart';
import 'package:http/http.dart' as http;
import '../models/admin-models/equipments/equipment-model.dart';
import '../widget/global.dart';

String token =Global.token;


class WebService {
  final String local = Constants.defaultUrl;
  Future<List<Equipment>> getEquipments() async {
    final response = await http.get(Uri.parse('$local/api/equipments'));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      Iterable list = result['equipments'];
      return list.map((equipment) => Equipment.fromJson(equipment)).toList();
    } else {
      throw Exception('response failed');
    }
  }



  Future<List<Exercise>> getExercises() async {
    print('Am i here??');
    final response =
        await http.get(Uri.parse('$local/api/exercises'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print('response obtained!');
    print(response.statusCode);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      Iterable list = result['exercises']['data'];
      List<Exercise> exercises = list
          .map<Exercise>((exercise) => Exercise.fromJson(exercise))
          .toList();
      List<Exercise> newExercises = exercises.cast<Exercise>().toList();
      return newExercises;
    } else {
      throw Exception('response failed');
    }
  }

  Future<Exercise> getExerciseDetails(int exerciseId) async {
    print('Am i here??');
    final response = await http
        .get(Uri.parse('$local/api/exercises/$exerciseId/details'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print('response obtained!');
    print(response.statusCode);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final exerciseJson = result['exercise'];
      return Exercise.detailsfromJson(exerciseJson);
    } else {
      throw Exception('response failed');
    }
  }

  Future<List<Set>> getSets() async {
    print('Am i here??');
    final response = await http.get(Uri.parse('$local/api/sets'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print('response obtained!');
    print(response.statusCode);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      Iterable list = result['sets']['data'];
      List<Set> sets = list.map<Set>((set) => Set.fromJson(set)).toList();
      List<Set> newSets = sets.cast<Set>().toList();
      return newSets;
    } else {
      throw Exception('response failed');
    }
  }

  Future<Set> getSetDetails(int setId) async {
    print('Am i here??');
    final response =
        await http.get(Uri.parse('$local/api/sets/$setId/details'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print('response obtained!');
    print(response.statusCode);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final setJson = result['set'];
      return Set.detailsfromJson(setJson);
    } else {
      throw Exception('response failed');
    }
  }
}
