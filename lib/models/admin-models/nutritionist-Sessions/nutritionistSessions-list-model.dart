import 'package:gym_project/models/admin-models/branches/branch-model.dart';

class NutritionistSessions {
  final List<dynamic> nutritionistSessions;

  NutritionistSessions({this.nutritionistSessions});

  factory NutritionistSessions.fromJson(Map<String, dynamic> jsonData) {
    return NutritionistSessions(
      nutritionistSessions: jsonData['sessions'],
    );
  }
}
