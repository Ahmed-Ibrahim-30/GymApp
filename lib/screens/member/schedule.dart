import 'package:flutter/material.dart';
import 'package:gym_project/common/my_list_tile_without_counter.dart';

class MemberSchedule extends StatefulWidget {
  @override
  _MemberScheduleState createState() => _MemberScheduleState();
}

class _MemberScheduleState extends State<MemberSchedule>
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
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: new Size(0, 0),
          child: Container(
            child: TabBar(
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
                    text: "Sessions",
                  ),
                  // Tab(
                  //   text: "Nut. Sessions",
                  // )
                ]),
          ),
        ),
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
          // NutritionistsSessionsSchedule(),
        ],
      ),
    );
  }
}

class AllSchedule extends StatelessWidget {
  final length = 10;
  final List<String> _titles = [
    'Yoga',
    'Zumba',
    'Abs',
    'Power Lifting Contest',
    'Diet Plan',
    'Yoga',
    'Zumba',
    'Abs',
    'Power Lifting Contest',
    'Cardio',
  ];
  final List<String> _types = [
    'Class',
    'Online Class',
    'Class',
    'Event',
    'Nutritionist Session',
    'Class',
    'Online Class',
    'Class',
    'Event',
    'Private Session',
  ];
  final String _space = ' ';
  final List<String> _times = [
    '10:30 AM',
    '11:30 PM',
    '12:30 PM',
    '1:00 PM',
    '1:30 AM',
    '2:00 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ListView(
        children: [
          SizedBox(height: 20),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, '/class-details');
                  },
                  child: CustomListTileWithoutCounter(
                      'assets/images/user_icon.png',
                      this._titles[index],
                      'Type:' + this._types[index],
                      this._space,
                      this._times[index]),
                );
              }),
        ],
      ),
    );
  }
}

class ClassesSchedule extends StatelessWidget {
  final List<String> _titles = [
    'Yoga',
    'Zumba',
    'Abs',
    'Yoga',
    'Zumba',
    'Abs',
  ];
  final List<String> _types = [
    'Class',
    'Online Class',
    'Class',
    'Class',
    'Online Class',
    'Class',
  ];
  final List<String> _spaces = [
    ' ',
    ' ',
    ' ',
    ' ',
    ' ',
    ' ',
  ];
  final List<String> _times = [
    '10:30 AM',
    '11:30 PM',
    '12:30 PM',
    '2:00 PM',
    '3:00 PM',
    '3:30 PM',
  ];

  final length = 6;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ListView(
        children: [
         
          SizedBox(height: 20),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, '/class-details');
                  },
                  child: CustomListTileWithoutCounter(
                      'assets/images/user_icon.png',
                      this._titles[index],
                      'Type:' + this._types[index],
                      this._spaces[index],
                      this._times[index]),
                );
              }),
        ],
      ),
    );
  }
}

class EventsSchedule extends StatelessWidget {
  final length = 2;
  final List<String> _titles = [
    'Power Lifting Contest',
    'Power Lifting Contest',
  ];
  final List<String> _types = [
    'Event',
    'Event',
  ];
  final List<String> _spaces = [
    ' ',
    ' ',
  ];
  final List<String> _times = ['1:00 PM', '4:00 PM'];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ListView(
        children: [
          
          SizedBox(height: 20),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, '/event-details');
                  },
                  child: CustomListTileWithoutCounter(
                      'assets/images/user_icon.png',
                      this._titles[index],
                      'Type:' + this._types[index],
                      this._spaces[index],
                      this._times[index]),
                );
              }),
        ],
      ),
    );
  }
}

class NutritionistsSessionsSchedule extends StatelessWidget {
  final length = 1;
  final List<String> _titles = [
    'Diet Plan',
  ];
  final List<String> _types = [
    'Nutritionist Session',
  ];
  final List<String> _spaces = [
    ' ',
  ];
  final List<String> _times = [
    '1:30 AM',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ListView(
        children: [
          
          SizedBox(height: 20),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {},
                  child: CustomListTileWithoutCounter(
                      'assets/images/user_icon.png',
                      this._titles[index],
                      'Type:' + this._types[index],
                      this._spaces[index],
                      this._times[index]),
                );
              }),
        ],
      ),
    );
  }
}

class PrivateSessionsSchedule extends StatelessWidget {
  final length = 1;
  final List<String> _titles = [
    'Cardio',
  ];
  final List<String> _types = [
    'Private Session',
  ];
  final List<String> _spaces = [
    ' ',
  ];
  final List<String> _times = [
    '1:30 AM',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ListView(
        children: [
          
          SizedBox(height: 20),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    // Navigator.pushNamed(context, '/session-details');
                  },
                  child: CustomListTileWithoutCounter(
                      'assets/images/user_icon.png',
                      this._titles[index],
                      'Type:' + this._types[index],
                      this._spaces[index],
                      this._times[index]),
                );
              }),
        ],
      ),
    );
  }
}
