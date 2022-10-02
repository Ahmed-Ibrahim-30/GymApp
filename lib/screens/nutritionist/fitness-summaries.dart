import 'package:dots_indicator/dots_indicator.dart';
import 'package:gym_project/screens/nutritionist/fitness-summary.dart';
import 'package:gym_project/style/datetime.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/viewmodels/fitness-summary-list-view-model.dart';
import 'package:gym_project/viewmodels/fitness-summary-view-model.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter/material.dart';

import '../../widget/global.dart';

class FitnessSummariesScreen extends StatefulWidget {
  FitnessSummariesScreen({Key key}) : super(key: key);

  @override
  _FitnessSummariesScreenState createState() => _FitnessSummariesScreenState();
}

List<FitnessSummaryViewModel> fitSummaries = [];

final processes = [
  {'name': 'Hello', 'isCompleted': false},
  {'name': 'Hello2', 'isCompleted': true}
];

class _FitnessSummariesScreenState extends State<FitnessSummariesScreen> {
  // var fitSummaries = [
  //   {'Calories': '153', 'BMI': '23', 'SMM': '49', 'Protein': '22'},
  //   {'Calories': '286', 'BMI': '46', 'SMM': '12', 'Protein': '49'},
  //   {'Calories': '555', 'BMI': '17', 'SMM': '63', 'Protein': '13'},
  //   {'Calories': '555', 'BMI': '17', 'SMM': '63', 'Protein': '22'},
  //   {'Calories': '555', 'BMI': '17', 'SMM': '63', 'Protein': '22'},
  //   {'Calories': '555', 'BMI': '17', 'SMM': '63', 'Protein': '22'},
  //   {'Calories': '555', 'BMI': '17', 'SMM': '63', 'Protein': '22'},
  // ];

  // var processes = [
  //   {'name': 'Hello', 'isCompleted': false},
  //   {'name': 'Hello2', 'isCompleted': true}
  // ];
  String role;

  void initState() {
    super.initState();
    getFitnessSummariesList(1, startDate, endDate);
    role = Global.role;
    _currentPosition = 0;
  }

  refresh() {
    setState(() {});
  }

  String startDate;

  String endDate;

  double _currentPosition = 0;

  bool done = false;

  bool error = false;

  int lastPage;

  var fitnessSummaryViewModel;

  getFitnessSummariesList(int page, String startDate, String endDate) {
    Provider.of<FitnessSummaryListViewModel>(context, listen: false)
        .fetchListFitnessSummaries(page, startDate, endDate)
        .then((value) {
      fitnessSummaryViewModel =
          Provider.of<FitnessSummaryListViewModel>(context, listen: false);
      setState(() {
        done = true;
        fitSummaries = fitnessSummaryViewModel.fitnessSummaries;
        lastPage = fitnessSummaryViewModel.lastPage;
      });
    }).catchError((err) {
      error = true;
      print('error occured $err');
    });
  }

  deleteFitnessSummary(FitnessSummaryViewModel fitSum) {
    Provider.of<FitnessSummaryListViewModel>(context, listen: false)
        .deleteFitnessSummary(fitSum.id)
        .then((value) {
      setState(() {
        fitSummaries.remove(fitSum);
      });
    }).catchError((err) {
      showErrorMessage(context, 'Failed to delete fitness summary!');
    });
  }

  // Widget Exam(BuildContext context) {
  //   return
  // }

