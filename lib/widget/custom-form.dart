import 'package:flutter/material.dart';
import 'package:gym_project/services/admin-services/announcements_services.dart';
import 'package:gym_project/widget/material-button.dart';
import 'package:provider/provider.dart';
import '../bloc/Admin_cubit/admin_cubit.dart';

class CustomForm extends StatefulWidget {
  //const CustomForm({Key key}) : super(key: key);
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final String form_type;
  final String post_type;
  final int id;
  bool enable;
  AdminCubit cubit;

  CustomForm({
    this.titleController,
    this.bodyController,
    this.form_type,
    this.post_type,
    this.enable,
    this.id,
    this.cubit
  });

  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  //bool btn_enabled;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.titleController.text.isEmpty &&
        widget.bodyController.text.isEmpty) {
      widget.enable = false;
    } else {
      widget.enable = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'assets/fonts/Changa-Bold.ttf',
              fontSize: 15,
            ),
            controller: widget.titleController,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.amber),
              ),
              labelText: 'Title',
              labelStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'assets/fonts/Changa-Bold.ttf',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              contentPadding: EdgeInsets.all(15),
              hintText: 'Enter your ${widget.post_type}\'s title',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: 'assets/fonts/Changa-Bold.ttf',
                fontSize: 15,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.amber),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              if (widget.bodyController.text.isNotEmpty &&
                  widget.titleController.text.isNotEmpty) {
                setState(() {
                  widget.enable = true;
                });
              } else {
                setState(() {
                  widget.enable = false;
                });
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            maxLines: 15,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'assets/fonts/Changa-Bold.ttf',
              fontSize: 15,
            ),
            controller: widget.bodyController,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.amber),
              ),
              labelText: 'Body',
              labelStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'assets/fonts/Changa-Bold.ttf',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              contentPadding: EdgeInsets.all(15),
              hintText: 'Enter your ${widget.post_type}',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: 'assets/fonts/Changa-Bold.ttf',
                fontSize: 15,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.amber),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              if (widget.bodyController.text.isNotEmpty &&
                  widget.titleController.text.isNotEmpty) {
                setState(() {
                  widget.enable = true;
                });
              } else {
                setState(() {
                  widget.enable = false;
                });
              }
            },
          ),
        ),
        CustomMaterialButton(
          formButton: true,
          text: (widget.form_type == 'Add' ? 'Add' : 'Edit') +
              (widget.post_type == 'question' ? ' Question' : ' Announcement'),
          enable: widget.enable,
          onPressed: widget.enable
              ? () async {
                  if (widget.form_type == 'Add' &&
                      widget.post_type == 'question') {
                    // await Provider.of<QuestionListViewModel>(context,
                    //         listen: false)
                    //     .postQuestion(
                    //   widget.titleController.text,
                    //   widget.bodyController.text,
                    // );
                    // await Provider.of<QuestionListViewModel>(context,
                    //         listen: false)
                    //     .getQuestions();
                  } else if (widget.form_type == 'Edit' &&
                      widget.post_type == 'question') {
                    // await Provider.of<QuestionListViewModel>(context,
                    //         listen: false)
                    //     .editQuestion(
                    //   widget.id,
                    //   widget.titleController.text,
                    //   widget.bodyController.text,
                    // );
                    // await Provider.of<QuestionListViewModel>(context, listen: false).getQuestions();
                  } else if (widget.form_type == 'Add' &&
                      widget.post_type == 'announcement') {
                    AnnouncementsServices.addAnnouncement(
                        widget.titleController.text,
                        widget.bodyController.text,
                        DateTime.now().toString(),
                      adminCubit: widget.cubit,
                      context:context
                    );
                  } else {
                    AnnouncementsServices.editAnnouncement(
                      widget.id,
                      widget.titleController.text,
                      widget.bodyController.text,
                      DateTime.now().toString(),
                      context,
                        adminCubit: widget.cubit
                    );
                  }
                }
              : null,
        ),
      ],
    );
  }
}
