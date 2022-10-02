import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/models/privatesession.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/style/success-pop-up.dart';
import 'package:gym_project/viewmodels/private-session-list-view-model.dart';
import 'package:gym_project/widget/custom-back-button-2.dart';
import 'package:gym_project/widget/form-widget.dart';
import 'package:provider/provider.dart';

class CreatePrivateSessionForm extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

//you can change the form heading from line 51,93
//you can change the form fields from lines (119 ,138 , etc ) -> each padding represent a field
//
class MapScreenState extends State<CreatePrivateSessionForm>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  PrivateSession _privateSession;
  bool status = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  String role;
  @override
  void initState() {
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  bool savePrivateSession() {
    setState(() {
      Provider.of<PrivateSessionListViewModel>(context, listen: false)
          .postPrivateSession(_privateSession)
          .then((value) {
        showSuccessMessage(context, 'Created private session');
      }).catchError((err) {
        showErrorMessage(context, 'Failed to create');
        print('error occured $err');
      });
    });
    return true;
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: new Container(
          color: Color(0xFF181818), //background color
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  PageTitle('Create Private Session'),
                  new Container(
                    //height: 1000.0,
                    constraints: new BoxConstraints(minHeight: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),

                    //color: Colors.white,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Padding(
                      //padding: EdgeInsets.only(bottom: 30.0),
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
                            SizedBox(height: 10),
                            createButton(context),
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

  Container createButton(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: ElevatedButton(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("Create"),
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
            _privateSession = new PrivateSession(
              title: titleController.text,
              description: descriptionController.text,
              duration: durationController.text,
              link: linkController.text,
              price: double.parse(priceController.text),
            );

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
