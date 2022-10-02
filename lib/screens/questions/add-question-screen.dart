import 'package:flutter/material.dart';
import 'package:gym_project/widget/custom-form.dart';

class AddQuestionScreen extends StatefulWidget {
  //const AddQuestionScreen({Key key}) : super(key: key);
  final int id;
  final String title;
  final String body;
  final String form_type;

  AddQuestionScreen({this.title, this.body, this.form_type, this.id});

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool btn_enabled;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.text = widget.title;
    _bodyController.text = widget.body;
    if (_titleController.text.isEmpty && _bodyController.text.isEmpty) {
      btn_enabled = false;
    } else {
      btn_enabled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Questions',
          style: TextStyle(
            color: Colors.white,
            //fontFamily: 'assets/fonts/Changa-Bold.ttf',
            //fontSize: 25,
            //fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xff181818),
        iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '${widget.form_type} Question',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'assets/fonts/Changa-Bold.ttf',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              CustomForm(
                titleController: _titleController,
                bodyController: _bodyController,
                form_type: widget.form_type,
                post_type: 'question',
                enable: btn_enabled,
                id: widget.id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
