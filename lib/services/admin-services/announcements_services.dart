import '../../bloc/Admin_cubit/admin_cubit.dart';
import '../../constants.dart';
import '../../models/announcement.dart';
import '../../viewmodels/announcement-view-model.dart';
import '../../widget/global.dart';
import 'package:http/http.dart' as http;
import '../../all_data.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_project/constants.dart';
import '../answers-webservice.dart';
class AnnouncementsServices{

  static Future<void> fetchAnnouncements() async {
    final String token = Global.token;
    final String local = Constants.defaultUrl;
    await http.get(Uri.parse('$local/api/announcements'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }).then((value) {
      var jsonData = jsonDecode(value.body);
      jsonData['announcments'].forEach((item){
        announcementsList.add(AnnouncementViewModel(announcement: Announcement.fromJson(item)));
      });
    }).catchError((error){
      print(error.toString());
    });
  }
  //delete announcement
  static void deleteAnnouncement(int id,{@required AdminCubit adminCubit,}) {
    http.delete(
      Uri.parse('$local/api/announcements/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Global.token}'
      },
    ).then((value){
      var item=announcementsList.where((element) => element.id==id);
      announcementsList.remove(item.elementAt(0));
      adminCubit.deleteAnnouncementsSuccess();
    }).catchError((error){
      print(error.toString());
      adminCubit.deleteAnnouncementsError();
    });
  }
  //add announcement
  static void addAnnouncement(String title, String description, String date,{@required AdminCubit adminCubit,@required BuildContext context}) {
    print('adding announcement');
    http.post(
      Uri.parse('$local/api/announcements/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Global.token}'
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
        'datetime': date,
        'receiver_type': 'all'
      }),
    ).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      announcementsList.add(AnnouncementViewModel(announcement: Announcement.fromJson(jsonData['newAnnouncement'])));
      adminCubit.addAnnouncementsSuccess();
      Navigator.pop(context);
    }).catchError((error){
      print(error.toString());
      adminCubit.addAnnouncementsError();
      Navigator.pop(context);
    });
  }
  //edit announcement
  static editAnnouncement(int id, String title, String description, String date,BuildContext context,{@required AdminCubit adminCubit,}) {
    http.post(
      Uri.parse('$local/api/announcements/edit/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Global.token}'
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
        'datetime': date,
        'receiver_type': 'all'
      }),
    ).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      if(jsonData['msg']=='Announcement updated correctly'){
        for(int i=0;i<announcementsList.length;i++){
          if(announcementsList.elementAt(i).id==id){
            announcementsList[i]=AnnouncementViewModel(announcement: Announcement(title: title,date: date,description: description,id: id));
            break;
          }
        }
        Navigator.pop(context);
        adminCubit.editAnnouncementsSuccess();
      }
      else{
        myToast(message: "Update Failed",color: Colors.red);
        Navigator.pop(context);
        adminCubit.editAnnouncementsError();
      }
    }).catchError((error){
      print(error.toString());
      adminCubit.editAnnouncementsError();
      Navigator.pop(context);
    });
  }
}