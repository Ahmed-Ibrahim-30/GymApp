import 'package:flutter/cupertino.dart';
import 'package:gym_project/models/admin-models/branches/branch-model.dart';
import 'package:gym_project/models/admin-models/branches/branches-list-model.dart';
import 'package:gym_project/models/workout-summary.dart';
import 'package:gym_project/services/admin-services/branches-services.dart';
import 'package:gym_project/services/workout-summary-web-services.dart';

class WorkoutSummaryViewModel extends ChangeNotifier {
  List<WorkoutSummary> _summariesList = [];

  Future<List<WorkoutSummary>> fetchSummaries() async {
    _summariesList = await WorkoutSummaryServices().fetchSummaries();
    notifyListeners();
    return _summariesList;
  }

  Future<void> postWorkoutSummary(
    WorkoutSummary workoutSummary,
    String token,
  ) async {
    WorkoutSummary workoutSummaryModel = await WorkoutSummaryServices()
        .postWorkoutSummary(workoutSummary, token);

    // TODO: add the workout summaries to the workout summaries list after creation
    notifyListeners();
  }

  List<WorkoutSummary> get branchesList => _summariesList;
}
