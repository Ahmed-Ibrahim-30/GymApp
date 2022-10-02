import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/Events/event-details.dart';
import 'package:gym_project/viewmodels/event-view-model.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:provider/provider.dart';

import '../../widget/global.dart';

class EventListTile extends StatefulWidget {
  final String title;
  final String price;
  final String date;
  final int tickets;
  final String icon;
  final String endTime;
  final String description;
  final int id;
  void Function() update;

  EventListTile(this.id, this.title, this.price, this.date, this.tickets,
      this.endTime, this.description, this.icon, this.update);
  @override
  _EventListTileState createState() => _EventListTileState();
}

class _EventListTileState extends State<EventListTile> {
  int number = 0;
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        margin: EdgeInsetsDirectional.only(bottom: 10),
        decoration: BoxDecoration(
          color: myGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          minVerticalPadding: 10,
          leading: CircleAvatar(
            radius: 20.r,
            child: FlutterLogo(),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  widget.title.length > 25
                      ? '${widget.title.substring(0, 25)}...'
                      : widget.title,
                  style: TextStyle(
                      color: Colors.amberAccent,
                      fontFamily: 'assets/fonts/Changa-Bold.ttf'),
                  overflow: TextOverflow.clip,
                ),
              ),
              Text(
                widget.price,
                style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf'),
                overflow: TextOverflow.clip,
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    widget.date.substring(0, 11),
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    widget.date.substring(12),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Provider.of<EventViewModel>(context, listen: false)
                      .deleteEvent(
                          widget.id,
                          Provider.of<LoginViewModel>(context, listen: false)
                              .token);
                  setState(() {
                    widget.update();
                    // isVisible=false;
                  });
                },
                child: Global.role ==
                        'admin'
                    ? new Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 22.0,
                      )
                    : Container(),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EventDetailsScreen(
                        widget.id,
                        widget.title,
                        widget.price,
                        widget.tickets,
                        widget.date.substring(0, 11),
                        widget.date.substring(12),
                        widget.endTime,
                        widget.description,
                        widget.update)));
          },
        ),
      ),
    );
  }
}
