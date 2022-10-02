import 'dart:async';
import 'dart:math';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:gym_project/helper/constants.dart';
import 'package:gym_project/helper/general-helpers.dart';
import 'package:gym_project/models/group.dart';
import 'package:gym_project/models/nutritionist/plan.dart';
import 'package:gym_project/models/workout-summary.dart';
import 'package:gym_project/screens/coach/exercises/exercises_screen.dart';
import 'package:gym_project/screens/common/view-group-details-screen.dart';
import 'package:gym_project/screens/common/widget-builders.dart';
import 'package:gym_project/screens/member/training-mode/training_mode_exercise_screen.dart';
import 'package:gym_project/viewmodels/exercise-view-model.dart';
import 'package:gym_project/viewmodels/group-list-view-model.dart';
import 'package:gym_project/viewmodels/groups-view-model.dart';
import 'package:gym_project/viewmodels/workout-summary-view-model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrainingModeOverviewScreen extends StatefulWidget {
  TrainingModeOverviewScreen(this.groupId, {Key key}) : super(key: key);

  final int groupId;

  @override
  _TrainingModeOverviewScreenState createState() =>
      _TrainingModeOverviewScreenState();
}

class _TrainingModeOverviewScreenState
    extends State<TrainingModeOverviewScreen> {
  // exercises
  // {
  //   'title': 'Burpees',
  //   'duration': Duration(seconds: 3),
  //   'reps': null,
  //   'calories': 150,
  //   'gif': 'https://c.tenor.com/u2-VJiigKCkAAAAC/exercise-jump.gif',
  //   'image':
  //       'https://nutrispirit.net/wp-content/uploads/2018/04/Burpees-hombre-ka4C-U40987445606azE-560x420@MujerHoy.jpg',
  // },
  // {
  //   'title': 'Bicep Curls',
  //   'duration': null,
  //   'reps': 10,
  //   'calories': 100,
  //   'gif': 'https://thumbs.gfycat.com/FelineSaltyBat-max-1mb.gif',
  //   'image':
  //       'https://image.shutterstock.com/image-vector/man-doing-standing-dumbbell-bicep-260nw-1850250391.jpg',
  // },
  // {
  //   'title': 'Push Ups',
  //   'duration': Duration(seconds: 3),
  //   'reps': null,
  //   'calories': 150,
  //   'gif': 'https://c.tenor.com/gI-8qCUEko8AAAAC/pushup.gif',
  //   'image':
  //       'https://static.vecteezy.com/system/resources/previews/000/162/096/non_2x/man-doing-push-up-vector-illustration.jpg',
  // },
  // {
  //   'title': 'Lunges',
  //   'duration': null,
  //   'reps': 20,
  //   'calories': 150,
  //   'gif': 'https://c.tenor.com/meIUZZ_2oZMAAAAC/lunge-jump.gif',
  //   'image':
  //       'https://images.assetsdelivery.com/compings_v2/artinspiring/artinspiring1903/artinspiring190300562.jpg',
  // },

  List<ExerciseViewModel> _exercises = [];
  int _currentExerciseIndex = 0;
  bool _groupFinished = false;
  Duration _timeElapased = Duration(seconds: 0);
  Timer _timer;
  Timer tileTimer;
  int _completedExercises = 0;
  bool _groupStarted = false;
  bool backLayerRevealed = false;
  GroupViewModel groupVM;

  //with hours
  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  ExerciseViewModel get currentExercise {
    return _exercises[_currentExerciseIndex];
  }

  double get currentCaloriesBurnt {
    return _exercises
        .take(_completedExercises)
        .map((exerciseVM) => exerciseVM.calBurnt)
        .fold(0, (previousValue, calories) => previousValue + calories);
  }

  void finishExercise() {
    _completedExercises++;
    setState(() {
      if (_currentExerciseIndex + 1 < _exercises.length) {
        _currentExerciseIndex += 1;
        Navigator.of(context).pop();
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, _, __) => TrainingModeExerciseScreen(
              title: currentExercise.title,
              duration: parseDuration(currentExercise.duration),
              reps: currentExercise.reps,
              gif: currentExercise.gif,
              index: _currentExerciseIndex,
              total: _exercises.length,
              finishExercise: finishExercise,
            ),
          ),
        );
      } else {
        finishGroup();
      }
    });
  }

  void finishGroup() {
    _groupFinished = true;
    _timer.cancel();
    Provider.of<WorkoutSummaryViewModel>(context, listen: false)
        .postWorkoutSummary(
            WorkoutSummary(
              cal_burnt: currentCaloriesBurnt,
              date: DateTime.now(),
              duration: printDuration(_timeElapased),
            ),
            getToken(context));
    Navigator.of(context).pop();
  }

  void startGroup() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _timeElapased = Duration(seconds: _timeElapased.inSeconds + 1);
    });
    setState(() {
      _groupStarted = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (tileTimer != null) tileTimer.cancel();
    if (_timer != null) _timer.cancel();
  }

  @override
  void initState() {
    super.initState();

    GroupListViewModel groupListVM =
        Provider.of<GroupListViewModel>(context, listen: false);
    groupListVM.fetchGroupDetails(widget.groupId).then((_) {
      groupVM = groupListVM.group;
      _exercises = groupVM.allExercises;
    });

  }

  

  @override
  Widget build(BuildContext context) {
    GroupListViewModel groupListVM = Provider.of<GroupListViewModel>(context);
    return WillPopScope(
      onWillPop: () => confirmPop(
        context,
        content:
            'Are you sure you want to exit Training Mode?\nYou will lose all your progress.',
        doNotConfirmIf: backLayerRevealed || _groupFinished,
      ),
      child: BackdropScaffold(
        onBackLayerConcealed: () => backLayerRevealed = false,
        onBackLayerRevealed: () => backLayerRevealed = true,
        appBar: AppBar(
          title: Text("Training Mode",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            BackdropToggleButton(
              icon: AnimatedIcons.list_view,
              color: Colors.white,
            )
          ],
        ),
        backLayer: groupListVM.loadingStatus == LoadingStatus.Searching
            ? loadingContainer(context)
            : !_groupStarted
                ? Container(
                    padding: EdgeInsets.all(30),
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Group isn\'t started yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: startGroup,
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            'Start The Group Now',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  )
                : _groupFinished
                    ? Container(
                        padding: EdgeInsets.all(30),
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Congratulations!',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 25),
                            Text(
                              'You have completed this workout',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(height: 25),
                            Icon(
                              Icons.celebration,
                              size: 150,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                            )
                          ],
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50,
                            color: Colors.black,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${currentExercise.title}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Chip(
                                  label: Text(
                                    '${_currentExerciseIndex + 1} / ${_exercises.length}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  visualDensity: VisualDensity(
                                    horizontal: -4,
                                    vertical: -4,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              color: Colors.black,
                              child: Image.network(
                                currentExercise.gif,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.black,
                            alignment: Alignment.center,
                            child: InkButton(
                              currentExercise,
                              finishExercise,
                              index: _currentExerciseIndex,
                              total: _exercises.length,
                            ),
                          ),
                        ],
                      ),
        frontLayer: groupListVM.loadingStatus == LoadingStatus.Searching
            ? loadingContainer(context)
            : Center(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        groupVM.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        groupVM.description,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Workout Summary',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WorkoutSummaryTile(
                            title: '${currentCaloriesBurnt.toStringAsFixed(2)}',
                            subtitle: 'Calories Burnt',
                          ),
                          StatefulBuilder(builder: (context, setTileState) {
                      if (tileTimer != null && tileTimer.isActive)
                              tileTimer.cancel();
                            if (_groupStarted && !_groupFinished) {
                        tileTimer = Timer(
                                      Duration(seconds: 1),
                                  () => setTileState(() {}));
                            }
                            return WorkoutSummaryTile(
                              title: printDuration(_timeElapased),
                              subtitle: 'Ellapsed',
                            );
                          }),
                          WorkoutSummaryTile(
                            title:
                                '$_completedExercises / ${_exercises.length}',
                            subtitle: 'Exercises Done',
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(height: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (!_groupStarted)
                              // using a Builder to give a different context to Backfrop.of()
                              Builder(
                                builder: (context) => ElevatedButton(
                                  onPressed: () {
                                    startGroup();
                                    Backdrop.of(context).revealBackLayer();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  child: Text(
                                    'Start',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            if (_groupFinished)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Workout Completed',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Icon(Icons.check,
                                      size: 30, color: Colors.green)
                                ],
                              ),
                            Container(
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GroupDetailsScreen(
                                                    groupVM.id)));
                                  },
                                  child: Text(
                                    'View Group Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}

class InkButton extends StatelessWidget {
  const InkButton(
    this.currentExercise,
    this.finishExercise, {
    @required this.total,
    @required this.index,
    Key key,
  }) : super(key: key);

  final ExerciseViewModel currentExercise;
  final Function finishExercise;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    // used Material, Ink and InkWell instead of Elevated Button
    // there is an issue with ElevatedButton and the backdrop package
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        width: 150,
        height: 30,
        child: Center(
          child: InkWell(
            splashColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => TrainingModeExerciseScreen(
                    title: currentExercise.title,
                    duration: parseDuration(currentExercise.duration),
                    reps: currentExercise.reps,
                    gif: currentExercise.gif,
                    index: index,
                    total: total,
                    finishExercise: finishExercise,
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Go To Next Exercise',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WorkoutSummaryTile extends StatelessWidget {
  const WorkoutSummaryTile({
    @required this.title,
    @required this.subtitle,
    Key key,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xff333333),
      child: Container(
        height: 75,
        width: 75,
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
