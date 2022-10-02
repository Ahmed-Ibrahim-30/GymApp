class Event {
  String title;
  String description;
  String startTime;
  String endTime;
  int ticketsAvailable;
  String price;
  String status;
  int id;


  Event({this.title, this.description, this.price,this.startTime,this.endTime,this.ticketsAvailable=10000,this.status='',this.id});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      description: json['description'],
      price: json['price'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      ticketsAvailable: json['tickets_available'],
      status: json['status'],
      id:json['id']
    );
  }
}
