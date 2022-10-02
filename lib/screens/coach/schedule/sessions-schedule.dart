import 'package:gym_project/common/my_list_tile.dart';
import 'package:gym_project/models/privatesession.dart';
import 'package:gym_project/screens/common/view-private-session-details.dart';
import 'package:gym_project/style/datetime.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/viewmodels/coach-view-model.dart';
import 'package:gym_project/viewmodels/private-session-view-model.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class PrivateSessionsSchedule extends StatefulWidget {
  @override
  _PrivateSessionsScheduleState createState() =>
      _PrivateSessionsScheduleState();
}

class _PrivateSessionsScheduleState extends State<PrivateSessionsSchedule> {
  List<PrivateSession> privateSessions;

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
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ListView(
        children: [
          SizedBox(height: 20),
          error
              ? CustomErrorWidget()
              : !done
                  ? Progress()
                  : done && privateSessions.isEmpty
                      ? EmptyListError('Nothing scheduled.')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: privateSessions.length,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PrivateSessionDetailsScreen(
                                      PrivateSessionViewModel(
                                          privateS: privateSessions[index]),
                                    ),
                                  ),
                                );
                              },
                              child: CustomListTile(
                                privateSessions[index].title,
                                [
                                  formatDateTime(privateSessions[index]
                                      .dateTime
                                      .toString()),
                                ],
                                trailing: '',
                                iconData: Icons.event,
                              ),
                            );
                          }),
        ],
      ),
    );
  }
}
