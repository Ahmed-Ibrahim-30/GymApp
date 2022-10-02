import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/answer.dart';
import 'package:gym_project/models/question.dart';
import 'package:gym_project/widget/global.dart';
import 'package:http/http.dart' as http;

import '../all_data.dart';
import '../bloc/Admin_cubit/admin_cubit.dart';

String token = Global.token;
final local = Constants.defaultUrl;

class AnswersWebservice {
  //get all answers
  static Future<List<Answer>> fetchAllAnswers() async {
    final response = await http
        .get(Uri.parse('$local/api/answers'), headers: <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      Iterable list = jsonData['answers'];
      List<Answer> answers = list.map((e) => Answer.fromJson(e)).toList();
      return answers;
    } else {
      throw Exception('Failed to download answers');
    }
  }

  //get all answers of a certain question
  static Future<void> fetchAnswers(int question_id,int question_index) async {
    List<Answer>allAnswers=[];
    await http.get(
        Uri.parse('$local/api/questions/$question_id/answers'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }).then((value){
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        jsonData['answers'].forEach((item){
          allAnswers.add(Answer.fromJson(item));
        });
        questionsList[question_index].allAnswers.addAll(allAnswers);
      }
    }).catchError((error){
      print("get Questions Answers error = ${error.toString()}");
    });
  }

  //get answer by id
  static Future<Answer> fetchAnswerById(int id) async {
    final response =
        await http.get(Uri.parse('$local/api/answers/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['msg'] == 'There is no answer with this id') {}
      Answer answer = Answer.fromJson(jsonData['answer']);
      return answer;
    } else {
      throw Exception('Failed to download question');
    }
  }

  //add answer to a question
  static Future<void> postAnswer({
    @required Question question,
    @required String body,
    @required AdminCubit adminCubit
}) async {
    await http.post(
      Uri.parse('$local/api/answers/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'body': body,
        'question_id': question.id,
      }),
    ).then((value) {
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){
        questionsList[question.index].allAnswers.add(Answer.fromJson(jsonData['newAnswer']));
        adminCubit.updateState();
        myToast(message: "Added Successfully",color: Colors.green);
      }
    }).catchError((error){
      print("add answer error = ${error.toString()}");
    });
  }

  //edit answer
  static Future<void> editAnswer(int id, String body) async {
    print('editing answer');
    final response = await http.post(
      Uri.parse('$local/api/answers/edit/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'body': body,
      }),
    ).then((value) {
      var jsonData = jsonDecode(value.body);
      if(jsonData['status']==true){

        myToast(message: "Updated Successfully",color: Colors.green);
      }
    }).catchError((error){
      print("add answer error = ${error.toString()}");
    });
  }

  //delete answer
  static Future<void> deleteAnswer(int id) async {
    print('deleting answer');
    final response = await http.delete(
      Uri.parse('$local/api/answers/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
  }
}
