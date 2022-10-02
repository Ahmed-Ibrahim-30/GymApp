import 'package:gym_project/models/user/coach_model.dart';
import 'package:gym_project/models/user/member_model.dart';
import '../all_data.dart';

class  Classes {
  int id;
  int index;
  String description;
  String title;
  String link;
  String level;
  int capacity;
  String price;
  String duration;
  String date;
  List<Member> allMembers = [];
  List<Coach> allCoaches = [];
  Classes.fromJsonAdd(Map<String, dynamic> json) {
    id= json['class']['id'] is String ?int.parse(json['class']['id']):json['class']['id'];
    index=allClasses.length;
    description= "${json['class']['description']}";
    title= "${json['class']['title']}";
    link ="${json['class']['link']}";
    level= "${json['class']['level']}";
    capacity= json['class']['capacity'] is String ?int.parse(json['class']['capacity']):json['class']['capacity'];
    price= "${json['class']['price']}";
    duration= "${json['class']['duration']}";
    date= "${json['class']['date']}";
  }
  Classes.fromJson(Map<String, dynamic> json, {bool isFetchAll=false}) {
    id= json['id'] is String ?int.parse(json['id']):json['id'];
    index=allClasses.length;
    description= "${json['description']}";
    title= "${json['title']}";
    link ="${json['link']}";
    level= "${json['level']}";
    capacity= json['capacity'] is String ?int.parse(json['capacity']):json['capacity'];
    price= "${json['price']}";
    duration= "${json['duration']}";
    date= "${json['date']}";
    if(isFetchAll){
      json['coaches'].forEach((item){
        int coach_id=item['id'];
        for(int i=0;i<coachesUsers.length;i++){
          if(coach_id==coachesUsers[i].id){
            allCoaches.add(coachesUsers[i]);
            break;
          }
        }
      });
      json['members'].forEach((item){
        int member_id=item['id'];
        for(int i=0;i<membersUsers.length;i++){
          if(member_id==membersUsers[i].id){
            allMembers.add(membersUsers[i]);
            break;
          }
        }
      });
    }
  }
}


