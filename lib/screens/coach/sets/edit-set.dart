import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/models/set.dart';
import 'package:gym_project/screens/coach/exercises/exercises_screen.dart';
import 'package:gym_project/screens/common/widget-builders.dart';
import 'package:gym_project/viewmodels/exercise-view-model.dart';
import 'package:gym_project/viewmodels/set-list-view-model.dart';
import 'package:gym_project/viewmodels/set-view-model.dart';
import 'package:provider/provider.dart';

Map<int, Map<String, Object>> selectedExercises = {};
List<ExerciseViewModel> orderedExercises = [];

int getExerciseQuantity(ExerciseViewModel exercise) {
  List<ExerciseViewModel> sameExercisesList =
      orderedExercises.where((ex) => ex.id == exercise.id).toList();
  return sameExercisesList.length;
}

void setSelectedExercises({
  @required List<ExerciseViewModel> orderedExercises,
}) {
  selectedExercises.clear();
  List<int> uniqueIds =
      orderedExercises.map((exercise) => exercise.id).toSet().toList();
  uniqueIds.forEach((id) {
    ExerciseViewModel exercise =
        orderedExercises.firstWhere((exercise) => exercise.id == id);
    Map<String, Object> exerciseData = {
      'exercise': exercise,
      'quantity': getExerciseQuantity(exercise),
    };
    MapEntry<int, Map<String, Object>> selectedExercise =
        MapEntry(exercise.id, exerciseData);
    selectedExercises.addEntries([selectedExercise]);
  });
}

void setOrderedExercises({
  @required Map<int, Map<String, Object>> selectedExercises,
}) {
  orderedExercises.clear();
  selectedExercises.values.forEach((Map<String, Object> exerciseData) {
    int quantity = exerciseData['quantity'] as int;
    ExerciseViewModel exercise = exerciseData['exercise'] as ExerciseViewModel;
    for (int i = 0; i < quantity; i++) {
      orderedExercises.add(exercise);
    }
  });
}

class EditSetForm extends StatefulWidget {
  final SetViewModel setVM;
  EditSetForm(this.setVM);
  @override
  MapScreenState createState() => MapScreenState();
}

