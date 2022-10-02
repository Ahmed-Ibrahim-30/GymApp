import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/screens/member/member-util.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../all_data.dart';
import '../bloc/Admin_cubit/admin_cubit.dart';
import '../bloc/coach_cubit/coach_cubit.dart';
import '../bloc/member_cubit/member_cubit.dart';
import '../constants.dart';
import '../screens/admin/util-screen.dart';
import '../screens/coach/coach-tabs-screen.dart';
import '../screens/nutritionist/util-screen.dart';
import '../services/supplementary-webservice.dart';
import '../widget/global.dart';

bool isEnter=false;
class SplachScreen extends StatefulWidget {
  static bool fetchAllFunction=false;
  const SplachScreen({Key key}) : super(key: key);

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  Future<void> getAllSupplementaries() async {
    supplementariesList = await SupplementaryWebService(Global.token).getAllSupplementaries();
  }

  void fetchMembersFunction()async{
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
  void fetchCoachFunction()async{
    if(!CoachTabsScreen.fetchAllFunction){
      await CoachCubit.get(context).fetchUserCoach();
      await CoachCubit.get(context).fetchAllBranches();
      await CoachCubit.get(context).fetchAllEquipments();
      await CoachCubit.get(context).fetchAllClasses();
      await CoachCubit.get(context).fetchAllAnnouncements();
      await CoachCubit.get(context).fetchAllQuestions();
      await getAllSupplementaries();
      await CoachCubit.get(context).fetchAllEvents(context);
      CoachTabsScreen.fetchAllFunction=true;
    }
  }
  Future<void> checkInternetConnection(BuildContext context)async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if(!isEnter){
          isEnter=true;
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
  void initState() {
    super.initState();
    if (Global.role == 'admin') {
      checkInternetConnection(context);
    }
    else if (Global.role == 'coach') {
      fetchCoachFunction();
    } else if (Global.role == 'nutritionist') {

    } else if (Global.role == 'member') {
      fetchMembersFunction();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset('assets/images/logo3.png',height: 90.h,width: 90.w,fit: BoxFit.fill,color: Colors.white,),

            SizedBox(height: MediaQuery.of(context).size.height / 20),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: LinearPercentIndicator(
                barRadius: const Radius.circular(30),
                width: MediaQuery.of(context).size.width - 40,
                animation: true,
                lineHeight: 7.0,
                animationDuration: 10000,
                percent: 1,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: myYellow2,
                onAnimationEnd: (){
                  if (Global.role == 'admin') {
                    goToAnotherScreenPush(context, AdminUtil());
                  }
                  else if (Global.role == 'coach') {
                    goToAnotherScreenPush(context, CoachTabsScreen());
                  } else if (Global.role == 'nutritionist') {
                    goToAnotherScreenPush(context, NutritionistUtil());
                  } else if (Global.role == 'member') {
                    goToAnotherScreenPush(context, MemberUtil());
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );
  }


}