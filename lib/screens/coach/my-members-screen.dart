import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/coach_cubit/coach_cubit.dart';
import 'package:gym_project/models/user/member_model.dart';
import 'package:gym_project/screens/coach/assign-groups.dart';
import 'package:gym_project/widget/loading-widgets.dart';

import '../../all_data.dart';
import '../../bloc/coach_cubit/coach_states.dart';
import '../../constants.dart';
import '../admin/users/user_details.dart';


class MyMembersScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoachCubit,CoachStates>(
      listener: (context,state){},
      builder: (context,state){
        CoachCubit coachCubit=CoachCubit.get(context);
        return Container(
          color: myBlack,
            padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
            child: ConditionalBuilder(
                condition: userCoach.allMembers.isNotEmpty,
                builder: (context)=>loadMembersList(context),
              fallback: (context)=>ConditionalBuilder(
                condition: coachCubit.isLoadingCoach,
                builder: (context)=>Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3.r,
                    color: Color(0xFFFFCE2B),
                  ),
                ),
                fallback: (context){
                  return Center(
                    child: Container(
                      child: Text(
                        "No Members Found",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
        );
      },
    );
  }

  ListView loadMembersList(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: userCoach.allMembers.length,
        itemBuilder: (ctx, index) {
          return myListTile(
            userCoach.allMembers[index],
            index,
            context,
          );
        });
  }
}

Widget myListTile(Member member, int index, BuildContext context) {
  return Container(
    margin: EdgeInsetsDirectional.only(bottom: 15.h),
    decoration: BoxDecoration(
      color: myPurple,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: ListTile(
      onTap: () async {
        goToAnotherScreenPush(context, UserProfile(user:member));
      },
      minVerticalPadding: 10.h,
      leading: CircleAvatar(
        radius: 20.r,
        child: Icon(Icons.note),
      ),
      title: Text(
        member.name,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            child: Text(
              'Assign Groups',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignGroupMember(member),
                  ));
            },
          ),
        ],
      ),
    ),
  );
}
