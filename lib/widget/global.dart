import 'package:flutter/cupertino.dart';

class Global with ChangeNotifier {
  static String _token;
  static String _adminToken;
  static String _userName;
  static String _email;
  static String _role;
  static int _id;
  static int _role_id;
  static void set_token(String s) {
    _token = s;
  }
  static void setAdminToken(String s) => _adminToken = s;
  static void setUserName(String name) => _userName = name;
  static void setEmail(String email) => _email = email;
  static void setRole(String role) {
    _role = role;
  }
  static void set_userId(int n) => _id = n;

  static void setRoleId(int value) {
    _role_id = value;
  }


  static int get roleID => _role_id;


  static String get token => _token;
  static String get adminToken => _adminToken;
  static String get username => _userName;
  static String get email => _email;
  static int get id => _id;
  static String get role => _role;
}
