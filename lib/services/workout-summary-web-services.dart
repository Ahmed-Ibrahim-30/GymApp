import 'dart:convert';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/workout-summaries-list-model.dart';
import 'package:gym_project/models/workout-summary.dart';
import 'package:gym_project/widget/global.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutSummaryServices {
  final String local = Constants.defaultUrl;
  final String request = 'api/members/workoutsummaries/self';
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String token = prefs.getString('token');
    return token;
  }

  Future<List<WorkoutSummary>> fetchSummaries() async {
    String token = Global.token;
    print('I am fetching summaries');
    try {
      final response = await http.get(Uri.parse('$local/$request'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        String data = response.body;
        var jsonData = jsonDecode(data);
        WorkoutSummairesListModel summeriesListResponse =
            WorkoutSummairesListModel.fromJson(jsonData);
        List<WorkoutSummary> allSummaries = summeriesListResponse.summaries
            .map((e) => WorkoutSummary.fromJson(e))
            .toList();
        return allSummaries;
      } else {
        print(
            'Response Failed, status code = ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('exception is $e');
      return null;
    }
  }

  Future<WorkoutSummary> postWorkoutSummary(
    WorkoutSummary workoutSummary,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$local/api/members/workoutsummaries'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(workoutSummary.toMap(forCreation: true)),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final workoutSummaryJson = result['workout_summary'];
      return WorkoutSummary.fromJson(workoutSummaryJson);
    } else {
      throw Exception('response failed');
    }
  }
}
