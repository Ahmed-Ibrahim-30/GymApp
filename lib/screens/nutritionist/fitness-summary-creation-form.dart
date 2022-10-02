import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/common/my_list_tile.dart';
import 'package:gym_project/models/fitness-summary.dart';
import 'package:gym_project/models/user/member_model.dart';
import 'package:gym_project/screens/nutritionist/choose-members-screen.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/style/success-pop-up.dart';
import 'package:gym_project/viewmodels/fitness-summary-list-view-model.dart';
import 'package:gym_project/widget/form-widget.dart';
import 'package:provider/provider.dart';

import '../../widget/global.dart';

Member selectedMember;

class CreateFitnessSummaryForm extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

//you can change the form heading from line 51,93
//you can change the form fields from lines (119 ,138 , etc ) -> each padding represent a field
//
class MapScreenState extends State<CreateFitnessSummaryForm>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  FitnessSummary fitnessSummary;
  bool status = false;

  // ignore: non_constant_identifier_names
  TextEditingController BMIController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController muscleRatioController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController fatRatioController = TextEditingController();
  TextEditingController totalBodyWaterController = TextEditingController();
  TextEditingController fitnessRatioController = TextEditingController();
  TextEditingController dryLeanBathController = TextEditingController();
  TextEditingController bodyFatMassController = TextEditingController();
  TextEditingController opacityRatioController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController SMMController = TextEditingController();
  String role;
  @override
  void initState() {
    super.initState();
    role = Global.role;
  }

  refresh() {
    setState(() {});
  }

  bool saveFitnessSummary() {
    setState(() {
      Provider.of<FitnessSummaryListViewModel>(context, listen: false)
          .postFitnessSummary(fitnessSummary)
          .then((value) {
        showSuccessMessage(context, 'Created fitness summary');
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
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return new Scaffold(
      body: SafeArea(
        child: new Container(
          color: Color(0xFF181818), //background color
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  PageTitle('Create Fitness Summary'),
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
                            FormTitle('Fitness Info'),
                            FieldTitle('BMI'),
                            CustomNumericalTextField(
                                controller: BMIController,
                                hintText: "Enter BMI"),
                            FieldTitle('Weight'),
                            CustomNumericalTextField(
                                controller: weightController,
                                hintText: "Enter weight"),
                            FieldTitle('Muscle Ratio'),
                            CustomNumericalTextField(
                                controller: muscleRatioController,
                                hintText: "Enter muscle ratio"),
                            FieldTitle('Height'),
                            CustomNumericalTextField(
                                controller: heightController,
                                hintText: "Enter height"),
                            FieldTitle('Fat Ratio'),
                            CustomNumericalTextField(
                                controller: fatRatioController,
                                hintText: "Enter fat ratio"),
                            FieldTitle('Fitness Ratio'),
                            CustomNumericalTextField(
                                controller: fitnessRatioController,
                                hintText: "Enter fitness ratio"),
                            FieldTitle('Total Body Water'),
                            CustomNumericalTextField(
                                controller: totalBodyWaterController,
                                hintText: "Enter total body water"),
                            FieldTitle('Dry Lean Bath'),
                            CustomNumericalTextField(
                                controller: dryLeanBathController,
                                hintText: "Enter dry lean bath"),
                            FieldTitle('Body Fat Mass'),
                            CustomNumericalTextField(
                                controller: bodyFatMassController,
                                hintText: "Enter body fat mass"),
                            FieldTitle('Opacity Ratio'),
                            CustomNumericalTextField(
                                controller: opacityRatioController,
                                hintText: "Enter opacity ratio"),
                            FieldTitle('Protein'),
                            CustomNumericalTextField(
                                controller: proteinController,
                                hintText: "Enter protein"),
                            FieldTitle('SMM'),
                            CustomNumericalTextField(
                                controller: SMMController,
                                hintText: "Enter SMM"),
                            if (role == 'nutritionist')
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Member',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            if (role == 'nutritionist')
                              SizedBox(
                                height: 10,
                              ),
                            if (role == 'nutritionist')
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: ElevatedButton(
                                            child: Text(
                                              'Choose Member',
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                textStyle: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                primary: Colors.amber,
                                                onPrimary: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                )),
                                            onPressed: () async {
                                              Member result =
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChooseMembersScreen(
                                                                true),
                                                      ));
                                              setState(() {
                                                if (result != null)
                                                  selectedMember = result;
                                                print(selectedMember);
                                              });
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if (selectedMember != null)
                              CustomListTile(
                                selectedMember.name,
                                [],
                                trailing: '',
                              ),
                            SizedBox(
                              height: 10,
                            ),
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
            fitnessSummary = new FitnessSummary(
              BMI: double.parse(BMIController.text),
              SMM: double.parse(SMMController.text),
              bodyFatMass: double.parse(bodyFatMassController.text),
              dryLeanBath: double.parse(bodyFatMassController.text),
              fatRatio: double.parse(fatRatioController.text),
              fitnessRatio: double.parse(fitnessRatioController.text),
              height: double.parse(heightController.text),
              muscleRatio: double.parse(muscleRatioController.text),
              opacityRatio: double.parse(opacityRatioController.text),
              protein: double.parse(proteinController.text),
              totalBodyWater: double.parse(totalBodyWaterController.text),
              weight: double.parse(weightController.text),
            );

            if (role == 'nutritionist') {
              fitnessSummary.memberId = selectedMember.id;
            }

            status = saveFitnessSummary();

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
