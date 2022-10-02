import 'dart:convert';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/widget/global.dart';
import 'package:gym_project/models/exercise.dart';
import 'package:gym_project/viewmodels/exercise-view-model.dart';


import 'package:http/http.dart' as http;

class ExerciseWebService {
  final String local = Constants.defaultUrl;
  String token = Global.token;
  // ExerciseWebService({this.token});
  Future<Tuple<int, List<Exercise>>> getExercises(
      int page, String searchText) async {
    // print('Am i here??');
    print(page);
    print(searchText.isNotEmpty);
    String url = '$local/api/exercises';
    if (page == 0) {
      if (searchText.isNotEmpty) url += '?text=$searchText';
    } else {
      url += '?page=$page';
      if (searchText.isNotEmpty) {
        url += '&text=$searchText';
      }
    }
    print(url);

    Tuple<int, List<Exercise>> res = Tuple();
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    // print('response obtained!');
    // print(response.statusCode);
    final result = json.decode(response.body);
    print(result);
    String userName = result['data']['name'];
    Global.setUserName(userName);
    if (response.statusCode == 200) {
      Iterable list;
      if (page != 0 && searchText.isEmpty) {
        print('now');
        res.item1 = result['data']['exercises']['last_page'];
        // Iterable list = result['exercises']['data'];
        list = result['data']['exercises']['data'];
      } else {
        print('then');
        res.item1 = 1;
        // Iterable list = result['exercises']['data'];
        list = result['data']['exercises'];
      }
      // print(list);
      List<Exercise> exercises = list
          .map<Exercise>((exercise) => Exercise.fromJson(exercise))
          .toList();
      List<Exercise> newExercises = exercises.cast<Exercise>().toList();
      res.item2 = newExercises;
      return res;
    } else {
      // print(result.msg);
      throw Exception(response.body);
    }
  }

  Future<Exercise> getExerciseDetails(
    int exerciseId,
  ) async {
    print('Am i here??');
    final response = await http
        .get(Uri.parse('$local/api/exercises/$exerciseId/details'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print('response obtained!');
    print(response.statusCode);
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      final exerciseJson = result['exercise'];
      return Exercise.detailsfromJson(exerciseJson);
    } else {
      print(result);
      throw Exception('response failed');
    }
  }

  Future<bool> postExercise(
    Exercise exercise,
  ) async {
    print('Am i here??');
    token = Global.token;
    final response = await http.post(Uri.parse('$local/api/exercises'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': exercise.title,
          'description': exercise.description,
          'gif': exercise.gif,
          'cal_burnt': exercise.calBurnt.toDouble(),
          'image': exercise.image,
          'duration': exercise.duration,
          'equipment_id': exercise.equipment.id,
          'reps': exercise.reps.toInt(),
        }));
    print('response obtained!');
    print(response.statusCode);
    final result = json.decode(response.body);
    print(result);
    if (response.statusCode == 201) {
      final exerciseJson = result['exercise'];
      return true;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> editExercise(
    ExerciseViewModel exercise,
  ) async {
    String token = Global.token;
    // print('Am i here??');
    final response =
        await http.put(Uri.parse('$local/api/exercises/${exercise.id}'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'title': exercise.title,
              'description': exercise.description,
              'gif': exercise.gif,
              'cal_burnt': exercise.calBurnt,
              'image': exercise.image,
              'duration': exercise.duration,
              'equipment_id': exercise.equipment.id,
              'reps': exercise.reps,
            }));
    print('response obtained!');
    print(response.statusCode);
    final result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      final exerciseJson = result['exercise'];
      return true;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> deleteExercise(
    int exerciseId,
  ) async {
    // print('Am i here??');
    String token = Global.token;
    final response = await http.delete(
      Uri.parse('$local/api/exercises/${exerciseId}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('response obtained!');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('response failed');
    }
  }
}
