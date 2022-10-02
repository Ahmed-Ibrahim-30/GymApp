import 'package:gym_project/models/admin-models/branches/branch-model.dart';

class WorkoutSummairesListModel {
  final List<dynamic> summaries;

  WorkoutSummairesListModel({this.summaries});

  factory WorkoutSummairesListModel.fromJson(Map<String, dynamic> jsonData) {
    return WorkoutSummairesListModel(
      summaries: jsonData['workout_summaries'],
    );
  }
}
