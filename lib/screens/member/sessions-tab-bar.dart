import 'package:flutter/material.dart';
import 'package:gym_project/screens/member/view-private-sessions-status.dart';
import 'package:gym_project/screens/member/view-private-sessions.dart';

class MemberSessionsScreen extends StatefulWidget {
  @override
  _MemberSessionsScreenState createState() => _MemberSessionsScreenState();
}

class _MemberSessionsScreenState extends State<MemberSessionsScreen>
    with TickerProviderStateMixin {
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
            "All Sessions",
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
            "Booked Sessions",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    _tabController = new TabController(length: 2, vsync: this);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              "Sessions",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "assets/fonts/Changa-Bold.ttf"),
            ),
            backgroundColor: Colors.black, //Color(0xff181818),
            iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.amber),
              ),
              tabs: tabs,
              controller: _tabController,
              labelColor: Colors.amber,
              isScrollable: true,
              unselectedLabelColor: Colors.white,
            )),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            ViewPrivateSessionsScreen(),
            ViewBookedSessionsScreen(),
          ],
        ),
      ),
    );
  }
}
