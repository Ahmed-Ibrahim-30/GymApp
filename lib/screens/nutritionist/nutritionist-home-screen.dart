import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/models/classes.dart';
import 'package:gym_project/models/event.dart';
import 'package:gym_project/screens/Events/event-details.dart';
import 'package:gym_project/screens/admin/classes/class_details.dart';
import 'package:gym_project/viewmodels/event-view-model.dart';
import 'package:gym_project/widget/global.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';
import '../../style/styling.dart';
import '../../widget/popularCard.dart';

class NutritionistHomeScreen extends StatefulWidget {
  const NutritionistHomeScreen({Key key}) : super(key: key);

  @override
  NutritionistHomeScreenState createState() => NutritionistHomeScreenState();
}

class NutritionistHomeScreenState extends State<NutritionistHomeScreen> {
  @override
  void initState() {
    super.initState();

    getEventsList();
    getClassesList();
  }

  List<Event> events = [];
  List<Classes> classes = [];
  String name = Global.username;

  bool done = false;
  bool error = false;

  getEventsList() {
    String token = Global.token;
    Provider.of<EventViewModel>(context, listen: false)
        .getAllEvents(token)
        .then((value) {
      if (this.mounted) {
        setState(() {
          events =
              Provider.of<EventViewModel>(context, listen: false).allEvents;
          done = true;
        });
      }
    }).catchError((err) {
      setState(() {
        error = true;
      });
      print('error occured $err');
    });
  }

  getClassesList() {
    // Provider.of<ClassesListViewModel>(context, listen: false)
    //     .fetchListClasses()
    //     .then((value) {
    //   if (this.mounted) {
    //     setState(() {
    //       done = true;
    //       classes = Provider.of<ClassesListViewModel>(context, listen: false)
    //           .classesList;
    //     });
    //   }
    // }).catchError((err) {
    //   setState(() {
    //     error = true;
    //   });
    //   print('error occured $err');
    // });
    ///Todo Modifiy in it
  }

  @override
  Widget build(BuildContext context) {
    //Screen BreakPoint
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    width: isWideScreen ? 900 : double.infinity,
                    child: Column(
                      children: [
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: PadRadius.horizontal - 15,
                              vertical: PadRadius.horizontal - 15,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: "Welcome ",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Color(0xFFFFCE2B),
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: "$name",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white))
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        error
                            ? CustomErrorWidget()
                            : done && events.isEmpty && classes.isEmpty
                                ? EmptyListError('Nothing new to display.')
                                : events.isEmpty && classes.isEmpty
                                    ? Progress()
                                    : Align(
                                        alignment: Alignment.bottomCenter,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          //height: MediaQuery.of(context).size.height * 0.4,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    PadRadius.horizontal - 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (events.isNotEmpty)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Upcoming Events",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/events');
                                                          },
                                                          child: Text(
                                                            'See More',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFFFFCE2B),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ))
                                                    ],
                                                  ),
                                                if (events.isNotEmpty)
                                                  SizedBox(height: 20),
                                                if (events.isNotEmpty)
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    child: Row(children: [
                                                      for (Event event
                                                          in events)
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        EventDetailsScreen(
                                                                            event
                                                                                .id,
                                                                            event
                                                                                .title,
                                                                            event
                                                                                .price,
                                                                            event
                                                                                .ticketsAvailable,
                                                                            event.startTime.substring(0,
                                                                                11),
                                                                            event.startTime.substring(
                                                                                12),
                                                                            event
                                                                                .endTime,
                                                                            event.description,
                                                                            () {
                                                                          setState(
                                                                              () {});
                                                                        })));
                                                          },
                                                          child: PopularCard(
                                                            asset: "ht1",
                                                            title: event.title,
                                                          ),
                                                        )
                                                    ]),
                                                  ),
                                                if (events.isNotEmpty)
                                                  SizedBox(height: 20),
                                                if (classes.isNotEmpty)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Classes",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/class-list');
                                                          },
                                                          child: Text(
                                                            'See More',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFFFFCE2B),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ))
                                                    ],
                                                  ),
                                                if (classes.isNotEmpty)
                                                  SizedBox(height: 20),
                                                if (classes.isNotEmpty)
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    child: Row(
                                                      children: [
                                                        for (Classes c
                                                            in classes)
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ClassDetails(),
                                                                ),
                                                              );
                                                            },
                                                            child: PopularCard(
                                                              asset: "ht2",
                                                              title: c.title,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
