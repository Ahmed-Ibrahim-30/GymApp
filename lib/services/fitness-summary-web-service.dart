import 'dart:convert';

import 'package:gym_project/constants.dart';
import 'package:gym_project/models/fitness-summary.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/widget/global.dart';
import 'package:http/http.dart' as http;

class FitnessSummaryWebService {
  final String local = Constants.defaultUrl;
  String token = Global.token;
  Future<Tuple<int, List<FitnessSummary>>> getFitnessSummaries(
      int page, String startDate, String endDate) async {
    Tuple<int, List<FitnessSummary>> res = Tuple();
    final response = await http.get(
      Uri.parse('$local/api/fitness_summaries'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    final result = json.decode(response.body);
    print(result);
    res.item1 = 1;
    if (response.statusCode == 200) {
      Iterable list = result['fitness summaries'];
      res.item2 = list
          .map((fitnessSummary) => FitnessSummary.fromJson(fitnessSummary))
          .toList();
      return res;
    } else {
      throw Exception('response failed');
    }
  }

  Future<FitnessSummary> getFitnessSummary(int fitnessId) async {
    final response = await http.get(
      Uri.parse('$local/api/fitness_summaries/$fitnessId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    final result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return FitnessSummary.fromJson(result['fitness summary']);
    } else {
      throw Exception('response failed');
    }
  }

  Future<bool> deleteFitnessSummary(int fitnessId) async {
    final response = await http.delete(
      Uri.parse('$local/api/fitness_summaries/$fitnessId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    final result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('response failed');
    }
  }

  Future<bool> postFitnessSummary(FitnessSummary fitSum) async {
    final response =
        await http.post(Uri.parse('$local/api/fitness_summaries/create'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'BMI': fitSum.BMI.toDouble(),
              'weight': fitSum.weight.toDouble(),
              'muscle_ratio': fitSum.muscleRatio.toDouble(),
              'height': fitSum.height.toDouble(),
              'fat_ratio': fitSum.fatRatio.toDouble(),
              'fitness_ratio': fitSum.fitnessRatio.toDouble(),
              'total_body_water': fitSum.totalBodyWater.toDouble(),
              'dry_lean_bath': fitSum.dryLeanBath.toDouble(),
              'body_fat_mass': fitSum.bodyFatMass.toDouble(),
              'opacity_ratio': fitSum.opacityRatio.toDouble(),
              'protein': fitSum.protein.toDouble(),
              'SMM': fitSum.SMM.toDouble(),
              'member_id': fitSum.memberId.toDouble(),
            }));
    print('response obtained!');
    print(response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('response failed');
    }
  }
}
