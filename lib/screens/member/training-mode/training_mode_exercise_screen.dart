import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gym_project/helper/general-helpers.dart';
import 'package:gym_project/screens/common/widget-builders.dart';

class TrainingModeExerciseScreen extends StatefulWidget {
  final String title;
  final Duration duration;
  final int reps;
  final String gif;
  final int index;
  final int total;
  final Function finishExercise;

  const TrainingModeExerciseScreen({
    Key key,
    @required this.title,
    @required this.duration,
    @required this.reps,
    @required this.gif,
    @required this.index,
    @required this.total,
    @required this.finishExercise,
  }) : super(key: key);

  @override
  _TrainingModeExerciseScreenState createState() =>
      _TrainingModeExerciseScreenState();
}

class _TrainingModeExerciseScreenState
    extends State<TrainingModeExerciseScreen> {
  bool _counterStarted = false;
  bool _counterFinished = false;
  Duration _duration;
  Timer _timer;

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    super.initState();
    _duration = widget.duration;
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => confirmPop(
        context,
        content:
            'Are you sure you want to leave the exercise?\nThe exercise would be cancelled.',
        doNotConfirmIf: !_counterStarted,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Training Mode - Exercises",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Container(
                color: Colors.black,
                width: double.infinity,
                height: double.infinity,
                child: Image.network(
                  widget.gif,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          Chip(
                            label: Text(
                              '${widget.index + 1} / ${widget.total}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            visualDensity: VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: _counterFinished
                      ? TextButton(
                          onPressed: () {
                            widget.finishExercise();
                          },
                          child: Text(
                            'Finish',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 22,
                            ),
                          ))
                      : !_counterStarted
                          ? TextButton(
                              onPressed: () {
                                setState(() => _counterStarted = true);
                                _timer = Timer.periodic(Duration(seconds: 1),
                                    (timer) {
                                  if (!_counterFinished) {
                                    setState(() {
                                      _duration = Duration(
                                          seconds: _duration.inSeconds - 1);
                                    });
                                  }
                                  if (_duration.inSeconds == 0) {
                                    setState(() => _counterFinished = true);
                                    timer.cancel();
                                  }
                                });
                              },
                              child: Text(
                                'Start',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 22,
                                ),
                              ),
                            )
                          : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.reps != 0)
                        Text(
                          'Reps: ${widget.reps}x',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                          ),
                        ),
                      Text(
                        'Time Left: ${printDuration(_duration)} / ${printDuration(widget.duration)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
