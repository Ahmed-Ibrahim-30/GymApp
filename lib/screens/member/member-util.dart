import 'package:animations/animations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/member_cubit/member_cubit.dart';
import 'package:gym_project/bloc/member_cubit/member_cubit.dart';
import 'package:gym_project/bloc/member_cubit/member_cubit.dart';
import 'package:gym_project/bloc/member_cubit/member_cubit.dart';
import 'package:gym_project/bloc/member_cubit/member_cubit.dart';
import 'package:gym_project/bloc/member_cubit/member_cubit.dart';

import 'package:gym_project/screens/member/home-screen.dart';
import 'package:gym_project/screens/member/schedule.dart';
import 'package:gym_project/screens/member/week-groups.dart';
import 'package:gym_project/screens/nutritionist/plan-schedule.dart';
import 'package:gym_project/widget/global.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../all_data.dart';
import '../../services/supplementary-webservice.dart';
import 'member-drawer.dart';
import 'member-others.dart';

class MemberUtil extends StatefulWidget {
  const MemberUtil({Key key}) : super(key: key);
  static bool fetchAllFunction=false;

  @override
  _MemberUtilState createState() => _MemberUtilState();
}

class _MemberUtilState extends State<MemberUtil> with TickerProviderStateMixin {
  //MotionTabController _tabController;
  int _selectedIndex = 0;
  Future<void> getAllSupplementaries() async {
    supplementariesList = await SupplementaryWebService(Global.token).getAllSupplementaries();
  }

  void fetchAllFunction()async{
    if(!MemberUtil.fetchAllFunction){
      await MemberCubit.get(context).fetchUserCoach();
      await MemberCubit.get(context).fetchAllBranches();
      await MemberCubit.get(context).fetchAllEquipments();
      await MemberCubit.get(context).fetchAllClasses();
      await MemberCubit.get(context).fetchAllAnnouncements();
      await MemberCubit.get(context).fetchAllQuestions();
      await getAllSupplementaries();
      await MemberCubit.get(context).fetchAllEvents(context);
      MemberUtil.fetchAllFunction=true;
    }
  }

  final _pages = [
    {
      'page': MemberHomeScreen(),
      'title': 'Homepage',
    },
    {
      'page': MemberSchedule(),
      'title': 'Schedule',
    },
    {
      'page': WeekGroups(),
      'title': 'Training Plan',
    },
    {
      'page': PlanSchedule(),
      'title': 'Diet Plan',
    },
    {
      'page': MemberOthers(),
      'title': 'Others',
    },
  ];
  @override
  void initState() {
    super.initState();
    //fetchAllFunction();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String name = Global.username;
  String email = Global.email;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          _pages[_selectedIndex]['title'],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff181818),
        iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
      ),
      drawer: MemberDrawer(name, email),
      body:  PageTransitionSwitcher(
        duration: const Duration(milliseconds: 900),
        transitionBuilder: (child,animation,secondaryAnimation){
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child:_pages[_selectedIndex]['page'],
      ),//
      bottomNavigationBar: CurvedNavigationBar(
        color: HexColor("E2DCC8"),
        height: 40.h,
        buttonBackgroundColor: HexColor("F8B400"),
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        index: _selectedIndex,
        animationDuration: Duration(milliseconds: 600),
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(Icons.home, size: 26.sp),
          Icon(Icons.schedule, size: 26.sp),
          Icon(Icons.sports, size: 26.sp),
          Icon(Icons.food_bank, size: 26.sp),
          Icon(Icons.view_list, size: 26.sp),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
