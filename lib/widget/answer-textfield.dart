import 'package:flutter/material.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/models/question.dart';
import '../all_data.dart';
import '../services/answers-webservice.dart';

class AnswerTextField extends StatefulWidget {
  //const AnswerTextField({ Key key }) : super(key: key);
  final TextEditingController controller;
  final Function onEdit;
  final int id;
  final Question question;
  final String type;
  final AdminCubit adminCubit;

  AnswerTextField(
      {this.controller, this.onEdit, this.id, this.question, this.type,this.adminCubit});

  @override
  _AnswerTextFieldState createState() => _AnswerTextFieldState();
}

class _AnswerTextFieldState extends State<AnswerTextField> {
  Color iconColor;
  bool edit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    edit = false;
    if (widget.controller.text.isEmpty)
      iconColor = Colors.grey;
    else
      iconColor = Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.type == 'edit' ? 8 : 1,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'assets/fonts/Changa-Bold.ttf',
        fontSize: 15,
      ),
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.amber),
        ),
        hintText: 'Write an answer...',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontFamily: 'assets/fonts/Changa-Bold.ttf',
          fontSize: 15,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.yellow),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.send,
            color: iconColor,
          ),
          onPressed: widget.controller.text.isEmpty
              ? null
              : () async {
                  if (widget.type == 'edit') {
                    await AnswersWebservice.editAnswer(widget.id, widget.controller.text);
                    widget.onEdit();
                  } else {
                    await AnswersWebservice.postAnswer(
                        question:questionsList[widget.question.index],
                        body:  widget.controller.text,
                      adminCubit: widget.adminCubit
                    );
                    setState(() {
                      widget.controller.text = "";
                      iconColor = Colors.grey;
                    });
                  }
                },
        ),
      ),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        if (widget.controller.text.isEmpty) {
          setState(() {
            iconColor = Colors.grey;
          });
        } else {
          setState(() {
            iconColor = Colors.amber;
          });
        }
      },
    );
  }
}
