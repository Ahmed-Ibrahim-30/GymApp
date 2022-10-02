import 'dart:io';

class User {
  int user_id; //user id
  int index;
  int databaseID; //id
  String name;
  String number;
  String email;
  String role;
  String gender;
  int weight;
  int height;
  int calories;
  int age;
  int activity_level;
  File photo;
  String bio;
  int branchId;
  String Protein;
  String Carbs;
  String Fats;

  User({
    this.user_id,
    this.index,
    this.name,
    this.email,
    this.number,
    this.gender,
    this.role,
    this.photo,
    this.bio,
    this.branchId,
    this.weight,
    this.height,
    this.calories,
    this.age,
    this.activity_level,
    this.Protein,
    this.Carbs,
    this.Fats
  });
  @override
  String toString() {
    return 'User{id: $user_id, name: $name, email: $email, role: $role,}';
  }

}
