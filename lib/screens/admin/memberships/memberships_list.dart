import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import 'package:gym_project/common/my_list_tile_without_counter.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/admin/memberships/edit_membership.dart';
import 'package:gym_project/screens/admin/memberships/membership_details.dart';
import '../../../all_data.dart';
import '../../../widget/global.dart';

class MembershipsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          AdminCubit adminCubit=AdminCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0.0,
              title: Text('Memberships List',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0.sp,
                      fontFamily: 'assets/fonts/Changa-Bold.ttf',
                      color: Colors.white)),
              leading: backButton(context: context),
            ),
            floatingActionButton: Global.role == "admin"
                ? Container(
              child: FloatingActionButton(
                onPressed: () {
                  goToAnotherScreenPush(context, EditMembership(adminCubit: adminCubit,isAdd: true,));
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
            body: ConditionalBuilder(
              condition: allMemberships.isNotEmpty,
              builder: (context)=>SafeArea(
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsetsDirectional.all(10),
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: allMemberships.length,
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          onTap: () {
                            goToAnotherScreenPush(context, MembershipDetails(membershipsIndex:allMemberships[index].index));
                          },
                          child: CustomListTileWithoutCounter(
                              'assets/images/membership.png',
                              allMemberships[index].title,
                              '${allMemberships[index].available_classes} Classes',
                              "\$${allMemberships[index].price}",
                              "${allMemberships[index].duration} month"),
                        );
                      }),
                ),
              ),
              fallback: (context)=>ConditionalBuilder(
                condition: adminCubit.isLoadingMembersShips,
                builder: (context)=>Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFFFFCE2B),
                  ),
                ),
                fallback: (context)=>Center(
                  child: Container(
                    child: Text(
                      "No MemberShips Found",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
