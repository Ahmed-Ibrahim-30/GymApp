import 'package:gym_project/all_data.dart';
import '../../user/member_model.dart';
import '../branches/branch-model.dart';

class Membership {
  int id;
  int index;
  String title;
  Branch branch;
  List<Member>allMembers=[];
  num duration;
  String description;
  num price;
  int limit_of_frozen_days;
  int available_classes;
  num discount;

  //jsonData['limit_of_frozen_days'];
  Membership.fromJson(Map<String, dynamic> jsonData,{bool isFetch=false}) {
    id= jsonData['id'];
    index=allMembers.length;
    title= jsonData['title'];
    duration= jsonData['duration'] is String ?num.parse(jsonData['duration']):jsonData['duration'];
    description= jsonData['description'];
    price= jsonData['price'] is String ?num.parse(jsonData['price']):jsonData['price'];
    limit_of_frozen_days= jsonData['limit_of_frozen_days'] is String? int.parse(jsonData['limit_of_frozen_days']):jsonData['limit_of_frozen_days'];
    available_classes= jsonData['available_classes'] is String ?int.parse(jsonData['available_classes']):jsonData['available_classes'];
    discount= jsonData['discount'] is String?num.parse(jsonData['discount']):jsonData['discount'];
    int branch_id=jsonData['branch_id'] is String ? int.parse(jsonData['branch_id']):jsonData['branch_id'];
    for(int i=0;i<branchesList.length;i++){
      if(branch_id==branchesList[i].id){
        branch=branchesList[i];
        break;
      }
    }
    if(isFetch){
      jsonData['members'].forEach((item){
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
