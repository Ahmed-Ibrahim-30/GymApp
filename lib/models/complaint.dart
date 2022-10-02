class Complaint {
  String title;
  String description;
  String type;
  String userName;
  int id;


  Complaint({this.title, this.description, this.type,this.userName,this.id});

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      title: json['title'],
      description: json['description'],
      type: json['type'],
      userName: json['user']['name'],
      id:json['id']
    );
  }
}
