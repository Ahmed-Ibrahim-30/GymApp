import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/models/question.dart';
import 'package:gym_project/widget/answer-textfield.dart';
import 'package:gym_project/widget/delete-iconbutton.dart';
import 'package:gym_project/widget/edit-iconbutton.dart';
import 'package:provider/provider.dart';

class AnswersListTile extends StatefulWidget {
  final String username;
  final String body;
  final String date;
  final String role;
  final int id;
  final Question question;

  AnswersListTile({
    this.username,
    this.body,
    this.date,
    this.role,
    this.id,
    this.question,
  });
  @override
  _AnswersListTileState createState() => _AnswersListTileState();
}

class _AnswersListTileState extends State<AnswersListTile> {
  bool is_visible;
  bool edit;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    is_visible = true;
    edit = false;
    _textController.text = widget.body;
  }





  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: is_visible,
      child: Container(
        margin: EdgeInsetsDirectional.only(bottom: 10),
        child: !edit
            ? ListTile(
                isThreeLine: true,
                minVerticalPadding: 10,
                title: Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.account_circle),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.username,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                widget.date,
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 12,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      (widget.role == "answer_owner" || widget.role == "admin")
                          ? Container(
                              padding: EdgeInsets.only(right: 4),
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DeleteIconButton(
                                    context: context,
                                    text:
                                        'Would you like to delete this answer ?',
                                    onDelete: () {

                                    }
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.04,
                                  ),
                                  EditIconButton(
                                    onPressed: () {

                                    }
                                  )
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: "Answer : ",
                            style: TextStyle(color: Colors.tealAccent, fontSize: 20.sp,fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(text: "${widget.body}", style: TextStyle(fontFamily: 'assets/fonts/Changa-Bold.ttf',color: Colors.grey,fontSize: 15.sp)),
                            ]
                        )
                    ),
                  ],
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: AnswerTextField(
                      controller: _textController,
                      id: widget.id,
                      question: widget.question,
                      type: 'edit',
                      onEdit: () {}
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
