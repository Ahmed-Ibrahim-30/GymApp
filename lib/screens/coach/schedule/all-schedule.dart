import 'package:gym_project/common/my_list_tile.dart';
import 'package:gym_project/models/classes.dart';
import 'package:gym_project/models/event.dart';
import 'package:gym_project/models/privatesession.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/screens/Events/event-details.dart';
import 'package:gym_project/screens/admin/classes/class_details.dart';
import 'package:gym_project/screens/common/view-private-session-details.dart';
import 'package:gym_project/style/datetime.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/viewmodels/coach-view-model.dart';
import 'package:gym_project/viewmodels/private-session-view-model.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AllSchedule extends StatefulWidget {
  @override
  _AllScheduleState createState() => _AllScheduleState();
}

class _AllScheduleState extends State<AllSchedule> {
  List<PrivateSession> privateSessions = [];

  List<Classes> classes = [];

  List<Event> events = [];

  void initState() {
    super.initState();
    fetchSchedule();
  }

  bool done = false;
  bool error = false;

  fetchSchedule() {
    Provider.of<CoachViewModel>(context, listen: false)
        .fetchSchedule()
        .then((value) {
      setState(() {
        done = true;
        privateSessions =
            Provider.of<CoachViewModel>(context, listen: false).schedule.item1;
        events =
            Provider.of<CoachViewModel>(context, listen: false).schedule.item3;
        classes =
            Provider.of<CoachViewModel>(context, listen: false).schedule.item2;
      });
    }).catchError((err) {
      setState(() {
        error = true;
        showErrorMessage(context, 'Failed to load schedule!');
      });
      print('error occured $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    int length = privateSessions.length + classes.length + events.length;
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ListView(
        children: [
          SizedBox(height: 20),
          error
              ? CustomErrorWidget()
              : !done
                  ? Progress()
                  : done &&
                          privateSessions.isEmpty &&
                          classes.isEmpty &&
                          events.isEmpty
                      ? EmptyListError('Nothing scheduled.')
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              for (PrivateSession privateSession
                                  in privateSessions)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PrivateSessionDetailsScreen(
                                          PrivateSessionViewModel(
                                              privateS: privateSession),
                                        ),
                                      ),
                                    );
                                  },
                                  child: CustomListTile(
                                    privateSession.title,
                                    [
                                      formatDateTime(
                                          privateSession.dateTime.toString()),
                                      'Type: Private Session',
                                    ],
                                    trailing: '',
                                    iconData: Icons.event,
                                  ),
                                ),
                              for (Event event in events)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailsScreen(
                                                  event.id,
                                                  event.title,
                                                  event.price,
                                                  event.ticketsAvailable,
                                                  event.startTime
                                                      .substring(0, 11),
                                                  event.startTime.substring(12),
                                                  event.endTime,
                                                  event.description,
                                                  (() {}))),
                                    );
                                  },
                                  child: CustomListTile(
                                    event.title,
                                    [
                                      formatDateTime(event.startTime),
                                      'Type: Event',
                                    ],
                                    trailing: '',
                                    iconData: Icons.event,
                                  ),
                                ),
                              for (Classes c in classes)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ClassDetails(),
                                      ),
                                    );
                                  },
                                  child: CustomListTile(
                                    c.title,
                                    [
                                      formatDate(c.date.toString()),
                                      'Type: Class',
                                    ],
                                    trailing: '',
                                    iconData: Icons.event,
                                  ),
                                ),
                            ],
                          ),
                        )
          // : ListView.builder(
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     itemCount: length,
          //     itemBuilder: (ctx, index) {
          //       return InkWell(
          //         onTap: () {
          //           Navigator.pushNamed(context, '/class-details');
          //         },
          //         child: CustomListTileWithoutCounter(
          //             'assets/images/user_icon.png',
          //             this._titles[index],
          //             'Type:' + this._types[index],
          //             this._space,
          //             this._times[index]),
          //       );
          //     }),
        ],
      ),
    );
  }
}
