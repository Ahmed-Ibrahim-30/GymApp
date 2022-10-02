import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/coach/exercises/edit-exercise.dart';
import 'package:gym_project/style/duration.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/viewmodels/exercise-list-view-model.dart';
import 'package:gym_project/viewmodels/exercise-view-model.dart';
import 'package:gym_project/widget/back-button.dart';
import 'package:gym_project/widget/global.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';

import '../../common/view-exercises-details-screen.dart';

// ignore: must_be_immutable
class ExercisesScreen extends StatefulWidget {
  bool isSelectionTime = false;
  ExercisesScreen(this.isSelectionTime);
  static String choosingRouteName = '/exercises/choose';
  static String viewingRouteName = '/exercises/index';

  @override
  ExercisesScreenState createState() => ExercisesScreenState();
}

List<ExerciseViewModel> exercises = [];

class ExercisesScreenState extends State<ExercisesScreen> {
  bool error = false;
  bool done = false;
  String token;
  bool _selectionMode = false;
  double _currentPosition = 0;
  @override
  void initState() {
    super.initState();
    done = false;
    error = false;
    if (widget.isSelectionTime == true) {
      _selectionMode = true;
    }
    getExercisesList(0, '');
  }

  int lastPage;
  getExercisesList(int page, String searchText) {
    Provider.of<ExerciseListViewModel>(context, listen: false)
        .fetchListExercises(0, searchText)
        .then((value) {
      setState(() {
        done = true;
        exerciseListViewModel =
            Provider.of<ExerciseListViewModel>(context, listen: false);
        exercises = exerciseListViewModel.exercises;
        lastPage = exerciseListViewModel.lastPage;
      });
    }).catchError((err) {
      setState(() {
        error = true;
        // showErrorMessage(context, 'Error $err');
      });
      print('error occured $err');
    });
  }

  var exerciseListViewModel;
  List<Map<int, int>> _numberOfSelectedInstances = [];
  bool _argumentsLoaded = false;
  Map<int, Map<String, Object>> oldSelectedExercise = {};

