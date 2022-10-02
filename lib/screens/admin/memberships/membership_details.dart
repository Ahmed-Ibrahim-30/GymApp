import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/admin-models/membership/membership-model.dart';
import 'package:gym_project/screens/admin/memberships/edit_membership.dart';
import '../../../bloc/newCreate/Create_states.dart';
import '../../../services/admin-services/membership-service.dart';
import '../../../widget/global.dart';

class MembershipDetails extends StatelessWidget {
  final int membershipsIndex;
  MembershipDetails({this.membershipsIndex});

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          AdminCubit adminCubit=AdminCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              title: Text(
                'Membership Details',
                style: TextStyle(
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                  fontSize: 18.sp,
                ),
              ),
              leading: backButton(context: context),
              actions: [
                BlocProvider(
                  create: (context)=>CreateCubit(),
                  child: BlocConsumer<CreateCubit,CreateStates>(
                    listener: (context,state){},
                    builder: (context,state){
                      CreateCubit createCubit=CreateCubit.get(context);
                      return ConditionalBuilder(
                        condition: state is! Loading2,
                        builder: (context)=>GestureDetector(
                          child: new CircleAvatar(
                            backgroundColor: myYellow,
                            radius: 20.0.r,
                            child: new Icon(
                              Icons.delete,
                              color: Colors.black,
                              size: 23.0.sp,
                            ),
                          ),
                          onTap: () {
                            MembershipsWebservice.deleteMembership(
                                id: allMemberships[membershipsIndex].id,
                                index: membershipsIndex,
                                context: context,
                                createCubit: createCubit,
                                adminCubit: adminCubit
                            );
                          },
                        ),
                        fallback: (context)=>Center(child: CircularProgressIndicator(color: myYellow,),),
                      );
                    },
                  ),
                )
              ],
            ),
            backgroundColor: Colors.black,
            floatingActionButton: Global.role== "admin"
                ? Container(
              child: FloatingActionButton.extended(
                onPressed: () {
                  goToAnotherScreenPush(context, EditMembership(membershipIndex:membershipsIndex,adminCubit: adminCubit,isAdd: false,));
                },
                label: Icon(Icons.edit,color: Colors.black,),
              ),
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width * 0.1,
            )
                : Container(),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
            body: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: isWideScreen ? 900 : double.infinity,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              'assets/images/membership.jfif',
                              fit: BoxFit.cover,
                            ),
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20.0.w, right: 20.0.w, top: 10.0.h, bottom: 10.h),
                                child: Text(
                                  allMemberships[membershipsIndex].title,
                                  style: TextStyle(
                                    fontSize: 20.0.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    allMemberships[membershipsIndex].discount != null
                                        ? Text("\$${allMemberships[membershipsIndex].discount}",
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 18.0.sp,
                                          fontFamily:
                                          'assets/fonts/Changa-Bold.ttf',
                                        ))
                                        : null,
                                    Text(" - ",
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 10.0.sp,
                                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                        )),
                                    Text("\$${allMemberships[membershipsIndex].price}",
                                        style: TextStyle(
                                          decoration: allMemberships[membershipsIndex].discount != null
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationThickness: 2,
                                          color: Colors.amber[200],
                                          fontSize: 20.0.sp,
                                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                        )),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0.w, vertical: 10.0.h),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20.0.w, bottom: 10.0.h),
                            child: Text(
                              "Branch : ${allMemberships[membershipsIndex].branch.title}",
                              style: TextStyle(
                                color: Colors.white60,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Card(
                                    color: Colors.white12,
                                    child: ListTile(
                                      title: Text(
                                        "Classes",
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 14.0.sp,
                                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      subtitle: Text(
                                        "${allMemberships[membershipsIndex].available_classes}",
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 10.0.sp,
                                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              ),
                              Flexible(
                                child: Card(
                                    color: Colors.white12,
                                    child: ListTile(
                                      title: Text(
                                        "Freeze",
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 14.0.sp,
                                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      subtitle: Text(
                                        "${allMemberships[membershipsIndex].limit_of_frozen_days} days",
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 10.0.sp,
                                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              ),
                              Flexible(
                                child: Card(
                                    color: Colors.white12,
                                    child: ListTile(
                                      title: Text(
                                        "Duration",
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 14.0.sp,
                                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      subtitle: Text(
                                        "${allMemberships[membershipsIndex].duration} months",
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 10.0.sp,
                                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w, vertical: 10.0.h),
                              child: Text("Description",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                  ))),
                          Container(
                            padding: EdgeInsets.only(left: 20.0.w, right: 20.0.w),
                            child: Text(
                              allMemberships[membershipsIndex].description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15.0.sp,
                                fontFamily: 'assets/fonts/ProximaNova-Regular.otf',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }
}

