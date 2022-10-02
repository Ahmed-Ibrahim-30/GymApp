import 'package:gym_project/all_data.dart';
import 'package:gym_project/models/user/user_model.dart';
import 'package:gym_project/widget/global.dart';
import 'package:intl/intl.dart';

import '../services/answers-webservice.dart';
import 'answer.dart';

class Question {
  int id;
  int index;
  User user;
  String title;
  String body;
  String date;
  List<Answer>allAnswers=[];

  Question.fromJson(Map<String, dynamic> jsonData) {
    id= jsonData['id'];
    index=questionsList.length;
    title= jsonData['title'];
    body= jsonData['body'];
    date= jsonData['updated_at'];
    date =
    DateFormat('yyyy-MM-dd')
        .format(DateTime.parse(date).add(Duration(hours: 2))) +
        ' at ' + DateFormat('kk:mm a').format(DateTime.parse(date).add(Duration(hours: 2)));




    int user_id=jsonData['user_id'];
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
  }
}
