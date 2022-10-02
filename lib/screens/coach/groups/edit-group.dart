import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/helper/constants.dart';
import 'package:gym_project/models/group.dart';
import 'package:gym_project/screens/coach/exercises/exercises_screen.dart';
import 'package:gym_project/screens/coach/sets/view-sets.dart';
import 'package:gym_project/screens/common/widget-builders.dart';
import 'package:gym_project/viewmodels/exercise-view-model.dart';
import 'package:gym_project/viewmodels/group-list-view-model.dart';
import 'package:gym_project/viewmodels/groups-view-model.dart';
import 'package:gym_project/viewmodels/set-view-model.dart';
import 'package:provider/provider.dart';

Map<int, Map<String, Object>> selectedExercises = {};
Map<int, Map<String, Object>> selectedSets = {};
List<dynamic> orderedObjects = [];

void setSelectedExercisesAndSets({
  @required List<dynamic> orderedObjects,
}) {
  List<ExerciseViewModel> exercises =
      orderedObjects.whereType<ExerciseViewModel>().toList();
  List<SetViewModel> sets = orderedObjects.whereType<SetViewModel>().toList();
  setSelectedExercises(exercises);
  setSelectedSets(sets);
}

void setSelectedExercises(List<ExerciseViewModel> exercises) {
  List<int> uniqueIds =
      exercises.map((exercise) => exercise.id).toSet().toList();
  uniqueIds.forEach((id) {
    ExerciseViewModel exercise =
        exercises.firstWhere((exercise) => exercise.id == id);
    Map<String, Object> exerciseData = {
      'exercise': exercise,
      'quantity': getExerciseQuantity(exercises, exercise),
    };
    MapEntry<int, Map<String, Object>> selectedExercise =
        MapEntry(exercise.id, exerciseData);
    selectedExercises.addEntries([selectedExercise]);
  });
}

int getExerciseQuantity(
  List<ExerciseViewModel> exercises,
  ExerciseViewModel exercise,
) {
  List<ExerciseViewModel> sameExercisesList =
      exercises.where((ex) => ex.id == exercise.id).toList();
  return sameExercisesList.length;
}

void setSelectedSets(List<SetViewModel> sets) {
  List<int> uniqueIds = sets.map((set) => set.id).toSet().toList();
  uniqueIds.forEach((id) {
    SetViewModel set = sets.firstWhere((set) => set.id == id);
    Map<String, Object> setData = {
      'set': set,
      'quantity': getSetQuantity(sets, set),
    };
    MapEntry<int, Map<String, Object>> selectedSet = MapEntry(set.id, setData);
    selectedSets.addEntries([selectedSet]);
  });
}

int getSetQuantity(
  List<SetViewModel> sets,
  SetViewModel set,
) {
  List<SetViewModel> sameSetsList = sets.where((s) => s.id == set.id).toList();
  return sameSetsList.length;
}

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

class EditGroupForm extends StatefulWidget {
  final GroupViewModel groupVM;

  EditGroupForm(this.groupVM);
  @override
  MapScreenState createState() => MapScreenState();
}

