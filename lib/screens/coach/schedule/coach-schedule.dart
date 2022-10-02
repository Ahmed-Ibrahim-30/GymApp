import 'package:flutter/material.dart';
import 'package:gym_project/common/my_list_tile.dart';
import 'package:gym_project/common/my_list_tile_without_counter.dart';
import 'package:gym_project/models/classes.dart';
import 'package:gym_project/models/event.dart';
import 'package:gym_project/models/privatesession.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/screens/Events/event-details.dart';
import 'package:gym_project/screens/admin/classes/class_details.dart';
import 'package:gym_project/screens/coach/schedule/classes-schedule.dart';
import 'package:gym_project/screens/coach/schedule/sessions-schedule.dart';
import 'package:gym_project/screens/common/view-private-session-details.dart';
import 'package:gym_project/style/datetime.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/viewmodels/coach-view-model.dart';
import 'package:gym_project/viewmodels/private-session-view-model.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';

import 'all-schedule.dart';
import 'event-schedule.dart';

class CoachSchedule extends StatefulWidget {
  @override
  _CoachScheduleState createState() => _CoachScheduleState();
}

class _CoachScheduleState extends State<CoachSchedule>
    with SingleTickerProviderStateMixin {
  final length = 4;

  TabController _myTabController;
  void initState() {
    super.initState();
    _myTabController = TabController(
      vsync: this,
      length: 4,
    );
  }

  void dispose() {
    _myTabController.dispose();
    super.dispose();
  }

  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
        title: Text(
          "Schedule",
          style: TextStyle(
              color: Colors.white, fontFamily: "assets/fonts/Changa-Bold.ttf"),
        ),
        backgroundColor: Colors.black,
        bottom: TabBar(
            unselectedLabelColor: Colors.amber,
            labelColor: Colors.amber,
            indicatorColor: Colors.amber,
            controller: _myTabController,
            tabs: [
              Tab(
                text: 'All',
              ),
              Tab(
                text: 'Classes',
              ),
              Tab(
                text: 'Events',
              ),
              Tab(
                text: "Private Sessions",
              ),
            ]),
      ),
      // floatingActionButton: Container(
      //   child: FloatingActionButton.extended(
      //     onPressed: () {
      //       Navigator.pushNamed(context, '/schedule');
      //     },
      //     isExtended: false,
      //     label: Icon(Icons.add),
      //   ),
      //   height: MediaQuery.of(context).size.height * 0.075,
      //   width: MediaQuery.of(context).size.width * 0.1,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: TabBarView(
        controller: _myTabController,
        children: [
          AllSchedule(),
          ClassesSchedule(),
          EventsSchedule(),
          PrivateSessionsSchedule(),
        ],
      ),
    );
  }
}
