import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MyTimeline extends StatefulWidget {
  List<dynamic> data;
  String stackBy;
  MyTimeline({Key key, this.data, this.stackBy}) : super(key: key);

  @override
  _MyTimelineState createState() => _MyTimelineState();
}

class _MyTimelineState extends State<MyTimeline> {
  Map<String, List<dynamic>> timelineItems = {};
  @override
  void initState() {
    widget.data.forEach((element) {
      DateTime now = DateTime.parse(element[widget.stackBy]);
      DateFormat formatter = DateFormat('MMM d - HH:mm');
      //DateFormat formatter = DateFormat.M();
      String formatted = formatter.format(now);
      String date = formatted.split(' - ')[0];
      String time = formatted.split(' - ')[1];
      if (!timelineItems.containsKey(date)) timelineItems[date] = [];
      timelineItems[date].add({"element": element, "time": time});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(timelineItems);
    return Container();
  }
}
