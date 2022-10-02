import 'package:animations/animations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/admin/users/create_user.dart';
import 'package:gym_project/screens/admin/users/users_list.dart';
import 'package:gym_project/screens/announcements/announcements-screen.dart';
import 'package:gym_project/widget/drawer.dart';
import 'package:gym_project/widget/global.dart';
import 'package:hexcolor/hexcolor.dart';
import '../announcements/add-announcement-screen.dart';
import 'HomeScreen/home_screen.dart';
import 'branches/branches_list.dart';
import 'branches/create_branch.dart';
import 'others.dart';
import 'dart:io';

bool isFetches=false;
class AdminUtil extends StatelessWidget  {

  final _pages = [
    {
      'page': AdminHome(),
      'title': 'Homepage',
    },
    {
      'page': UsersList(),
      'title': 'Users',
    },
    {
      'page': BranchesList(bar: false),
      'title': 'Branches',
    },
    {
      'page':AnnouncementsScreen(showAppBar: false),
      'title': 'Announcements',
    },
    {
      'page': Others(),
      'title': 'Others',
    },
  ];

  final String name = Global.username;
  final String email = Global.email;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  Future<void> checkInternetConnection(BuildContext context)async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if(!isFetches){
          isFetches=true;
          await AdminCubit.get(context).fetchAllUser();
          await AdminCubit.get(context).fetchAllBranches();
          await AdminCubit.get(context).fetchAllAnnouncements();
          await AdminCubit.get(context).fetchAllEquipments();
          await AdminCubit.get(context).fetchAllClasses();
          await AdminCubit.get(context).fetchAllNutritionistSessions();
          await AdminCubit.get(context).fetchAllMembersShips();
          await AdminCubit.get(context).fetchAllQuestions();
        }
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }


  @override
  Widget build(BuildContext context) {
    //checkInternetConnection(context);
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit myCubit=AdminCubit.get(context);
        return Scaffold(
          extendBody: true,
          backgroundColor: myBlack,
          appBar: AppBar(
            title: Text(
              _pages[myCubit.bottomNavBarIndex]['title'],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xff181818),
            iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
          ),
          floatingActionButton: myCubit.bottomNavBarIndex==1?
          floatingActionButtonUsers(context, myCubit):myCubit.bottomNavBarIndex==2?
          floatingActionButtonBranches(context,myCubit):myCubit.bottomNavBarIndex==3?
          floatingActionButtonAnnouncement(context,myCubit):null,
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          drawer: MyDrawer(name,email),
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 900),
              transitionBuilder: (child,animation,secondaryAnimation){
              return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                child: child,
              );
              },
            child: _pages[myCubit.bottomNavBarIndex]['page'],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            color: HexColor("E2DCC8"),
            height: 40.h,
            buttonBackgroundColor: HexColor("F8B400"),
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            index: myCubit.bottomNavBarIndex,
            animationDuration: Duration(milliseconds: 600),
            key: _bottomNavigationKey,
            items: <Widget>[
              Icon(Icons.home, size: 26.sp),
              Icon(Icons.supervised_user_circle, size: 26.sp),
              Icon(Icons.workspaces, size: 26.sp),
              Icon(Icons.announcement, size: 26.sp),
              Icon(Icons.view_list, size: 26.sp),
            ],
            onTap: myCubit.changeBottomNavBarIndex,
          ),
        );
      },
    );
  }
}


Widget floatingActionButtonUsers(BuildContext context,AdminCubit adminCubit){
  return Container(
    height: MediaQuery.of(context).size.height * 0.075,
    width: MediaQuery.of(context).size.width * 0.1,
    child: FloatingActionButton(
      onPressed: () {
        //goToAnotherScreenPush(context, UserCreate(adminCubit: myCubit,));
        Navigator.push(
          context,
          new MyCustomRoute2(builder: (context) => UserCreate(adminCubit: adminCubit,)),
        );
      },
      isExtended: false,
      child: Icon(
        Icons.add,
        color: Colors.black,
        size: 22.sp,
      ),
    ),
  );
}
Widget floatingActionButtonBranches(BuildContext context,AdminCubit adminCubit){
  return Container(
    height: MediaQuery.of(context).size.height * 0.075,
    width: MediaQuery.of(context).size.width * 0.1,
    child: FloatingActionButton(
      onPressed: () {
        goToAnotherScreenPush(context, BranchForm(adminCubit: adminCubit,));
      },
      isExtended: false,
      child: Icon(
        Icons.add,
        color: Colors.black,
      ),
    ),
  );
}
Widget floatingActionButtonAnnouncement(BuildContext context,AdminCubit adminCubit){
  return Container(
    height: MediaQuery.of(context).size.height * 0.075,
    width: MediaQuery.of(context).size.width * 0.1,
    child: FloatingActionButton(
      onPressed: () {
        goToAnotherScreenPush(context, AddAnnouncementScreen(
          post_type: 'Add',
          myCubit: adminCubit,
        ),);
      },
      child: Icon(
        Icons.add,
        color: Colors.black,
      ),
    ),
  );
}


