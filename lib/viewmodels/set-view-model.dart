import 'package:gym_project/models/exercise.dart';
import 'package:gym_project/models/set.dart';

class SetViewModel {
  Set set = Set();

  SetViewModel({Set set}) : this.set = set;

  String get title {
    return set.title;
  }

  int get id {
    return set.id;
  }

  String get description {
    return set.description;
  }

  String get breakDuration => set.breakDuration;
  set breakDuration(String breakDuration) => set.breakDuration = breakDuration;

  int get coachId {
    return set.coachId;
  }

  String get coachName {
    return set.coachName;
  }

  List<Exercise> get exercises {
    return set.exercises;
  }

  int get order {
    return set.order;
  }

  String toString() {
    return set.toString();
  }
}
