import 'package:flutter/material.dart';
import 'package:gym_project/screens/common/view-group-details-screen.dart';
import 'package:gym_project/screens/member/training-mode/training_mode_overview_screen.dart';
import 'package:gym_project/style/datetime.dart';
import 'package:gym_project/viewmodels/group-list-view-model.dart';
import 'package:gym_project/viewmodels/groups-view-model.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class WeekGroups extends StatefulWidget {
  @override
  _WeekGroupsState createState() => _WeekGroupsState();
}

class _WeekGroupsState extends State<WeekGroups> {
  // final List groups = [
  //   {
  //     'day': '18-09-2021',
  //     'title': 'Chest Group',
  //   },
  //   {
  //     'day': '19-09-2021',
  //     'title': 'Legs Group',
  //   },
  //   {
  //     'day': '20-09-2021',
  //     'title': 'Back Group',
  //   },
  //   {
  //     'day': '21-09-2021',
  //     'title': 'Arms Group',
  //   },
  //   {
  //     'day': '22-09-2021',
  //     'title': 'Full Body',
  //   },
  //   {
  //     'day': '23-09-2021',
  //     'title': 'Cardio',
  //   },
  //   {
  //     'day': '24-09-2021',
  //     'title': 'Group 7',
  //   },
  // ];

  // final List weekDays = [
  //   'Saturday',
  //   'Sunday',
  //   'Monday',
  //   'Tuesday',
  //   'Wednesday',
  //   'Thursday',
  //   'Friday',
  // ];

  List<GroupViewModel> tempGroups = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupsList();
  }

  bool done = false;

  bool error = false;
  bool isEmpty = false;

  var groupsViewModel;
  Map<String, List<GroupViewModel>> weekGroups = {
    'Sunday': [],
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
  };

  formatWeekGroups() {
    String currentDay;
    for (GroupViewModel group in tempGroups) {
      currentDay = DateFormat('EEEE').format(group.date);
      print(currentDay);
      weekGroups[currentDay].add(group);
    }
    done = true;
  }

  getGroupsList() {
    Provider.of<GroupListViewModel>(context, listen: false)
        .fetchWeekGroups()
        .then((value) {
      setState(() {
        groupsViewModel =
            Provider.of<GroupListViewModel>(context, listen: false);
        tempGroups = groupsViewModel.weekGroups;
        if (tempGroups.isEmpty) {
          done = true;
          isEmpty = true;
        } else {
          formatWeekGroups();
        }
      });
    }).catchError((err) {
      setState(() {
        error = true;
      });
      print('error occured $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Text(
                'This Week Groups',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            error
                ? CustomErrorWidget()
                : done && isEmpty
                    ? EmptyListError('No groups found.')
                    : !done
                        ? Progress()
                        : viewWeekGroups(context),
          ],
        ),
      ),
    );
  }

  Column viewWeekGroups(BuildContext context) {
    List<String> days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < days.length; i++) dayGroup(days[i], context),
      ],
    );
  }

  Column dayGroup(String day, BuildContext context) {
    List<GroupViewModel> dayGroups = weekGroups[day];
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        if (dayGroups.isEmpty)
          Center(
            child: Text(
              'No groups today',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        for (GroupViewModel group in dayGroups)
          CustomListTileWithTitleAndTrailing(
            'assets/images/branch.png',
            group,
          ),
        SizedBox(height: 10),
      ],
    );
  }
}

class CustomListTileWithTitleAndTrailing extends StatefulWidget {
  final String path;
  final GroupViewModel group;

  CustomListTileWithTitleAndTrailing(
    this.path,
    this.group,
  );

  @override
  _CustomListTileWithTitleAndTrailingState createState() =>
      _CustomListTileWithTitleAndTrailingState();
}

class _CustomListTileWithTitleAndTrailingState
    extends State<CustomListTileWithTitleAndTrailing> {
  int number = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
          minVerticalPadding: 10,
          leading: CircleAvatar(
            radius: 20,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  widget.path,
                  fit: BoxFit.cover,
                )),
          ),
          title: Text(
            widget.group.title,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupDetailsScreen(widget.group.id),
                    ),
                  );
                },
                child: Text(
                  'View Group Details',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          trailing: Container(
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TrainingModeOverviewScreen(1),
                        ),
                      );
                    },
                    child: Text(
                      'Start Training',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                // Expanded(
                //   child: Container(),
                // ),
                SizedBox(height: 5),
              ],
            ),
          )),
    );
  }
}
