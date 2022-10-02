import 'package:gym_project/models/question.dart';
import 'package:gym_project/models/user/user_model.dart';
import 'package:intl/intl.dart';

import '../all_data.dart';
import '../widget/global.dart';

class Answer {
  int id;
  String body;
  String date;
  User user;
  Question question;

  Answer.fromJson(Map<String, dynamic> jsonData) {
    int user_id,question_id;
    question_id= jsonData['question_id'];
    id= jsonData['id'];
    user_id= jsonData['user_id'];
    body= jsonData['body'];
    date= jsonData['updated_at'];
    date=
    DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(date).add(Duration(hours: 2))) +
    ' at ' +
    DateFormat('kk:mm a')
        .format(DateTime.parse(date).add(Duration(hours: 2)));


    bool isFound=false;
    if(user_id==Global.id){
      user=User(
        role: "admin",
        height: 0,
        bio: "admin",
        email: Global.email,
        name: Global.username,
        user_id: user_id,
      );
      isFound=true;
    }
    if(!isFound){
      for(int i=0;i<membersUsers.length;i++){
        if(user_id==membersUsers[i].user_id){
          user=membersUsers[i];
          isFound=true;
          break;
        }
      }
    }
    if(!isFound){
      for(int i=0;i<coachesUsers.length;i++){
        if(user_id==coachesUsers[i].user_id){
          user=coachesUsers[i];
          isFound=true;
          break;
        }
      }
    }
    if(!isFound){
      for(int i=0;i<nutritionistsUsers.length;i++){
        if(user_id==nutritionistsUsers[i].user_id){
          user=nutritionistsUsers[i];
          isFound=true;
          break;
        }
      }
    }
    if(!isFound){
      user=User(
        name: "Admin",
        user_id: user_id,
        role: 'admin',
      );
    }

    for(int i=0;i<questionsList.length;i++){
      if(question_id==questionsList[i].id){
        question=questionsList[i];
        break;
      }
    }
  }
}
