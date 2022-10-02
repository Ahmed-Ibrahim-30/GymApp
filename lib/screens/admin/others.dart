import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import 'package:gym_project/common/my_list_tile_without_counter.dart';
import 'package:gym_project/common/only_title_card.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/admin/equipment/equipment_list.dart';
import 'package:gym_project/screens/admin/memberships/memberships_list.dart';
import 'package:gym_project/screens/admin/view-private-session-requests.dart';

import '../../all_data.dart';
import '../Events/events-list.dart';
import '../Feedbacks/feedback-list.dart';
import '../Invitations/invitation-list.dart';
import '../Supplements/supplement-grid-view.dart';
import '../coach/groups/view-groups.dart';
import '../nutritionist/plans-screen.dart';
import '../questions/questions-screen.dart';
import 'classes/classes_list.dart';
import 'nutritionist_sessions/nutritionist_sessions_list.dart';


class Others extends StatelessWidget {
  final titles = [
    "Classes",
    "Equipment",
    "Nutritionist\n  Sessions",
    "Memberships",
    "Private sessions",
    "Exercise Groups",
    "Diet Plans",
    "Q&A",
    "Supplements",
    "Invitations",
    "Events",
    "Feedbacks",
  ];

  final imgPaths = [
    "assets/images/image4.jpg",
    "assets/images/others-supplements.png",
    "assets/images/session.jpg",
    "assets/images/membership-others.jpg",
    "assets/images/session.jpg",
    "assets/images/others-inventory.png",
    "assets/images/others-plans.jpg",
    "assets/images/others-questions.png",
    "assets/images/others-supplements.png",
    "assets/images/others-invite.jpg",
    "assets/images/others-schedule.png",
    "assets/images/feed4.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          AdminCubit myCubit=AdminCubit.get(context);
          return Scaffold(
            backgroundColor: myBlack,
            body: GridView.count(
              physics: BouncingScrollPhysics(),
              primary: false,
              padding: EdgeInsets.symmetric(vertical: 0.h,horizontal: 17.w),
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              crossAxisCount: deviceSize.width < 450
                  ? deviceSize.width < 900 ? 2 : 3
                  : deviceSize.width < 900 ? 3 : 4,
              children: [
                othersTile(imgPaths[0], ClassesList(), titles[0],context),
                othersTile(imgPaths[1], EquipmentList(allEquipment:allEquipment), titles[1],context),
                othersTile(imgPaths[2], NutritionistSessionsList(), titles[2],context),
                othersTile(imgPaths[3], MembershipsList(), titles[3],context),
                othersTile(imgPaths[4], ViewPrivateSessionRequestsScreen(), titles[4],context),
                othersTile(imgPaths[5], ViewGroupsScreen(false), titles[5],context),
                othersTile(imgPaths[6], PlansViewScreen(false), titles[6],context),
                othersTile(imgPaths[7], QuestionsScreen(), titles[7],context),
                othersTile(imgPaths[8], SupplementList(), titles[8],context),
                othersTile(imgPaths[9], InvitationList(), titles[9],context),
                Padding(
                  padding: EdgeInsets.only(bottom: 60.h),
                  child: othersTile(imgPaths[10], EventListView(), titles[10],context),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 60.h),
                  child: othersTile(imgPaths[11], FeedbackList(), titles[11],context),
                ),
              ],
            ),
          );
        },
    );
  }

  Container othersTile(String imgPath, Widget destination, String txt,BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        image: new DecorationImage(
          image: AssetImage(imgPath),
          colorFilter: new ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.dstATop,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: TextButton(
        onPressed: () {
          goToAnotherScreenPush(context, destination);
        },
        child: Center(
          child: Text(
            txt,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ),
      ),
    );
  }
}