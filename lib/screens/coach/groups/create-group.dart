import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

import 'package:gym_project/models/group.dart';

import 'package:gym_project/screens/coach/sets/view-sets.dart';
import 'package:gym_project/screens/coach/exercises/exercises_screen.dart';
import 'package:gym_project/screens/common/widget-builders.dart';
import 'package:gym_project/viewmodels/exercise-view-model.dart';
import 'package:gym_project/viewmodels/group-list-view-model.dart';

import 'package:gym_project/viewmodels/set-view-model.dart';
import 'package:provider/provider.dart';

Map<int, Map<String, Object>> selectedExercises = {};
Map<int, Map<String, Object>> selectedSets = {};
List<dynamic> orderedObjects = [];

void setOrderedObjects({
  @required Map<int, Map<String, Object>> selectedObjects,
}) {
  // figuring out incoming objects are exercises or sets
  Map<String, Object> firstObjectData = selectedObjects.values.first;
  bool objectsAreExercises = firstObjectData.containsKey('exercise');
  if (objectsAreExercises) {
    // removing old exercises
    orderedObjects
        .removeWhere((object) => object.runtimeType == ExerciseViewModel);
    selectedObjects.values.forEach((Map<String, Object> exerciseData) {
      int quantity = exerciseData['quantity'] as int;
      ExerciseViewModel exercise =
          exerciseData['exercise'] as ExerciseViewModel;
      for (int i = 0; i < quantity; i++) {
        orderedObjects.add(exercise);
      }
    });
  } else {
    // removing old sets
    orderedObjects.removeWhere((object) => object.runtimeType == SetViewModel);
    selectedObjects.values.forEach((Map<String, Object> setData) {
      int quantity = setData['quantity'] as int;
      SetViewModel set = setData['set'] as SetViewModel;
      for (int i = 0; i < quantity; i++) {
        orderedObjects.add(set);
      }
    });
  }
}

class CreateGroupForm extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

