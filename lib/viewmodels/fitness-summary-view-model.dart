import 'package:gym_project/models/fitness-summary.dart';

class FitnessSummaryViewModel {
  FitnessSummary fitnessSummary = FitnessSummary();

  FitnessSummaryViewModel({FitnessSummary f}) : fitnessSummary = f;

  // double BMI;
  // double weight;
  // double muscleRatio;
  // double height;
  // double fatRatio;
  // double fitnessRatio;
  // double totalBodyWater;
  // double dryLeanBath;
  // double bodyFatMass;
  // double opacityRatio;
  // double protein;

  int get id {
    return fitnessSummary.id;
  }

  set id(id) {
    fitnessSummary.id = id;
  }

  int get memberId {
    return fitnessSummary.memberId;
  }

  set memberId(memberId) {
    fitnessSummary.memberId = memberId;
  }

  double get BMI {
    return fitnessSummary.BMI;
  }

  set BMI(BMI) {
    fitnessSummary.BMI = BMI;
  }

  double get SMM {
    return fitnessSummary.SMM;
  }

  set SMM(SMM) {
    fitnessSummary.SMM = SMM;
  }

  double get weight {
    return fitnessSummary.weight;
  }

  set weight(weight) {
    fitnessSummary.weight = weight;
  }

  double get muscleRatio {
    return fitnessSummary.muscleRatio;
  }

  set muscleRatio(muscleRatio) {
    fitnessSummary.muscleRatio = muscleRatio;
  }

  double get height {
    return fitnessSummary.height;
  }

  set height(height) {
    fitnessSummary.height = height;
  }

  double get fatRatio {
    return fitnessSummary.fatRatio;
  }

  set fatRatio(fatRatio) {
    fitnessSummary.fatRatio = fatRatio;
  }

  double get fitnessRatio {
    return fitnessSummary.fitnessRatio;
  }

  set fitnessRatio(fitnessRatio) {
    fitnessSummary.fitnessRatio = fitnessRatio;
  }

  double get totalBodyWater {
    return fitnessSummary.totalBodyWater;
  }

  set totalBodyWater(totalBodyWater) {
    fitnessSummary.totalBodyWater = totalBodyWater;
  }

  double get dryLeanBath {
    return fitnessSummary.dryLeanBath;
  }

  set dryLeanBath(dryLeanBath) {
    fitnessSummary.dryLeanBath = dryLeanBath;
  }

  double get bodyFatMass {
    return fitnessSummary.bodyFatMass;
  }

  set bodyFatMass(bodyFatMass) {
    fitnessSummary.bodyFatMass = bodyFatMass;
  }

  double get opacityRatio {
    return fitnessSummary.opacityRatio;
  }

  set opacityRatio(opacityRatio) {
    fitnessSummary.opacityRatio = opacityRatio;
  }

  double get protein {
    return fitnessSummary.protein;
  }

  set protein(protein) {
    fitnessSummary.protein = protein;
  }

  String get updatedAt {
    return fitnessSummary.updatedAt;
  }

  set updatedAt(updatedAt) {
    fitnessSummary.updatedAt = updatedAt;
  }

  String get memberName {
    return fitnessSummary.memberName;
  }

  set memberName(memberName) {
    fitnessSummary.memberName = memberName;
  }
}
