import 'package:gym_project/viewmodels/exercise-view-model.dart';

import 'admin-models/equipments/equipment-model.dart';

class Exercise {
  int id;
  String title;
  String description;
  String duration;
  String gif;
  double calBurnt;
  int reps;
  String image;
  Equipment equipment;
  String coachName;
  int coachId;
  int order;
  Exercise({
    this.id,
    this.title,
    this.description,
    this.duration,
    this.gif,
    this.calBurnt,
    this.reps,
    this.image,
    this.coachId,
    this.coachName,
    this.equipment,
    this.order,
  });

  Map<String, Object> toMap() {
    return {
      //id wouldn't be set if the exercise is still being created (sent in post request)
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'gif': gif,
      'calBurnt': calBurnt,
      'reps': reps,
      'image': image,
      'coachId': coachId,
      'coachName': coachName,
      'equipment': equipment,
      'order': order,
    };
  }

  String toString() {
    return toMap().toString();
  }

  factory Exercise.fromJson(Map<String, dynamic> json, {int order}) {
    return Exercise(
      id: int.parse(json['id'].toString()),
      title: json['title'].toString(),
      description: json['description'].toString(),
      duration: json['duration'].toString(),
      gif: json['gif'].toString(),
      calBurnt: double.parse(json['cal_burnt'].toString()),
      reps: int.parse(json['reps'].toString()),
      image: json['image'].toString(),
      coachId: int.parse(json['coach_id'].toString()),
      coachName: json['name'].toString() ?? '',
      order: order,
    );
  }
  factory Exercise.detailsfromJson(Map<String, dynamic> json) {
    // print(json);
    return Exercise(
      id: int.parse(json['id'].toString()),
      title: json['title'].toString(),
      description: json['description'].toString(),
      equipment: Equipment.fromJson(json['equipments'][0]),
      duration: json['duration'].toString(),
      gif: json['gif'].toString(),
      calBurnt: double.parse(json['cal_burnt'].toString()),
      reps: int.parse(json['reps'].toString()),
      image: json['image'].toString(),
      coachId: int.parse(json['coach_id'].toString()),
      coachName: json['name'].toString() ?? '',
    );
  }

  ExerciseViewModel toExerciseViewModel() {
    return ExerciseViewModel(e: this);
  }
}
