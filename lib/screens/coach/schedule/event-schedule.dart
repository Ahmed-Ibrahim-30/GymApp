import 'package:gym_project/common/my_list_tile.dart';
import 'package:gym_project/models/event.dart';
import 'package:gym_project/screens/Events/event-details.dart';
import 'package:gym_project/style/datetime.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/viewmodels/coach-view-model.dart';
import 'package:gym_project/widget/loading-widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class EventsSchedule extends StatefulWidget {
  @override
  _EventsScheduleState createState() => _EventsScheduleState();
}

class _EventsScheduleState extends State<EventsSchedule> {
  List<Event> events;
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
        events =
            Provider.of<CoachViewModel>(context, listen: false).schedule.item3;
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
                  : done && events.isEmpty
                      ? EmptyListError('Nothing scheduled.')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: events.length,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventDetailsScreen(
                                          events[index].id,
                                          events[index].title,
                                          events[index].price,
                                          events[index].ticketsAvailable,
                                          events[index]
                                              .startTime
                                              .substring(0, 11),
                                          events[index].startTime.substring(12),
                                          events[index].endTime,
                                          events[index].description,
                                          (() {}))),
                                );
                              },
                              child: CustomListTile(
                                events[index].title,
                                [
                                  formatDateTime(events[index].startTime),
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
