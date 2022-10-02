import 'package:gym_project/constants.dart';
import 'package:gym_project/helper/shared_preferrnce_helper.dart';

class Login {
  String token = '';
  String role = '';
  String name = '';
  int id = 0;
  int roleID = 0;
  String email = '';


   Login.fromJson(Map<String, dynamic> json,String email) {
    token= json['token'];
    role= json['role'];
    name= json['name'];
    id= json['id'];
    roleID= json['role_id'];
    this.email= email;

    SharedCache.saveData(key: 'token', value: token);
    SharedCache.saveData(key: 'role', value: role);
    SharedCache.saveData(key: 'name', value: name);
    SharedCache.saveData(key: 'id', value: id);
    SharedCache.saveData(key: 'roleID', value: roleID);
    SharedCache.saveData(key: 'email', value: email);
  }
}
