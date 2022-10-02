import 'package:gym_project/models/admin-models/branches/branch-model.dart';

class Branches {
  final List<dynamic> branches;

  Branches({this.branches});

  factory Branches.fromJson(Map<String, dynamic> jsonData) {
    return Branches(
      branches: jsonData['Branch'],
    );
  }
}
