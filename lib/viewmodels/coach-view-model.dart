import 'package:flutter/material.dart';
import 'package:gym_project/models/classes.dart';
import 'package:gym_project/models/event.dart';
import 'package:gym_project/models/privatesession.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/services/user_services/coach-webservice.dart';

enum LoadingStatus {
  Completed,
  Searching,
  Empty,
}

class CoachViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.Empty;

  // ignore: deprecated_member_use
  Tuple2<List<PrivateSession>, List<Classes>, List<Event>> schedule = Tuple2();

  // methods to fetch news
  Future<void> fetchSchedule() async {
    schedule = await CoachWebService().fetchSchedule();
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();

    if (this.schedule == null) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }

    notifyListeners();
  }
}
