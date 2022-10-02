import 'package:flutter/material.dart';
import 'package:gym_project/models/privatesession.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/services/private-session-webservice.dart';
import 'package:gym_project/viewmodels/private-session-view-model.dart';

enum LoadingStatus {
  Completed,
  Searching,
  Empty,
  Error,
}
var generalToken;

class PrivateSessionListViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.Empty;

  int lastPage;

  // ignore: deprecated_member_use
  List<PrivateSessionViewModel> privateSessions =
      // ignore: deprecated_member_use
      List<PrivateSessionViewModel>();
  PrivateSessionViewModel privateSession = PrivateSessionViewModel();
  // methods to fetch news
  Future<void> fetchListMyPrivateSessions(int page, String searchText) async {
    // print('welcome token! $tokenn');
    // print('currently here!');
    Tuple<int, List<PrivateSession>> result =
        await PrivateSessionWebService().getMyPrivateSessions(page, searchText);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();
    this.privateSessions = result.item2
        .map((privateSession) =>
            PrivateSessionViewModel(privateS: privateSession))
        .toList();
    this.lastPage = result.item1;
    if (this.privateSessions.isEmpty) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }

    notifyListeners();
  }

  Future<void> fetchListBookedPrivateSessions(
      String role, int page, String searchText) async {
    Tuple<int, List<PrivateSession>> result =
        await PrivateSessionWebService()
        .getBookedPrivateSessions(role, page, searchText);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();
    this.privateSessions = result.item2
        .map((privateSession) =>
            PrivateSessionViewModel(privateS: privateSession))
        .toList();
    this.lastPage = result.item1;
    if (this.privateSessions.isEmpty) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }

    notifyListeners();
  }

  Future<void> fetchListPrivateSessions(int page, String searchText) async {
    Tuple<int, List<PrivateSession>> result =
        await PrivateSessionWebService().getPrivateSessions(page, searchText);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();
    this.privateSessions = result.item2
        .map((privateSession) =>
            PrivateSessionViewModel(privateS: privateSession))
        .toList();
    this.lastPage = result.item1;
    if (this.privateSessions.isEmpty) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }

    notifyListeners();
  }

  Future<void> fetchListRequestedPrivateSessions(
      int page, String searchText) async {
    Tuple<int, List<PrivateSession>> result =
        await PrivateSessionWebService()
        .getRequestedPrivateSessions(page, searchText);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();
    this.privateSessions = result.item2
        .map((privateSession) =>
            PrivateSessionViewModel(privateS: privateSession))
        .toList();
    this.lastPage = result.item1;
    if (this.privateSessions.isEmpty) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }

    notifyListeners();
  }

  Future<void> fetchPrivateSession(
    int privateSessionId,
  ) async {
    print(privateSessionId);
    print('currently here!');
    // print('welcome token! $tokenn');
    PrivateSession _privateSession =
        await PrivateSessionWebService().getPrivateSessionDetails(
      privateSessionId,
    );
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();
    this.privateSession = PrivateSessionViewModel(privateS: _privateSession);
    print(privateSession.id);

    if (this.privateSession == null) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }

    notifyListeners();
  }

  Future<void> postPrivateSession(
    PrivateSession privateSession,
  ) async {
    // print('currently here!');
    bool status = await PrivateSessionWebService().postPrivateSession(
      privateSession,
    );
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();

    if (status == false) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }
    notifyListeners();
  }

  Future<void> editPrivateSession(
    PrivateSessionViewModel privateSession,
  ) async {
    // print('currently here!');
    bool status = await PrivateSessionWebService().editPrivateSession(
      privateSession,
    );
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();

    if (status == false) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }
    notifyListeners();
  }

  Future<void> deletePrivateSession(int sessionId) async {
    // print('currently here!');
    bool status =
        await PrivateSessionWebService().deletePrivateSession(sessionId);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();

    if (status == false) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }
    notifyListeners();
  }

  Future<void> requestPrivateSession(
    int sessionId,
  ) async {
    // print('currently here!');
    bool status = await PrivateSessionWebService().requestSession(sessionId);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();

    if (status == false) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }
    notifyListeners();
  }

  Future<void> cancelPrivateSession(
    int sessionId,
  ) async {
    // print('currently here!');
    bool status = await PrivateSessionWebService().cancelSession(sessionId);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();

    if (status == false) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }
    notifyListeners();
  }

  Future<void> acceptPrivateSession(
    PrivateSessionViewModel privateSession,
  ) async {
    // print('currently here!');
    bool status =
        await PrivateSessionWebService().acceptSession(privateSession);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();

    if (status == false) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }
    notifyListeners();
  }

  Future<void> rejectPrivateSession(
    PrivateSessionViewModel privateSession,
  ) async {
    // print('currently here!');
    bool status =
        await PrivateSessionWebService().rejectSession(privateSession);
    loadingStatus = LoadingStatus.Searching;
    notifyListeners();

    if (status == false) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }
    notifyListeners();
  }
}
