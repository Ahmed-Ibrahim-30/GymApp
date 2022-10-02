import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/event.dart';
import 'package:gym_project/screens/Events/events-tile.dart';
import 'package:gym_project/viewmodels/event-view-model.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:provider/provider.dart';

import '../../all_data.dart';
import '../../widget/global.dart';
import 'event-form.dart';

class EventListView extends StatefulWidget {
  final String title = 'Hicking Trip';
  final String price = "100\$";
  final String date = '25 Sep.';
  final String startTime = '7:00 AM';
  final String endTime = '10:00 AM';
  final String icon = '';
  List<Event> upcomingEvents = [];
  List<Event> previousEvents = [];

  EventListView();

  @override
  _EventListViewState createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    _tabController = TabController(
      length: tabs.length,
      initialIndex: 0,
      vsync: this,
    );
    _tabController.addListener(() {
      if (_tabController.index == 1)
        this.getUpcomingEvents();
      else if (_tabController.index == 2) this.getPreviousEvents();
    });
  }

  TabController _tabController;

  List<Widget> tabs = [
    Tab(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          // border: Border.all(color: Colors.amber, width: 1),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "All Events",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
    Tab(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          // border: Border.all(color: Colors.amber, width: 1),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "Upcoming",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
    Tab(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          // border: Border.all(color: Colors.amber, width: 1),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "Previous",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    )
  ];

  String formatDateTime(String DateTime) {
    //2021-09-13 14:13:51
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    String year = DateTime.substring(0, 4);
    String month = DateTime.substring(5, 7);
    String day = DateTime.substring(8, 10);
    String time = DateTime.substring(11, 16);
    return '$day ${months[int.parse(month) - 1]} $year $time';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Global.role == 'admin'
                ? Container(
                    child: FloatingActionButton(
                      onPressed: () {
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventForm('add', '', '',
                                      '', 0, '', '', '', 0, update, update)));
                        }
                      },
                      isExtended: false,
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.075,
                    width: MediaQuery.of(context).size.width * 0.1,
                  )
                : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        appBar: AppBar(
            title: Text(
              "Events",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "assets/fonts/Changa-Bold.ttf"),
            ),
            backgroundColor: Colors.black, //Color(0xff181818),
            iconTheme: IconThemeData(color: myYellow),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: Colors.amberAccent),
              tabs: tabs,
              controller: _tabController,
              labelColor: Colors.black,
              isScrollable: true,
              unselectedLabelColor: Colors.grey,
            )),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            allEvents.length > 0
                ? Container(
                    color: Colors.black,
                    height: 200,
                    padding: EdgeInsetsDirectional.all(10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: allEvents.length,
                        itemBuilder: (ctx, index) {
                          // print( formatDateTime(widget.allEvents[index].startTime));
                          return EventListTile(
                              allEvents[index].id,
                              allEvents[index].title,
                              allEvents[index].price,
                              formatDateTime(allEvents[index].startTime),
                              allEvents[index].ticketsAvailable,
                              allEvents[index].endTime.substring(11, 16),
                              allEvents[index].description,
                              widget.icon,
                              update);
                        }),
                  )
                : Center(
                    child: Text("No Events yet"),
                  ),
            widget.upcomingEvents.length > 0
                ? Container(
                    color: Colors.black,
                    height: 200,
                    padding: EdgeInsetsDirectional.all(10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.upcomingEvents.length,
                        itemBuilder: (ctx, index) {
                          return EventListTile(
                              allEvents[index].id,
                              widget.upcomingEvents[index].title,
                              widget.upcomingEvents[index].price,
                              formatDateTime(
                                  widget.upcomingEvents[index].startTime),
                              widget.upcomingEvents[index].ticketsAvailable,
                              widget.upcomingEvents[index].endTime
                                  .substring(11, 16),
                              widget.upcomingEvents[index].description,
                              widget.icon,
                              update);
                        }),
                  )
                : Center(
                    child: Text("No Upcoming Events for you"),
                  ),
            widget.previousEvents.length > 0
                ? Container(
                    color: Colors.black,
                    height: 200,
                    padding: EdgeInsetsDirectional.all(10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.previousEvents.length,
                        itemBuilder: (ctx, index) {
                          return EventListTile(
                              allEvents[index].id,
                              widget.previousEvents[index].title,
                              widget.previousEvents[index].price,
                              formatDateTime(
                                  widget.previousEvents[index].startTime),
                              widget.previousEvents[index].ticketsAvailable,
                              widget.previousEvents[index].endTime
                                  .substring(11, 16),
                              widget.previousEvents[index].description,
                              widget.icon,
                              update);
                        }),
                  )
                : Center(
                    child: Text("No Previous Events for you"),
                  ),
          ],
        ),
      ),
    );
  }


  Future<void> getUpcomingEvents() async {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<EventViewModel>(context, listen: false)
          .getUpcomingEvents(
              Global.token);
      setState(() {
        widget.upcomingEvents =
            Provider.of<EventViewModel>(context, listen: false).upcomingEvents;
      });
    });
  }

  Future<void> getPreviousEvents() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<EventViewModel>(context, listen: false)
          .getPreviousEvents(Global.token);
      setState(() {
        widget.previousEvents =
            Provider.of<EventViewModel>(context, listen: false).previousEvents;
      });
    });
  }

  void update() {
    setState(() {
      //getAllEvents();
    });
  }
}
