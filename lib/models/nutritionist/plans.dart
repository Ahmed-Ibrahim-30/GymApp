import 'package:gym_project/models/nutritionist/plan.dart';

class Plans {
  List<Plan> data = [];

  Plans({this.data});

  factory Plans.fromJson(List<dynamic> json) {
    List<Plan> tempResult = [];
    for (var i = 0; i < json.length; i++) {
      Map<String, dynamic> entry = json[i] as Map<String, dynamic>;
      tempResult.add(Plan.fromJson(entry));
    }

    return Plans(
      data: tempResult,
    );
  }
}
