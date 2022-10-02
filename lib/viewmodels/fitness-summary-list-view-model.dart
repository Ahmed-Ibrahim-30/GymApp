import 'package:flutter/material.dart';
import 'package:gym_project/models/fitness-summary.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/services/fitness-summary-web-service.dart';
import 'package:gym_project/viewmodels/fitness-summary-view-model.dart';

enum LoadingStatus {
  Completed,
  Searching,
  Empty,
}

class FitnessSummaryListViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.Empty;

  // ignore: deprecated_member_use
  List<FitnessSummaryViewModel> fitnessSummaries =
      List<FitnessSummaryViewModel>();
  FitnessSummaryViewModel fitnessSummary = FitnessSummaryViewModel();
  int lastPage;

  // methods to fetch news
  Future<void> fetchListFitnessSummaries(
      int page, String startDate, String endDate) async {
    Tuple<int, List<FitnessSummary>> result = await FitnessSummaryWebService()
        .getFitnessSummaries(page, startDate, endDate);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();
    this.fitnessSummaries = result.item2
        .map((fitnessSummary) => FitnessSummaryViewModel(f: fitnessSummary))
        .toList();
    this.lastPage = result.item1;

    if (this.fitnessSummaries == null) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }

    notifyListeners();
  }

  Future<void> fetchFitnessSummary(int fitnessId) async {
    FitnessSummary result =
        await FitnessSummaryWebService().getFitnessSummary(fitnessId);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();
    this.fitnessSummary = FitnessSummaryViewModel(f: result);

    if (this.fitnessSummary == null) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }

    notifyListeners();
  }

  Future<void> deleteFitnessSummary(int fitnessId) async {
    bool result =
        await FitnessSummaryWebService().deleteFitnessSummary(fitnessId);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();

    if (result == false) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }

    notifyListeners();
  }

  Future<void> postFitnessSummary(FitnessSummary fitSum) async {
    bool result = await FitnessSummaryWebService().postFitnessSummary(fitSum);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();

    if (result == false) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }

    notifyListeners();
  }
}
