class WorkoutSummary {
  int id;
  // ignore: non_constant_identifier_names
  int cal_burnt;
  String date;
  String duration;
  // ignore: non_constant_identifier_names
  int member_id;

  WorkoutSummary({
    this.id,
    // ignore: non_constant_identifier_names
    this.cal_burnt,
    this.date,
    this.duration,
    // ignore: non_constant_identifier_names
    this.member_id,
  });

  Map<String, Object> toMap({bool forCreation = false}) {
    Map<String, Object> mappedWorkoutSummary = {
      'calories_burnt': cal_burnt,
      'date': date,
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

  factory WorkoutSummary.fromJson(Map<String, dynamic> jsonData) {
    return WorkoutSummary(
      id: jsonData['id'],
      cal_burnt: jsonData['cal_burnt'],
      duration: jsonData['duration'],
      member_id: jsonData['member_id'],
    );
  }
}