//you can change the form heading from line 51,93
//you can change the form fields from lines (119 ,138 , etc ) -> each padding represent a field
class MapScreenState extends State<EditGroupForm>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  Map<int, Object> selectedGroups = {};

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final breakDurationController = TextEditingController();

  void setTextFormFieldsValues(GroupViewModel group) {
    titleController.text = group.title;
    descriptionController.text = group.description;
    breakDurationController.text = group.breakDuration;
  }

  @override
  void initState() {
    super.initState();
    GroupListViewModel groupListVM =
        Provider.of<GroupListViewModel>(context, listen: false);
    groupListVM.fetchGroupDetails(widget.groupVM.id).then((_) {
      GroupViewModel groupVM = groupListVM.group;
      setTextFormFieldsValues(groupVM);
      orderedObjects.clear();
      orderedObjects.addAll(groupVM.exercisesViewModels);
      orderedObjects.addAll(groupVM.setsViewModels);
      orderedObjects.sort((a, b) => a.order.compareTo(b.order));
      setSelectedExercisesAndSets(orderedObjects: orderedObjects);

      // groupListVM.group.group.title = 'edited flutter group';
      // groupListVM.putGroup(groupListVM.group.group, orderedObjects, token);
    });
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    GroupListViewModel groupListVM = Provider.of<GroupListViewModel>(context);

    return new Scaffold(
      body: SafeArea(
        child: new Container(
          color: Color(0xFF181818), //background color
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 100.0,
                    color: Color(0xFF181818), //background color
                    child: new Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  child: new Icon(
                                    Icons.arrow_back_ios,
                                    color: Color(0xFFFFCE2B),
                                    size: 22.0,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  //-->header
                                  child: new Text('Edit Group',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          fontFamily: 'sans-serif-light',
                                          color: Colors.white)),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                  if (groupListVM.loadingStatus == LoadingStatus.Searching)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  if (groupListVM.loadingStatus == LoadingStatus.Completed)
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                            'Exercises',
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
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Container(
                                  width: isWideScreen ? 130 : double.infinity,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        child: Center(
                                          child: ElevatedButton(
                                            child: Text('Choose Exercises'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                              onPrimary: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            onPressed: () async {
                                              var receivedSelectedExercises =
                                                  await Navigator.pushNamed(
                                                context,
                                                ExercisesScreen
                                                    .choosingRouteName,
                                                arguments: selectedExercises,
                                              ) as Map<int,
                                                      Map<String, Object>>;
                                              if (receivedSelectedExercises !=
                                                  null) {
                                                setState(() {
                                                  selectedExercises =
                                                      receivedSelectedExercises;
                                                  if (selectedExercises
                                                      .isEmpty) {
                                                    orderedObjects.removeWhere(
                                                        (object) =>
                                                            object
                                                                .runtimeType ==
                                                            ExerciseViewModel);
                                                    return;
                                                  }
                                                  setOrderedObjects(
                                                      selectedObjects:
                                                          selectedExercises);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                            'Sets',
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Container(
                                  width: isWideScreen ? 130 : double.infinity,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                        child: Center(
                                          child: ElevatedButton(
                                            child: Text('Choose Sets'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                              onPrimary: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            onPressed: () async {
                                              var receivedSelectedSets =
                                                  await Navigator.pushNamed(
                                                context,
                                                ViewSetsScreen
                                                    .choosingRouteName,
                                                arguments: selectedSets,
                                              ) as Map<int,
                                                      Map<String, Object>>;
                                              if (receivedSelectedSets !=
                                                  null) {
                                                setState(() {
                                                  selectedSets =
                                                      receivedSelectedSets;
                                                  if (selectedSets.isEmpty) {
                                                    orderedObjects.removeWhere(
                                                        (object) =>
                                                            object
                                                                .runtimeType ==
                                                            SetViewModel);
                                                    return;
                                                  }
                                                  setOrderedObjects(
                                                      selectedObjects:
                                                          selectedSets);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              if (orderedObjects.isNotEmpty)
                                Theme(
                                  data: ThemeData(
                                    primaryColor:
                                        Theme.of(context).primaryColor,
                                    canvasColor: Color(0xff181818),
                                    iconTheme:
                                        IconThemeData(color: Colors.white),
                                  ),
                                  child: ReorderableListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      for (int index = 0;
                                          index < orderedObjects.length;
                                          index++)
                                        CustomListTile(Key(index.toString()),
                                            orderedObjects[index], refresh),
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
                                    child: Text("Edit"),
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
                                        id: groupListVM.group.id,
                                        title: titleController.text,
                                        description: descriptionController.text,
                                        breakDuration:
                                            breakDurationController.text,
                                        coachId:
                                            99999, // TODO: get coach data from user provider
                                      );
                                      groupListVM.putGroup(
                                          inputGroup, orderedObjects);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}

class CustomListTile extends StatefulWidget {
  final objectVM; //ExerciseViewModel or SetViewModel
  final Key key;
  final Function() notifyParent;

  CustomListTile(this.key, this.objectVM, this.notifyParent) : super(key: key);
  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
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
