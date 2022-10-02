import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/models/question.dart';
import 'package:gym_project/models/user/user_model.dart';
import 'package:gym_project/screens/answers/answers-list-tile.dart';
import 'package:gym_project/screens/questions/questions-list-tile.dart';
import 'package:gym_project/widget/answer-textfield.dart';
import 'package:gym_project/widget/global.dart';
import 'package:provider/provider.dart';

import '../../bloc/Admin_cubit/admin_states.dart';
import '../../constants.dart';

class SingleQuestionScreen extends StatefulWidget {
  final int questionIndex;
  final String role;

  SingleQuestionScreen({this.questionIndex, this.role});

  @override
  _SingleQuestionScreenState createState() => _SingleQuestionScreenState();
}

class _SingleQuestionScreenState extends State<SingleQuestionScreen> {
  final TextEditingController _textController = TextEditingController();
  Color iconColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print(questionsList[widget.question.index].allAnswers.length);
    //print(questionsList[widget.question.index].allAnswers[0].id);
    //print(questionsList[widget.question.index].allAnswers[1].id);
    iconColor = Colors.grey;
  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit adminCubit=AdminCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Answers',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xff181818),
            iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
          ),
          body: SafeArea(
            child: Container(
              color: myBlack,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              child: questionsList[widget.questionIndex].id != null
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QuestionsListTile(
                    num_of_answers: questionsList[widget.questionIndex].allAnswers.length,
                    index: questionsList[widget.questionIndex].index,
                    role: widget.role,
                    viewAnswersButton: false,
                  ),
                  Container(
                    color:CupertinoColors.white,
                    width: 80.w,
                    height: 2.h,
                  ),
                  SizedBox(height: 20.h,),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Column(children: [
                          AnswersListTile(
                            username: questionsList[widget.questionIndex].allAnswers[index].user.name,
                            body: questionsList[widget.questionIndex].allAnswers[index].body,
                            date: questionsList[widget.questionIndex].allAnswers[index].date,
                            role: questionsList[widget.questionIndex].allAnswers[index].user.user_id ==
                                Global.id
                                ? 'answer_owner'
                                : widget.role,
                            id: questionsList[widget.questionIndex].allAnswers[index].id,
                            question:  questionsList[widget.questionIndex],
                          ),
                          index < questionsList[widget.questionIndex].allAnswers.length - 1
                              ? Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                          )
                              : Container(),
                        ]);
                      },
                      itemCount: questionsList[widget.questionIndex].allAnswers.length,
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: AnswerTextField(
                          controller: _textController,
                          question:  questionsList[widget.questionIndex],
                          type: 'add',
                          adminCubit:adminCubit
                        ),
                      ),
                    ],
                  ),
                ],
              )
                  : Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFFFFCE2B),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
