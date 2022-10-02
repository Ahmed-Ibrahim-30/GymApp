class Invitation {
  String guestName;
  String phoneNumber;
  String userName;
  int id;


  Invitation({ this.userName, this.guestName,this.phoneNumber,this.id});

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      guestName: json['name'],
      phoneNumber: json['number'],
      userName: json['user']['name'],
      id: json['id'],

    );
  }
}
