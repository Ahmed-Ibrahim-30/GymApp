import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_project/helper/constants.dart';
import 'package:gym_project/models/nutritionist/plan.dart';
import 'package:gym_project/models/nutritionist/plans.dart';
import 'package:gym_project/services/nutritionist/plan-webservice.dart';

class PlanViewModel with ChangeNotifier {
  Plan plan = Plan(title: "Nice");
  LoadingStatus loadingStatus = LoadingStatus.Completed;

  String get title {
    return plan.title;
  }

  String get description {
    return plan.description;
  }

  int get nutritionistID {
    return plan.nutritionistID;
  }

  int get id {
    return plan.id;
  }

  Future<Plan> fetchPlan(int planID, context) async {
    plan = await PlanWebService().getPlan(planID, context);

    notifyListeners();

    return plan;
  }

  Future<Plan> fetchActivePlan(int memberID, context) async {
    plan = await PlanWebService().getActivePlan(memberID, context);

    notifyListeners();

    return plan;
  }

  Future<bool> deletePlan(context, int planID) async {
    var finished = await PlanWebService().deletePlan(context, planID);

    notifyListeners();

    return finished;
  }

  Future<bool> deleteActivePlan(int memberID, context) async {
    bool finished = await PlanWebService().deleteActivePlan(memberID, context);

    notifyListeners();

    return finished;
  }

  Future<bool> assignActivePlan(
      int memberID, context, int planID, String duration) async {
    bool finished = await PlanWebService().assignActivePlan(
        memberID,
        context,
        jsonEncode({
          'plan_id': planID,
          'duration': duration,
        }));

    notifyListeners();

    return finished;
  }

  ///////////////////////////
  ///
  Plans plans = Plans(data: []);

  List<Plan> get data {
    return plans.data;
  }

  Future<Plans> fetchPlans(context,
      {String searchText = '', int currentPage = 1}) async {
    plans = await PlanWebService().getPlans(context, searchText, currentPage);

    notifyListeners();

    return plans;
  }

  Future<void> postPlan(Plan plan, String token) async {
    loadingStatus = LoadingStatus.Searching;
    Plan planModel = await PlanWebService().postPlan(plan, token);
    plans.data.add(planModel);
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }

  Future<void> putPlan(Plan plan, String token) async {
    loadingStatus = LoadingStatus.Searching;
    Plan planModel = await PlanWebService().putPlan(plan, token);
    int updatedPlanIndex = plans.data.indexWhere((p) => p.id == plan.id);
    plans.data.removeAt(updatedPlanIndex);
    plans.data.insert(updatedPlanIndex, planModel);
    loadingStatus = LoadingStatus.Completed;
    notifyListeners();
  }
}