  void loadArguments() {
    oldSelectedExercise = ModalRoute.of(context).settings.arguments;
    if (oldSelectedExercise != null && oldSelectedExercise.isNotEmpty) {
      setState(() {
        oldSelectedExercise
            .forEach((int exerciseId, Map<String, Object> exerciseData) {
          _numberOfSelectedInstances
              .add({exerciseId: exerciseData['quantity'] as int});
        });
        _selectionMode = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    done = false;
    error = false;
    super.didChangeDependencies();

    exerciseListViewModel = Provider.of<ExerciseListViewModel>(context);

    if (!_argumentsLoaded) {
      loadArguments();
      _argumentsLoaded = true;
    }
  }

  void setSelectionMode(bool value) {
    setState(() {
      _selectionMode = value;
    });
  }

  void incrementItem(int exerciseId) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(exerciseId));
      if (i != -1) {
        _numberOfSelectedInstances[i][exerciseId] =
            _numberOfSelectedInstances[i][exerciseId] + 1;
      } else {
        _numberOfSelectedInstances.add({exerciseId: 1});
      }
    });
    print(_numberOfSelectedInstances);
  }

  void decrementItem(int exerciseId) {
    setState(() {
      int i = _numberOfSelectedInstances
          .indexWhere((map) => map.containsKey(exerciseId));
      if (i == -1) return;
      if (_numberOfSelectedInstances[i][exerciseId] == 1) {
        _numberOfSelectedInstances
            .removeWhere((map) => map.containsKey(exerciseId));
      } else {
        _numberOfSelectedInstances[i][exerciseId] =
            _numberOfSelectedInstances[i][exerciseId] - 1;
      }
    });
    print(_numberOfSelectedInstances);
  }

  int selectedItemsNumber(int exerciseId) {
    if (!_numberOfSelectedInstances.any((map) => map.containsKey(exerciseId))) {
      return 0;
    } else {
      return _numberOfSelectedInstances
          .firstWhere((map) => map.containsKey(exerciseId))[exerciseId];
    }
  }

  bool isSelected(int exerciseId) {
    return _numberOfSelectedInstances.any((map) => map.containsKey(exerciseId));
  }

  Map<int, Map<String, Object>> getFinalSelectedItems() {
    Map<int, Map<String, Object>> finalSelectedItems = {};
    for (Map<int, int> selectedItem in _numberOfSelectedInstances) {
      selectedItem.forEach((exerciseId, quantity) {
        finalSelectedItems[exerciseId] = {
          'exercise': exercises.firstWhere(
              (ExerciseViewModel exercise) => exercise.id == exerciseId),
          'quantity': quantity
        };
      });
    }
    return finalSelectedItems;
  }

  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    const decorator = DotsDecorator(
      activeColor: Colors.amber,
    );
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: Colors.black,
            ),
            width: double.infinity,
          ),
          Container(
            margin: EdgeInsets.only(left: 230, bottom: 20),
            width: 220,
            height: 190,
            decoration: BoxDecoration(
                color: Color(0xFFFFCE2B),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(190),
                    bottomLeft: Radius.circular(290),
                    bottomRight: Radius.circular(160),
                    topRight: Radius.circular(0))),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(26.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                CustomBackButton(),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    left: 10,
                                  ),
                                  child: Text(
                                    "Exercises",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Material(
                              elevation: 5.0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: TextFormField(
                                controller: searchText,
                                cursorColor: Theme.of(context).primaryColor,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                decoration: InputDecoration(
                                  hintText: 'Search..',
                                  suffixIcon: Material(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          int page =
                                              widget.isSelectionTime ? 0 : 1;
                                          exercises = [];
                                          done = false;
                                          error = false;
                                          _currentPosition = 0;
                                          getExercisesList(
                                              page, searchText.text);
                                        });
                                      },
                                      child: Icon(Icons.search),
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectionMode)
                  CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Selected ${_numberOfSelectedInstances.length} of ${exercises.length}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectionMode = false;
                                  _numberOfSelectedInstances.clear();
                                });
                              },
                              icon: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.black.withOpacity(0.3),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                error
                    ? CustomErrorWidget()
                    : (done && exercises.isEmpty)
                        ? EmptyListError('No exercises found')
                        : exercises.isEmpty
                            ? Progress()
                            : loadExercisesGrid(),
              ],
            ),
          ),
          if (_selectionMode)
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      )),
                  onPressed: () {
                    Navigator.pop(context, getFinalSelectedItems());
                  }),
            ),
        ]),
      ),
    );
  }

  CustomScrollView loadExercisesGrid() {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    return CustomScrollView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(26.0),
          sliver: SliverGrid.count(
            crossAxisCount: isWideScreen ? 4 : 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.8,
            children: [
              for (int index = 0; index < exercises.length; index++)
                MyChoosingGridViewCard(
                  exercise: exercises[index],
                  selectionMode: _selectionMode,
                  setSelectionMode: setSelectionMode,
                  incrementItem: incrementItem,
                  decrementItem: decrementItem,
                  selectedItemsNumber: selectedItemsNumber,
                  isSelected: isSelected,
                  selectionTime: widget.isSelectionTime,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyChoosingGridViewCard extends StatefulWidget {
  MyChoosingGridViewCard({
    Key key,
    @required this.exercise,
    @required this.selectionMode,
    @required this.setSelectionMode,
    @required this.incrementItem,
    @required this.decrementItem,
    @required this.selectedItemsNumber,
    @required this.isSelected,
    @required this.selectionTime,
  }) : super(key: key);

  final ExerciseViewModel exercise;
  final bool selectionMode;
  final Function setSelectionMode;
  final Function incrementItem;
  final Function decrementItem;
  final Function selectedItemsNumber;
  final Function isSelected;
  final bool selectionTime;

  @override
  _MyChoosingGridViewCardState createState() => _MyChoosingGridViewCardState();
}

class _MyChoosingGridViewCardState extends State<MyChoosingGridViewCard> {
  String username = Global.username;

  @override
  Widget build(BuildContext context) {
    String imageURL = widget.exercise.image;
    if (imageURL.substring(0, 4) != 'http') {
      imageURL = '${Constants.defaultUrl}/storage/${widget.exercise.image}';
    }
    final double imageBorderRadius = widget.selectionMode ? 0 : 30;
    return GestureDetector(
      onTap: () {
        if (!widget.selectionTime) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => ExerciseListViewModel(),
                  ),
                ],
                child: ExerciseDetailsScreen(widget.exercise.id),
              ),
            ),
          );
        } else if (widget.selectionTime && !widget.selectionMode) {
          widget.setSelectionMode(true);
          widget.incrementItem(widget.exercise.id);
        }
      },
      child: Container(
        height: 700,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6.0,
            ),
          ],
          color: widget.isSelected(widget.exercise.id)
              ? Colors.blue.withOpacity(0.5)
              : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.selectionMode)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () => widget.incrementItem(widget.exercise.id),
                      icon: Icon(Icons.add)),
                  Text(
                    '${widget.selectedItemsNumber(widget.exercise.id)}',
                    style: TextStyle(color: Colors.black),
                  ),
                  IconButton(
                      onPressed: !widget.isSelected(widget.exercise.id)
                          ? null
                          : () => widget.decrementItem(widget.exercise.id),
                      icon: Icon(Icons.remove)),
                ],
              ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: widget.selectionMode ? 90 : 110,
                padding: EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(imageBorderRadius),
                    topLeft: Radius.circular(imageBorderRadius),
                  ),
                  child: Image.network(
                    imageURL,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 20,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.exercise.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            if (widget.exercise.reps != null)
              SizedBox(
                height: 20,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Reps: ${widget.exercise.reps}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            if (widget.exercise.duration != null)
              SizedBox(
                height: 20,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    formatDuration(widget.exercise.duration),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: 5,
            ),
            //add condition for edit button
            !widget.selectionTime &&
                    !widget.selectionMode &&
                    username == widget.exercise.coachName
                ? SizedBox(
                    height: 21,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.contain,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                  ),
                                  primary: Colors.amber,
                                  onPrimary: Colors.black,
                                ),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditExerciseForm(
                                            id: widget.exercise.id),
                                      ));
                                },
                              ),
                            ),
                            SizedBox(width: 4),
                            FittedBox(
                              fit: BoxFit.contain,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                  ),
                                  primary: Colors.red,
                                  onPrimary: Colors.black,
                                ),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Provider.of<ExerciseListViewModel>(context,
                                          listen: false)
                                      .deleteExercise(widget.exercise.id)
                                      .then((value) {
                                    setState(() {
                                      exercises.remove(widget.exercise);
                                    });
                                  }).catchError((err) =>
                                          {print('Failed to delete exercise')});
                                },
                              ),
                            ),
                          ]),
                    ),
                  )
                : SizedBox(
                    height: 21,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(16.0),
                              ),
                              primary: Colors.amber,
                              onPrimary: Colors.black,
                            ),
                            child: Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                        create: (_) => ExerciseListViewModel(),
                                      ),
                                    ],
                                    child: ExerciseDetailsScreen(
                                        widget.exercise.id),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