//you can change the form heading from line 51,93
//you can change the form fields from lines (119 ,138 , etc ) -> each padding represent a field
class MapScreenState extends State<CreateGroupForm>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  Map<int, Object> selectedGroups = {};

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final breakDurationController = TextEditingController();

  void setTextFormFieldsInitialValues() {
    Map<String, String> initialValues = {
      'title': 'Flutter Set 1',
      'description': 'Description of flutter set 1',
      'break_duration': '00:30'
    };
    titleController.text = initialValues['title'];
    descriptionController.text = initialValues['description'];
    breakDurationController.text = initialValues['break_duration'];
  }

  @override
  void initState() {
    super.initState();
    setTextFormFieldsInitialValues();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  refresh() {
    setState(() {});
  }

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
                  buildHeader(context),
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
                        key: formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          //---> topic
                                          'Group Information',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[],
                                    )
                                  ],
                                )),
                            buildTextFormFieldLabel('Title'),
                            buildTextFormField(
                              controller: titleController,
                              hintText: 'Enter Your Title',
                              validator: (String value) {
                                if (value.isEmpty) return 'Title is required';
                                return null;
                              },
                            ),
                            buildTextFormFieldLabel('Description'),
                            buildTextFormField(
                              controller: descriptionController,
                              hintText: 'Enter Your Description',
                              validator: (String value) {
                                if (value.isEmpty)
                                  return 'Description is required';
                                return null;
                              },
                            ),
                            buildTextFormFieldLabel('Break Duration'),
                            buildTextFormField(
                              controller: breakDurationController,
                              hintText: 'Enter Break Duration',
                              validator: (String value) {
                                if (value.isEmpty)
                                  return 'Break Duration is required';
                                return null;
                              },
                            ),
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
                                          'Exercises & Sets',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  child: Text('Choose Exercises'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () async {
                                    var receivedSelectedExercises =
                                        await Navigator.pushNamed(
                                      context,
                                      ExercisesScreen.choosingRouteName,
                                      arguments: selectedExercises,
                                    ) as Map<int, Map<String, Object>>;
                                    if (receivedSelectedExercises != null) {
                                      setState(() {
                                        selectedExercises =
                                            receivedSelectedExercises;
                                        if (selectedExercises.isEmpty) {
                                          orderedObjects.removeWhere((object) =>
                                              object.runtimeType ==
                                              ExerciseViewModel);
                                          return;
                                        }
                                        setOrderedObjects(
                                            selectedObjects: selectedExercises);
                                      });
                                    }
                                  },
                                ),
                                ElevatedButton(
                                  child: Text('Choose Sets'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () async {
                                    var receivedSelectedSets =
                                        await Navigator.pushNamed(
                                      context,
                                      ViewSetsScreen.choosingRouteName,
                                      arguments: selectedSets,
                                    ) as Map<int, Map<String, Object>>;
                                    if (receivedSelectedSets != null) {
                                      setState(() {
                                        selectedSets = receivedSelectedSets;
                                        if (selectedSets.isEmpty) {
                                          orderedObjects.removeWhere((object) =>
                                              object.runtimeType ==
                                              SetViewModel);
                                          return;
                                        }
                                        setOrderedObjects(
                                            selectedObjects: selectedSets);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (orderedObjects.isNotEmpty)
                              Theme(
                                data: ThemeData(
                                  primaryColor: Theme.of(context).primaryColor,
                                  canvasColor: Color(0xff181818),
                                  iconTheme: IconThemeData(color: Colors.white),
                                ),
                                child: ReorderableListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    for (int index = 0;
                                        index < orderedObjects.length;
                                        index++)
                                      CustomExerciseListTile(
                                          Key(index.toString()),
                                          orderedObjects[index],
                                          refresh),
                                  ],
                                  onReorder: (int oldIndex, int newIndex) {
                                    setState(() {
                                      if (oldIndex < newIndex) {
                                        newIndex -= 1;
                                      }
                                      var object =
                                          orderedObjects.removeAt(oldIndex);
                                      orderedObjects.insert(newIndex, object);
                                    });
                                  },
                                ),
                              ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("Create"),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
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
                                  if (formKey.currentState.validate()) {
                                    if (orderedObjects.isEmpty) {
                                      viewErrorDialogBox(
                                        context,
                                        'Please choose at lease a set or exercise',
                                      );
                                      return;
                                    }
                                    Group inputGroup = Group(
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      breakDuration:
                                          breakDurationController.text,
                                      coachId:
                                          9999, //TODO: connect coach with created group
                                    );

                                    Provider.of<GroupListViewModel>(context,
                                            listen: false)
                                        .postGroup(inputGroup, orderedObjects);
                                    // Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ),
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

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    breakDurationController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }
}

class CustomSetListTile extends StatefulWidget {
  final Key key;
  final SetViewModel setVM;
  final Function() notifyParent;

  CustomSetListTile(this.key, this.setVM, this.notifyParent) : super(key: key);
  @override
  _CustomSetListTileState createState() => _CustomSetListTileState();
}

class _CustomSetListTileState extends State<CustomSetListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      margin: EdgeInsetsDirectional.all(3),
      decoration: BoxDecoration(
        color: Color(0xff181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        key: widget.key,
        minVerticalPadding: 10,
        leading: CircleAvatar(
          radius: 20,
          child: FlutterLogo(),
        ),
        title: Text(
          widget.setVM.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set Id: ${widget.setVM.id}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              'Coach Id: ${widget.setVM.coachId}',
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomExerciseListTile extends StatefulWidget {
  final objectVM; //ExerciseViewModel or SetViewModel
  final Key key;
  final Function() notifyParent;

  CustomExerciseListTile(this.key, this.objectVM, this.notifyParent)
      : super(key: key);
  @override
  _CustomExerciseListTileState createState() => _CustomExerciseListTileState();
}

class _CustomExerciseListTileState extends State<CustomExerciseListTile> {
  @override
  Widget build(BuildContext context) {
    String type =
        widget.objectVM.runtimeType == ExerciseViewModel ? 'exercise' : 'set';
    String titlePrefix = type == 'exercise' ? 'Exercise: ' : 'Set: ';
    IconData icon = type == 'exercise'
        ? Icons.run_circle_outlined
        : Icons.grid_view_outlined;
    double iconSize = type == 'exercise' ? 40 : 30;
    return Container(
      key: widget.key,
      margin: EdgeInsetsDirectional.all(3),
      decoration: BoxDecoration(
        color: Color(0xff181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        key: widget.key,
        minVerticalPadding: 10,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 20,
          child: Icon(icon, color: Colors.black, size: iconSize),
        ),
        title: Text(
          titlePrefix + widget.objectVM.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Id: ${widget.objectVM.id}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
