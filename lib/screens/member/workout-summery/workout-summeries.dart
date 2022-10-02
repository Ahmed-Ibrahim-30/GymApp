import 'package:gym_project/models/workout-summary.dart';
import 'package:gym_project/viewmodels/workout-summary-view-model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter/material.dart';

class WorkoutSummaries extends StatefulWidget {
  WorkoutSummaries({Key key}) : super(key: key);

  @override
  State<WorkoutSummaries> createState() => _WorkoutSummariesState();
}

class _WorkoutSummariesState extends State<WorkoutSummaries> {
  bool finishedLoading = false;

  var summariesList = [];
  int daysNumber;

  void fetchSummaries() {
    new Future<List<WorkoutSummary>>.sync(() =>
        Provider.of<WorkoutSummaryViewModel>(context, listen: false)
            .fetchSummaries()).then((List<WorkoutSummary> value) {
      setState(() {
        if (!finishedLoading) {
          summariesList = value;
          finishedLoading = true;
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSummaries();
  }

  final fitSummaries = [
    {'Calories': '153'},
    {'Calories': '286'},
    {'Calories': '555'},
    {'Calories': '555'},
    {'Calories': '555'},
    {'Calories': '555'},
    {'Calories': '555'},
  ];

  final processes = [
    {'name': 'Hello', 'isCompleted': false},
    {'name': 'Hello2', 'isCompleted': true}
  ];

  Widget Exam(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    if (finishedLoading) {}
    return SafeArea(
      child: Stack(
        children: [
          Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: new Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFFFCE2B),
                        size: 22.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      //-->header
                      child: new Text('Workout Summaries',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: 'sans-serif-light',
                              color: Colors.white)),
                    ),
                  ],
                ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 80),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xff181818),
              ),
              padding: const EdgeInsets.only(top: 16, left: 5),
              child: Center(
                child: Container(
                  width: isWideScreen ? 600 : double.infinity,
                  child: Stack(children: [
                    SingleChildScrollView(
                      child: FixedTimeline.tileBuilder(
                        theme: TimelineThemeData(
                          nodePosition: 0,
                          color: Colors.white24,
                          indicatorTheme: IndicatorThemeData(
                            position: 0,
                            size: 8.0,
                          ),
                          connectorTheme: ConnectorThemeData(
                            thickness: 2.5,
                          ),
                        ),
                        builder: TimelineTileBuilder.connected(
                          connectionDirection: ConnectionDirection.before,
                          itemCount: summariesList.length,
                          //builder
                          contentsBuilder: (_, index) {
                            return Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    DateFormat('EEEE')
                                            .format(summariesList[index].date) +
                                        ' ' +
                                        DateFormat('yyyy-MM-dd')
                                            .format(summariesList[index].date),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  FitnessSummaryWidget(
                                    context,
                                    summariesList[index].cal_burnt.toString(),
                                    summariesList[index].duration + " hours",
                                  )
                                ],
                              ),
                            );
                          },
                          indicatorBuilder: (_, index) {
                            return OutlinedDotIndicator(
                              color: Colors.white24,
                              borderWidth: 2.5,
                            );
                          },
                          connectorBuilder: (_, index, ___) => SolidLineConnector(
                            color: Colors.white24,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          // SafeArea(
          //   child: Align(
          //     alignment: Alignment.topLeft,
          //     child: Container(
          //       padding: EdgeInsets.all(20),
          //       child: Row(
          //         children: [
          //           InkWell(
          //             onTap: () {
          //               Navigator.pop(context);
          //             },
          //             child: new Icon(
          //               Icons.arrow_back_ios,
          //               color: Color(0xFFFFCE2B),
          //               size: 22.0,
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsets.only(left: 25.0),
          //             //-->header
          //             child: new Text('Workout Summaries',
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 20.0,
          //                     fontFamily: 'sans-serif-light',
          //                     color: Colors.white)),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget FitnessSummaryWidget(
      BuildContext context, String cal, String duration) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.black,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          // width: 400,
          // decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Calories Burnt',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            cal.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Duration',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            duration.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
              )),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: finishedLoading
            ? Center(
                child: Exam(context),
              )
            : Center(
                child: CircularProgressIndicator(
                color: Colors.amber,
              )),
      ),
    );
  }
}
