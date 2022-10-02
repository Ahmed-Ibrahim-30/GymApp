class PrivateSession {
  int id;
  String title;
  String description;
  String duration;
  String link;
  double price;
  int coachId;
  String coachName;
  String status;
  String memberName;
  String dateTime;
  String name;

  PrivateSession({
    this.id,
    this.title,
    this.description,
    this.duration,
    this.link,
    this.price,
    this.coachId,
    this.coachName,
    this.status,
    this.memberName,
    this.dateTime,
    this.name,
  });

  factory PrivateSession.fromJson(Map<String, dynamic> json) {
    return PrivateSession(
      id: int.parse(json['id'].toString()),
      title: json['title'].toString(),
      description: json['description'].toString(),
      duration: json['duration'].toString(),
      link: json['link'].toString(),
      price: double.parse(json['price'].toString()),
      coachId: int.parse(json['coach_id'].toString()),
      coachName: json['name'].toString(),
    );
  }
  factory PrivateSession.fromJsonwithDate(Map<String, dynamic> json) {
    return PrivateSession(
      id: int.parse(json['id'].toString()),
      title: json['title'].toString(),
      description: json['description'].toString(),
      duration: json['duration'].toString(),
      link: json['link'].toString(),
      price: double.parse(json['price'].toString()),
      coachId: int.parse(json['coach_id'].toString()),
      status: json['status'].toString(),
      dateTime: json['datetime'].toString() ?? '',
      name: json['name'].toString(),
    );
  }
  factory PrivateSession.fromJsonAdmin(Map<String, dynamic> json) {
    return PrivateSession(
      id: int.parse(json['id'].toString()),
      title: json['title'].toString(),
      description: json['description'].toString(),
      duration: json['duration'].toString(),
      link: json['link'].toString(),
      price: double.parse(json['price'].toString()),
      coachId: int.parse(json['coach_id'].toString()),
      status: json['status'].toString(),
      memberName: json['name'].toString(),
    );
  }
}
