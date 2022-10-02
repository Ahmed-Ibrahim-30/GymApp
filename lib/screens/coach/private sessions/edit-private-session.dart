import 'package:flutter/material.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/style/success-pop-up.dart';
import 'package:gym_project/viewmodels/private-session-list-view-model.dart';
import 'package:gym_project/viewmodels/private-session-view-model.dart';
import 'package:gym_project/widget/form-widget.dart';
import 'package:provider/provider.dart';

class EditPrivateSessionForm extends StatefulWidget {
  final int id;

  EditPrivateSessionForm(this.id);
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<EditPrivateSessionForm>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  PrivateSessionViewModel _privateSession;
  bool status = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  PrivateSessionListViewModel pS;
  bool error = false;
  @override
  void initState() {
    super.initState();
    Provider.of<PrivateSessionListViewModel>(context, listen: false)
        .fetchPrivateSession(widget.id)
        .then((value) {
      pS = Provider.of<PrivateSessionListViewModel>(context, listen: false);
      _privateSession = pS.privateSession;
      setState(() {
        titleController = TextEditingController(text: _privateSession.title);
        descriptionController =
            TextEditingController(text: _privateSession.description);
        durationController =
            TextEditingController(text: _privateSession.duration);
        priceController =
            TextEditingController(text: _privateSession.price.toString());
        linkController = TextEditingController(text: _privateSession.link);
      });
    }).catchError((err) {
      error = true;
      print('error occured $err');
    });
  }

  refresh() {
    setState(() {});
  }

  bool savePrivateSession() {
    setState(() {
      Provider.of<PrivateSessionListViewModel>(context, listen: false)
          .editPrivateSession(_privateSession)
          .then((value) {
        showSuccessMessage(context, 'Edited session successfully');
      }).catchError((err) {
        showErrorMessage(context, 'Failed to edit session');
        print('error occured $err');
      });
    });
    return true;
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    return new Scaffold(
      body: SafeArea(
        child: new Container(
          color: Color(0xFF181818), //background color
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  PageTitle('Edit Private Session'),
                  new Container(
                    //height: 1000.0,
                    constraints: new BoxConstraints(minHeight: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Form(
                        key: _formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            FormTitle('Private Session Info'),
                            FieldTitle('Title'),
                            CustomTextFieldWidget(
                                titleController, 'Enter title'),
                            FieldTitle('Description'),
                            CustomTextFieldWidget(
                                descriptionController, 'Enter description'),
                            FieldTitle('Duration'),
                            CustomNumericalTextField(
                                controller: durationController,
                                hintText: 'Enter duration h:m:s'),
                            FieldTitle('Price'),
                            CustomNumericalTextField(
                                controller: priceController,
                                hintText: 'Enter price'),
                            FieldTitle('Link'),
                            CustomTextFieldWidget(
                                linkController, 'Enter session link'),
                            SizedBox(
                              height: 10,
                            ),
                            editButton(context),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container editButton(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: ElevatedButton(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("Edit"),
        ),
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          primary: Color(0xFFFFCE2B),
          onPrimary: Colors.black,
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          minimumSize: Size(100, 30),
        ),
        onPressed: () {
          setState(() {
            _status = true;
            FocusScope.of(context).requestFocus(new FocusNode());
          });

          if (_formKey.currentState.validate()) {
            _privateSession.title = titleController.text;
            _privateSession.description = descriptionController.text;
            _privateSession.duration = durationController.text;
            _privateSession.price = double.parse(priceController.text);
            _privateSession.link = linkController.text;

            status = savePrivateSession();

            print("Back!");
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}
