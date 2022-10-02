import 'package:gym_project/all_data.dart';
import 'package:gym_project/models/user/member_model.dart';
import '../../user/nutritionist_model.dart';

class NutritionistSession {
  int id=0;
  int index;
  Member member;
  Nutritionist nutritionist;
  String date;

  NutritionistSession.fromJson(Map<String, dynamic> jsonData) {
    id= jsonData['id'];
    date= jsonData['date'];
    index=nutritionistSessions.length;
    int member_id=jsonData['member_id'];
    for(int i=0;i<membersUsers.length;i++){
      if(membersUsers[i].id==member_id){
        member=membersUsers[i];
        break;
      }
    }
    int nutritionist_id=jsonData['nutritionist_id'];
    for(int i=0;i<nutritionistsUsers.length;i++){
      if(nutritionistsUsers[i].id==nutritionist_id){
        nutritionist=nutritionistsUsers[i];
        break;
      }
    }
  }

}
