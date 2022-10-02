import 'package:gym_project/models/exercise.dart';

import '../models/admin-models/equipments/equipment-model.dart';

class ExerciseViewModel {
  Exercise exercise = Exercise();

  ExerciseViewModel({Exercise e}) : exercise = e;

  Map<String, Object> toMap() {
    return exercise.toMap();
  }

  String toString() {
    return exercise.toString();
  }

  String get title {
    return exercise.title;
  }

  set title(title) {
    exercise.title = title;
  }

  String get gif {
    return exercise.gif;
  }

  set gif(gif) {
    exercise.gif = gif;
  }

  int get id {
    return exercise.id;
  }

  set id(id) {
    exercise.id = id;
  }

  String get description {
    return exercise.description;
  }

  set description(description) {
    exercise.description = description;
  }

  int get reps {
    return exercise.reps;
  }

  set reps(reps) {
    exercise.reps = reps;
  }

  String get duration {
    return exercise.duration;
  }

  set duration(duration) {
    exercise.duration = duration;
  }

  double get calBurnt {
    return exercise.calBurnt;
  }

  set calBurnt(calBurnt) {
    exercise.calBurnt = calBurnt;
  }

  String get image {
    return exercise.image;
  }

  set image(image) {
    exercise.image = image;
  }

  int get coachId {
    return exercise.coachId;
  }

  set coachId(coachId) {
    exercise.coachId = coachId;
  }

  Equipment get equipment {
    return exercise.equipment;
  }

  set equipment(equipment) {
    exercise.equipment = equipment;
  }

  String get coachName {
    return exercise.coachName;
  }

  set coachName(coachName) {
    exercise.coachName = coachName;
  }

  int get order {
    return exercise.order;
  }

  set order(order) {
    exercise.order = order;
  }
}
