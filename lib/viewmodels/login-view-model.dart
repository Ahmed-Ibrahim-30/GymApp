import 'package:flutter/material.dart';
import 'package:gym_project/models/exercise.dart';
import 'package:gym_project/models/login.dart';
import 'package:gym_project/services/login-auth-webservice.dart';

import '../helper/shared_preferrnce_helper.dart';
import 'exercise-view-model.dart';

enum LoadingStatus {
  Completed,
  Searching,
  Empty,
}
LoadingStatus loadingStatus = LoadingStatus.Empty;

class LoginViewModel with ChangeNotifier {
  Login login ;

  String get token {
    return login.token;
  }

  String get role {
    return login.role;
  }

  String get name {
    return login.name;
  }

  int get id {
    return login.id;
  }

  int get roleID {
    return login.roleID;
  }

  String get username {
    return login.name;
  }



  Future<void> fetchLogin(String email, String password) async {
    loadingStatus = LoadingStatus.Searching;
    login = await LoginAuthWebService().postLogin(email, password);
    notifyListeners();
  }

  Future<void> fetchLogout() async {
    SharedCache.removeData(key: 'token');
    SharedCache.removeData(key: 'role');
    SharedCache.removeData(key: 'id');
    SharedCache.removeData(key: 'name');
    SharedCache.removeData(key: 'email');
    SharedCache.removeData(key: 'roleID');
    bool status = await LoginAuthWebService().postLogout();
    loadingStatus = LoadingStatus.Searching;

    if (!status) {
      loadingStatus = LoadingStatus.Empty;
    } else {
      loadingStatus = LoadingStatus.Completed;
    }
    notifyListeners();
  }
}
