class FitnessSummary {
  int id;
  // ignore: non_constant_identifier_names
  double BMI;
  double weight;
  double muscleRatio;
  double height;
  double fatRatio;
  double fitnessRatio;
  double totalBodyWater;
  double dryLeanBath;
  double bodyFatMass;
  double opacityRatio;
  double protein;
  // ignore: non_constant_identifier_names
  double SMM;
  String updatedAt;
  String memberName;
  int memberId;

  FitnessSummary({
    this.id,
    this.BMI,
    this.SMM,
    this.bodyFatMass,
    this.dryLeanBath,
    this.fatRatio,
    this.fitnessRatio,
    this.height,
    this.muscleRatio,
    this.opacityRatio,
    this.protein,
    this.totalBodyWater,
    this.weight,
    this.updatedAt,
    this.memberName,
    this.memberId,
  });

  factory FitnessSummary.fromJson(Map<String, dynamic> json) {
    return FitnessSummary(
      id: int.parse(json['id'].toString()),
      BMI: double.parse(json['BMI'].toString()),
      weight: double.parse(json['weight'].toString()),
      muscleRatio: double.parse(json['muscle_ratio'].toString()),
      height: double.parse(json['height'].toString()),
      fatRatio: double.parse(json['fat_ratio'].toString()),
      fitnessRatio: double.parse(json['fitness_ratio'].toString()),
      totalBodyWater: double.parse(json['total_body_water'].toString()),
      dryLeanBath: double.parse(json['dry_lean_bath'].toString()),
      bodyFatMass: double.parse(json['body_fat_mass'].toString()),
      opacityRatio: double.parse(json['opacity_ratio'].toString()),
      protein: double.parse(json['protein'].toString()),
      SMM: double.parse(json['SMM'].toString()),
      updatedAt: json['updated_at'].toString(),
      memberName: json['name'].toString() ?? '',
      memberId: int.parse(json['member_id'].toString()),
    );
  }
}
