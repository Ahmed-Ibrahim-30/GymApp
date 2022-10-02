import 'dart:convert';

class WorkoutSummary {
  final int id;
  final int member_id;
  final DateTime date;
  final double cal_burnt;
  final String duration;

  WorkoutSummary({
    this.id,
    this.member_id,
    this.date,
    this.cal_burnt,
    this.duration,
  });

  factory WorkoutSummary.fromJson(Map<String, dynamic> jsonData) {
    return WorkoutSummary(
      id: jsonData['id'],
      cal_burnt: jsonData['calories_burnt'],
      duration: jsonData['duration'],
      member_id: jsonData['member_id'],
      date: DateTime.parse(jsonData['date']),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "duration": duration,
        "calories_burnt": cal_burnt,
        "date": date,
      };

  Map<String, Object> toMap({bool forCreation = false}) {
    Map<String, Object> mappedWorkoutSummary = {
      'calories_burnt': cal_burnt,
      'date': date.toString().split(' ').first,
      'duration': duration,
    };
    if (!forCreation) {
      mappedWorkoutSummary.addEntries([
        MapEntry('id', id),
        MapEntry('member_id', member_id),
      ]);
    }
    return mappedWorkoutSummary;
  }
}
