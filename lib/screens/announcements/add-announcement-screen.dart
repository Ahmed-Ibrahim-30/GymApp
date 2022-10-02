import 'package:flutter/material.dart';
import 'package:gym_project/widget/custom-form.dart';
import '../../bloc/Admin_cubit/admin_cubit.dart';

class AddAnnouncementScreen extends StatefulWidget {
  final String title;
  final String body;
  final int id;
  final String post_type;
  AdminCubit myCubit;
  AddAnnouncementScreen({this.id, this.title, this.body, this.post_type,this.myCubit});

  @override
  _AddAnnouncementScreenState createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
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
          'Announcements',
          style: TextStyle(color: Colors.white),
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
                    '${widget.post_type} Announcement',
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
                form_type: widget.post_type,
                post_type: 'announcement',
                id: widget.id,
                enable: btn_enabled,
                cubit:widget.myCubit
              ),
            ],
          ),
        ),
      ),
    );
  }
}
