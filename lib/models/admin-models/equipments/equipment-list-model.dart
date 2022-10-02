import 'package:gym_project/models/admin-models/membership/membership-model.dart';

class Equipments {
  final List<dynamic> equipments;

  Equipments({this.equipments});

  factory Equipments.fromJson(Map<String, dynamic> jsonData) {
    return Equipments(
      equipments: jsonData['equipments'],
    );
  }
}
