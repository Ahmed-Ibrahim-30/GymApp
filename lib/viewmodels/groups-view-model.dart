import 'package:flutter/foundation.dart';
import 'package:gym_project/helper/general-helpers.dart';
import 'package:gym_project/models/exercise.dart';
import 'package:gym_project/models/group.dart';
import 'package:gym_project/models/set.dart';
import 'package:gym_project/viewmodels/exercise-view-model.dart';
import 'package:gym_project/viewmodels/set-view-model.dart';

class GroupViewModel {
  Group group;

  GroupViewModel({@required this.group});

  int get id => group.id;
  String get title => group.title;
  String get description => group.description;
  int get coachId => group.coachId;
  String get breakDuration => group.breakDuration;
  List<Exercise> get exercises => group.exercises;
  List<Set> get sets => group.sets;
  String get coachName => group.coachName;
  DateTime get date => group.date;

  List<ExerciseViewModel> get exercisesViewModels {
    return group.exercises.map((e) => ExerciseViewModel(e: e)).toList();
  }

  List<SetViewModel> get setsViewModels {
    return group.sets.map((s) => SetViewModel(set: s)).toList();
  }

  List<ExerciseViewModel> get allExercises {
    List<ExerciseViewModel> allExercises = [];
    exercises.sort((a, b) => a.order.compareTo(b.order));
    sets.sort((a, b) => a.order.compareTo(b.order));
    int exCount = 0, setCount = 0;
    for (int i = 0; i < exercises.length + sets.length; i++) {
      if (exCount == exercises.length) {
        Set currentSet = sets[setCount];
        List<ExerciseViewModel> setExercises = currentSet.exercises
            .map((exercise) => exercise.toExerciseViewModel())
            .toList();
        allExercises.addAll(setExercises);
        setCount++;
        continue;
      }
      if (setCount == sets.length) {
        Exercise currentExercise = exercises[exCount];
        allExercises.add(currentExercise.toExerciseViewModel());
        exCount++;
        continue;
      }
      Exercise currentExercise = exercises[exCount];
      Set currentSet = sets[setCount];
      if (currentExercise.order < currentSet.order) {
        allExercises.add(currentExercise.toExerciseViewModel());
        exCount++;
      } else {
        List<ExerciseViewModel> setExercises = currentSet.exercises
            .map((exercise) => exercise.toExerciseViewModel())
            .toList();
        allExercises.addAll(setExercises);
        setCount++;
      }
    }
    return allExercises;
  }

  set id(int id) => this.group.id = id;
  set title(String title) => this.group.title = title;
  set description(String description) => this.group.description = description;
  set coachId(int coachId) => this.coachId = coachId;
  set breakDuration(String breakDuration) =>
      this.group.breakDuration = breakDuration;
  set exercises(List<Exercise> exercises) => this.group.exercises = exercises;
  set sets(List<Set> sets) => this.group.sets = sets;
  set coachName(String coachName) => this.group.coachName = coachName;
  set date(DateTime date) => this.group.date = date;
  Map<String, Object> toMap() {
    return group.toMap();
  }

  String toString() {
    return group.toString();
  }
}