//you can change the form heading from line 51,93
//you can change the form fields from lines (119 ,138 , etc ) -> each padding represent a field
class MapScreenState extends State<EditSetForm>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController breakDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SetListViewModel setListVM =
        Provider.of<SetListViewModel>(context, listen: false);
    setListVM.fetchSetDetails(widget.setVM.id).then((_) {
      orderedExercises =
          setListVM.set.exercises.map((e) => ExerciseViewModel(e: e)).toList();
      setSelectedExercises(orderedExercises: orderedExercises);
    }).catchError((error) {
      viewErrorDialogBox(context, error.toString()).then((_) {
        Navigator.of(context).pop();
      });
    });
  }

  refresh() {
    setState(() {});
  }

  getOrderedExercisesModels() {
    return orderedExercises.map((exerciseVM) => exerciseVM.exercise).toList();
  }

  Future<void> submitForm(
    SetListViewModel setListVM,
    SetViewModel setVM,
  ) async {
    // setState(() {
    //   FocusScope.of(context).requestFocus(new FocusNode());
    // });
    try {
      if (formKey.currentState.validate()) {
        await setListVM.putSet(
          Set(
            id: setVM.id,
            title: titleController.text,
            description: descriptionController.text,
            breakDuration: breakDurationController.text,
            coachId: setVM.coachId,
            exercises: getOrderedExercisesModels(),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      viewErrorDialogBox(context, error.toString());
    }
  }

  Widget buildReorderableList() {
    return Theme(
      data: ThemeData(
        iconTheme: IconThemeData(color: Colors.white),
        canvasColor: Color(0xff181818),
      ),
      child: ReorderableListView(
        shrinkWrap: true,
        children: <Widget>[
          for (int index = 0; index < orderedExercises.length; index++)
            CustomExerciseListTile(
                Key(index.toString()), orderedExercises[index], refresh),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final ExerciseViewModel exerciseVM =
                orderedExercises.removeAt(oldIndex);
            orderedExercises.insert(newIndex, exerciseVM);
          });
        },
      ),
    );
  }

  Widget buildEditButton({Function onPressed}) {
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
        onPressed: onPressed,
      ),
    );
  }

  Widget buildTextFormFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(
                label,
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
    );
  }

  Widget buildTextFormField({
    String hintText,
    TextEditingController controller,
    String Function(String) validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Flexible(
            child: new TextFormField(
                decoration: InputDecoration(
                  hintText: hintText,
                ),
                controller: controller,
                validator: validator),
          ),
        ],
      ),
    );
  }

  Widget buildChooseExercisesButton() {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
      child: Container(
        width: isWideScreen ? 130 : double.infinity,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: Center(
                  child: ElevatedButton(
                child: Text('Choose Exercises'),
                style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black,
                    primary: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    )),
                onPressed: chooseExercises,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> chooseExercises() async {
    var result = await Navigator.pushNamed(
      context,
      ExercisesScreen.choosingRouteName,
      arguments: selectedExercises,
    ) as Map<int, Map<String, Object>>;
    if (result != null && result.isNotEmpty) {
      setState(() {
        selectedExercises = result;
        setOrderedExercises(selectedExercises: selectedExercises);
      });
    }
  }

  Widget buildForm({GlobalKey<FormState> key, @required Function submitForm}) {
    return Form(
      key: formKey,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
            child: Text(
              'Set Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          buildTextFormFieldLabel('Title'),
          buildTextFormField(
            hintText: 'Enter Your Title',
            controller: titleController,
            validator: (value) {
              if (value.isEmpty) return 'Title is required';
              return null;
            },
          ),
          buildTextFormFieldLabel('Description'),
          buildTextFormField(
            hintText: 'Enter Your Description',
            controller: descriptionController,
            validator: (value) {
              if (value.isEmpty) return 'Descroption is required';
              return null;
            },
          ),
          buildTextFormFieldLabel('Break Duration'),
          buildTextFormField(
            hintText: 'Enter Break Duration',
            controller: breakDurationController,
            validator: (value) {
              if (value.isEmpty) return 'break duration is required';
              return null;
            },
          ),
          SizedBox(height: 10),
          buildTextFormFieldLabel('Exercises'),
          SizedBox(height: 10),
          buildChooseExercisesButton(),
          SizedBox(height: 10),
          if (orderedExercises.isNotEmpty) buildReorderableList(),
          SizedBox(height: 10),
          buildEditButton(onPressed: submitForm),
        ],
      ),
    );
  }

  Widget buildHeader() {
    Text editSetTextWidget = Text(
      'Edit Set',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        fontFamily: 'sans-serif-light',
        color: Colors.white,
      ),
    );

    return Container(
      height: 100.0,
      color: Color(0xFF181818), //background color
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, top: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: Icon(
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
              child: editSetTextWidget,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    SetListViewModel setListVM = Provider.of<SetListViewModel>(context);
    SetViewModel setVM = setListVM.set;
    if (setVM != null) {
      titleController.text = setVM.title;
      descriptionController.text = setVM.description;
      breakDurationController.text = setVM.breakDuration;
    }
    return new Scaffold(
      body: SafeArea(
        child: new Container(
          color: Color(0xFF181818), //background color
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  buildHeader(),
                  new Container(
                    //height: 1000.0,
                    constraints: new BoxConstraints(minHeight: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),

                    //color: Colors.white,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: setListVM.loadingStatus == LoadingStatus.Searching ||
                            setListVM.set == null
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ))
                        : Padding(
                            padding: EdgeInsets.all(30),
                            child: buildForm(
                              key: formKey,
                              submitForm: () => submitForm(setListVM, setVM),
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
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}

class CustomExerciseListTile extends StatefulWidget {
  final ExerciseViewModel exerciseVM;
  final Key key;
  final Function() notifyParent;

  CustomExerciseListTile(this.key, this.exerciseVM, this.notifyParent)
      : super(key: key);
  @override
  _CustomExerciseListTileState createState() => _CustomExerciseListTileState();
}

class _CustomExerciseListTileState extends State<CustomExerciseListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      margin: EdgeInsets.all(3),
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
          widget.exerciseVM.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text(
            //   widget.exercise['duration'],
            //   style: TextStyle(
            //     color: Colors.white,
            //   ),
            // ),
            // Text(
            //   '${widget.exercise['cal_burnt']} cal',
            //   style: TextStyle(
            //     color: Colors.white,
            //   ),
            // )
            Text(
              widget.exerciseVM.coachId.toString(),
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
