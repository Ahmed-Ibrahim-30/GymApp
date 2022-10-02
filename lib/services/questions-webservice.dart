import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/question.dart';
import 'package:gym_project/widget/global.dart';
import 'package:http/http.dart' as http;

import '../models/answer.dart';
import 'answers-webservice.dart';

String token = Global.token;
final local = Constants.defaultUrl;

class QuestionsWebservice {
  //get all questions
  static Future<void> fetchQuestions() async {
    await http.get(Uri.parse('$local/api/questions'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Global.token}'
    }).then((value) async {
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        jsonData['questions'].forEach((item) async {
          Question question=Question.fromJson(item);
          questionsList.add(question);
          await AnswersWebservice.fetchAnswers(question.id,question.index);
          print("length = ${questionsList[question.index].allAnswers.length}  and ${question.user.name} ");

        });
      }
    }).catchError((error){
      print('fetch Questions error = ${error.toString()}');
    });
  }

  //get question by id
  Future<Question> fetchQuestionById(int id) async {
    final response =
        await http.get(Uri.parse('$local/api/questions/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      Question question = Question.fromJson(jsonData['question']);
      return question;
    } else {
      throw Exception('Failed to download question');
    }
  }

  //add question
  static Future<void> postQuestion({
    @required String title,
    @required String body,
    @required AdminCubit adminCubit,
    @required CreateCubit createCubit,
    @required BuildContext context,
}) async {
    createCubit.loading1();
    await http.post(
      Uri.parse('$local/api/questions/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
      }),
    ).then((value){
      var jsonData = jsonDecode(value.body);
      print(jsonData);
      if(jsonData['status']==true){
        questionsList.add(Question.fromJson(jsonData['newQuestion']));
        createCubit.finishLoading();
        Navigator.pop(context);
        myToast(message: "Added Successfully",color: Colors.green);
        adminCubit.updateState();
      }
    }).catchError((error){
      print("add Question error = ${error.toString()}");
      myToast(message: "Added Failed",color: Colors.red);
      Navigator.pop(context);
      adminCubit.updateState();
      createCubit.finishLoading();
    });
  }

  //edit question
  static Future<void> editQuestion({
    @required int id,
    @required int index,
    @required String title,
    @required String body,
    @required AdminCubit adminCubit,
    @required CreateCubit createCubit,
    @required BuildContext context,
}) async {
    createCubit.loading1();
    await http.post(
      Uri.parse('$local/api/questions/edit/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
      }),
    ).then((value) {
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        questionsList[index].title=title;
        questionsList[index].body=body;
        Navigator.pop(context);
        createCubit.finishLoading();
        adminCubit.updateState();
        myToast(message: "Updated Successfully",color: Colors.green);
      }
    }).catchError((error){
      print("update Question error = ${error.toString()}");
      Navigator.pop(context);
      createCubit.finishLoading();
      myToast(message: "Updated Failed",color: Colors.green);
    });
  }

  //delete question
  static Future<void> deleteQuestion({
    @required int id,
    @required int index,
    @required AdminCubit adminCubit,
    @required CreateCubit createCubit,
    @required BuildContext context,
}) async {
    createCubit.loading2();
    await http.delete(
      Uri.parse('$local/api/questions/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    ).then((value) {
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        questionsList.removeAt(index);
        for(int i=0;i<questionsList.length;i++){
          questionsList[i].index=i;
        }
        createCubit.finishLoading();
        adminCubit.updateState();
        Navigator.pop(context);
        myToast(message: "Deleted Successfully",color: Colors.green);
      }
    }).catchError((error){
      print("delete questions error = ${error.toString()}");
      myToast(message: "Deleted Failed",color: Colors.red);
      Navigator.pop(context);
      createCubit.finishLoading();
    });
  }
}
