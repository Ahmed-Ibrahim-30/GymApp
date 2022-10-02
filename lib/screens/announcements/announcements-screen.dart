import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/announcements/add-announcement-screen.dart';
import 'package:gym_project/screens/announcements/announcements-list-tile.dart';
import '../../all_data.dart';
import '../../widget/global.dart';


class AnnouncementsScreen extends StatelessWidget {
  final String user_role=Global.role;
  final bool showAppBar;
  AnnouncementsScreen({this.showAppBar=true});


  addAnnouncement(BuildContext context,AdminCubit myCubit) async {
    goToAnotherScreenPush(context, AddAnnouncementScreen(
      post_type: 'Add',
      myCubit: myCubit,
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit myCubit=AdminCubit.get(context);
        return Scaffold(
          appBar: showAppBar?AppBar(
            backgroundColor: myBlack,
            elevation: 0.0,
            leading: backButton(context: context),
            title: Text("Announcements",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),),
          ):null,
          backgroundColor: myBlack,
          body: Padding(
            padding: EdgeInsets.only(left: 11.w,right: 11.w,bottom: 11.h,top: 11.h),
            child: ConditionalBuilder(
              condition: announcementsList.isNotEmpty,
              builder: (context)=>ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: index!=announcementsList.length-1?
                    EdgeInsets.zero:EdgeInsets.only(bottom: 40.h),
                    child: AnnouncementsListTile(
                      role: user_role,
                      id: announcementsList[index].id,
                      title:announcementsList[index].title,
                      body: announcementsList[index].description,
                      date: announcementsList[index].date,
                      myCubit: myCubit,
                    ),
                  );
                },
                itemCount: announcementsList.length,
                padding: const EdgeInsets.all(10),
              ),
              fallback: (context)=>ConditionalBuilder(
                  condition: myCubit.isLoadingAnnouncements,
                  builder: (context)=> Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFFFFCE2B),
                    ),
                  ),
                fallback: (context)=>Center(
                  child: Container(
                    child: Text(
                      "No Announcement Found",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 26,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