  Widget fitnessSummaryWidget(
      BuildContext context, FitnessSummaryViewModel fitSum) {
    return GestureDetector(
      onTapUp: (TapUpDetails tapUpDetails) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FitnessSummaryScreen(fitSum.id)));
      },
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatTime(fitSum.updatedAt),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(width: 60),
                  TextButton(
                    onPressed: () => {deleteFitnessSummary(fitSum)},
                    child: Text('Delete',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 5),
              if (role == 'nutritionist')
                Text(
                  'Member: ${fitSum.memberName}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              if (role == 'nutritionist')
                SizedBox(
                  height: 5,
                ),
              IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Column(
                    //     children: [
                    //       Text('Calories',
                    //           style: TextStyle(
                    //             color: Colors.white,
                    //           )),
                    //       Text(
                    //         fitSum['Calories'],
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             color: Theme.of(context).primaryColor),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // VerticalDivider(
                    //   color: Colors.white24,
                    // ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('BMI',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            Text(
                              fitSum.BMI.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.white24,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('SMM',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            Text(
                              fitSum.SMM.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.white24,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Protein',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              fitSum.protein.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.white24,
                    ),
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Column(
                    //       children: [
                    //         Text(
                    //           'Fat Ratio',
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //         Text(
                    //           fitSum.fatRatio.toString(),
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               color: Theme.of(context).primaryColor),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
    const decorator = DotsDecorator(
      activeColor: Colors.amber,
    );
    double topPadding = role != 'nutritionist' ? 80 : 20;
    return Theme(
      data: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
              )),
      child: Scaffold(
        floatingActionButton: Container(
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, '/create-fitness-summary');
            },
            isExtended: false,
            label: Icon(Icons.add,color: Colors.black,),
            backgroundColor: Colors.amber,
          ),
          height: MediaQuery.of(context).size.height * 0.075,
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 20, left: 20, right: 20, top: topPadding),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xff181818),
                    ),
                    padding: const EdgeInsets.only(top: 16, left: 5),
                    child: Stack(children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            (error)
                                ? Center(
                                    child: Text(
                                      'An error occurred',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : (done && fitSummaries.isEmpty)
                                    ? Center(
                                        child: Text(
                                          'No fitness summaries found',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : (fitSummaries.isEmpty)
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            child: FixedTimeline.tileBuilder(
                                              theme: TimelineThemeData(
                                                nodePosition: 0,
                                                color: Colors.white24,
                                                indicatorTheme:
                                                    IndicatorThemeData(
                                                  position: 0,
                                                  size: 8.0,
                                                ),
                                                connectorTheme:
                                                    ConnectorThemeData(
                                                  thickness: 2.5,
                                                ),
                                              ),
                                              builder:
                                                  TimelineTileBuilder.connected(
                                                connectionDirection:
                                                    ConnectionDirection.before,
                                                itemCount: fitSummaries.length,
                                                contentsBuilder: (_, index) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          formatDate(
                                                              fitSummaries[
                                                                      index]
                                                                  .updatedAt),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        fitnessSummaryWidget(
                                                            context,
                                                            fitSummaries[
                                                                index]),
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
                                                connectorBuilder:
                                                    (_, index, ___) =>
                                                        SolidLineConnector(
                                                  color: Colors.white24,
                                                ),
                                              ),
                                            ),
                                          ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
                if (role != 'nutritionist')
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
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
                            child: new Text('Fitness Summaries',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    fontFamily: 'sans-serif-light',
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:gym_project/core/presentation/res/colors.dart';
// import 'package:gym_project/models/fitness-summary.dart';
// import 'package:gym_project/screens/nutritionist/fitness-summary.dart';
// import 'package:gym_project/viewmodels/fitness-summary-list-view-model.dart';
// import 'package:provider/provider.dart';
// import 'package:timelines/timelines.dart';
// import 'package:flutter/material.dart';

// class FitnessSummariesScreen extends StatefulWidget {
//   FitnessSummariesScreen({Key key}) : super(key: key);

//   @override
//   _FitnessSummariesScreenState createState() => _FitnessSummariesScreenState();
// }

// List<FitnessSummary> fitSummaries = [];

// final processes = [
//   {'name': 'Hello', 'isCompleted': false},
//   {'name': 'Hello2', 'isCompleted': true}
// ];

// class _FitnessSummariesScreenState extends State<FitnessSummariesScreen> {
//   String startDate;
//   String endDate;
//   double _currentPosition = 0;
//   bool done = false;
//   bool error = false;
//   int lastPage;
//   var fitnessSummaryViewModel;
//   // getFitnessSummariesList(int page, String startDate, String endDate) {
//   //   Provider.of<FitnessSummaryListViewModel>(context, listen: false)
//   //       .fetchListFitnessSummaries(page, startDate, endDate)
//   //       .then((value) {
//   //     fitnessSummaryViewModel =
//   //         Provider.of<FitnessSummaryListViewModel>(context, listen: false);
//   //     setState(() {
//   //       done = true;
//   //       fitSummaries = fitnessSummaryViewModel.fitnessSummaries;
//   //       lastPage = fitnessSummaryViewModel.lastPage;
//   //     });
//   //   }).catchError((err) {
//   //     error = true;
//   //     print('error occured $err');
//   //   });
//   // }

//   Widget Exam(BuildContext context) {
//     return Stack(
//       children: [
//         Padding(
//           padding:
//               const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 80),
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               color: Color(0xff181818),
//             ),
//             padding: const EdgeInsets.only(top: 16, left: 5),
//             child: Stack(children: [
//               SingleChildScrollView(
//                 child: FixedTimeline.tileBuilder(
//                   theme: TimelineThemeData(
//                     nodePosition: 0,
//                     color: Colors.white24,
//                     indicatorTheme: IndicatorThemeData(
//                       position: 0,
//                       size: 8.0,
//                     ),
//                     connectorTheme: ConnectorThemeData(
//                       thickness: 2.5,
//                     ),
//                   ),
//                   builder: TimelineTileBuilder.connected(
//                     connectionDirection: ConnectionDirection.before,
//                     itemCount: fitSummaries.length,
//                     contentsBuilder: (_, index) {
//                       return Padding(
//                         padding: EdgeInsets.only(left: 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'August 2' + index.toString(),
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             fitnessSummaryWidget(context, fitSummaries[index]),
//                           ],
//                         ),
//                       );
//                     },
//                     indicatorBuilder: (_, index) {
//                       return OutlinedDotIndicator(
//                         color: Colors.white24,
//                         borderWidth: 2.5,
//                       );
//                     },
//                     connectorBuilder: (_, index, ___) => SolidLineConnector(
//                       color: Colors.white24,
//                     ),
//                   ),
//                 ),
//               ),
//             ]),
//           ),
//         ),
//         Align(
//           alignment: Alignment.topLeft,
//           child: Container(
//             padding: EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: new Icon(
//                     Icons.arrow_back_ios,
//                     color: Color(0xFFFFCE2B),
//                     size: 22.0,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 25.0),
//                   //-->header
//                   child: new Text('Fitness Summaries',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20.0,
//                           fontFamily: 'sans-serif-light',
//                           color: Colors.white)),
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget fitnessSummaryWidget(BuildContext context, dynamic fitSum) {
//     return GestureDetector(
//       onTapUp: (TapUpDetails tapUpDetails) {
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => FitnessSummaryScreen()));
//       },
//       child: Card(
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.black,
//             border: Border.all(color: Colors.black12),
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//           ),
//           // width: 400,
//           // decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
//           padding: EdgeInsets.symmetric(
//             vertical: 5,
//             horizontal: 10,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     '9:41',
//                     style: TextStyle(color: Theme.of(context).primaryColor),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 5),
//               IntrinsicHeight(
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Text('Calories',
//                               style: TextStyle(
//                                 color: Colors.white,
//                               )),
//                           Text(
//                             fitSum['Calories'],
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor),
//                           ),
//                         ],
//                       ),
//                     ),
//                     VerticalDivider(
//                       color: Colors.white24,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Text('BMI',
//                               style: TextStyle(
//                                 color: Colors.white,
//                               )),
//                           Text(
//                             fitSum['BMI'],
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor),
//                           ),
//                         ],
//                       ),
//                     ),
//                     VerticalDivider(
//                       color: Colors.white24,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Text('SMM',
//                               style: TextStyle(
//                                 color: Colors.white,
//                               )),
//                           Text(
//                             fitSum['SMM'],
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor),
//                           ),
//                         ],
//                       ),
//                     ),
//                     VerticalDivider(
//                       color: Colors.white24,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Protein',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           Text(
//                             fitSum['Protein'],
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: ThemeData(
//           textTheme: Theme.of(context).textTheme.apply(
//                 bodyColor: Colors.black,
//               )),
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: SafeArea(
//           child: Center(
//             child: Exam(context),
//           ),
//         ),
//       ),
//     );
//   }
// }
