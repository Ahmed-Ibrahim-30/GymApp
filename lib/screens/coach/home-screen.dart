import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/coach_cubit/coach_cubit.dart';
import 'package:gym_project/bloc/coach_cubit/coach_states.dart';
import 'package:gym_project/models/event.dart';
import 'package:gym_project/screens/Events/event-details.dart';
import 'package:gym_project/screens/admin/classes/class_details.dart';
import 'package:gym_project/widget/global.dart';
import '../../constants.dart';
import '../../models/classes.dart';
import '../../style/styling.dart';
import '../../widget/popularCard.dart';
import '../admin/classes/class_arguments.dart';

class CoachHomeScreen extends StatelessWidget {
  final String name = Global.username;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoachCubit,CoachStates>(
      listener: (context,state){},
      builder: (context,state){
        CoachCubit coachCubit=CoachCubit.get(context);
        return Scaffold(
          backgroundColor: myBlack,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: PadRadius.horizontal - 15, vertical: 20.h,),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: RichText(
                            overflow: TextOverflow
                                .ellipsis, //does not work don't know why - replaced it with a FittedBox
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Welcome ",
                                  style: TextStyle(
                                      fontSize: 25.sp,
                                      color: myYellow2,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: "$name 👋",
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConditionalBuilder(
                          condition: allEvents.isNotEmpty,
                          builder: (context)=>Card(
                            color: myBlack,
                            elevation: 0.0,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text("Upcoming Events",
                                        style: TextStyle(
                                            color:
                                            Colors.white,
                                            fontSize: 22,
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context,
                                              '/events');
                                        },
                                        child: Text(
                                          'See More',
                                          style: TextStyle(
                                              color: Color(
                                                  0xFFFFCE2B),
                                              fontWeight:
                                              FontWeight
                                                  .bold),
                                        ))
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                SingleChildScrollView(
                                  scrollDirection:
                                  Axis.horizontal,
                                  physics:
                                  BouncingScrollPhysics(),
                                  child: Row(children: [
                                    for (Event event
                                    in allEvents)
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventDetailsScreen(
                                                          event
                                                              .id,
                                                          event
                                                              .title,
                                                          event
                                                              .price,
                                                          event
                                                              .ticketsAvailable,
                                                          event.startTime.substring(0,
                                                              11),
                                                          event.startTime.substring(
                                                              12),
                                                          event
                                                              .endTime,
                                                          event.description,
                                                              () {coachCubit.update();})));
                                        },
                                        child: PopularCard(
                                          asset: "ht.png",
                                          title: event.title,
                                        ),
                                      )
                                  ]),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        fallback: (context)=>ConditionalBuilder(
                            condition: coachCubit.isLoadingEvents,
                            builder: (context)=>Center(child: CircularProgressIndicator(color: myYellow),),
                          fallback: (context)=>Center(child: Text("No Events yet",style: TextStyle(color: Colors.grey),),),
                        ),
                      ),
                      ConditionalBuilder(
                        condition: allClasses.isNotEmpty,
                        builder: (context)=>Card(
                          color: myBlack,
                          elevation: 0.0,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text("Classes",
                                      style: TextStyle(
                                          color:
                                          Colors.white,
                                          fontSize: 22,
                                          fontWeight:
                                          FontWeight
                                              .bold)),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context,
                                            '/class-list');
                                      },
                                      child: Text(
                                        'See More',
                                        style: TextStyle(
                                            color: Color(
                                                0xFFFFCE2B),
                                            fontWeight:
                                            FontWeight
                                                .bold),
                                      ))
                                ],
                              ),
                              SizedBox(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                child: Row(
                                  children: [
                                    for (int i=0;i<allClasses.length;i++)
                                      GestureDetector(
                                        onTap: () {
                                          goToAnotherScreenPush(context, ClassDetails(classes: allClasses[i],));
                                        },
                                        child: PopularCard(
                                          asset: "image6.jpg",
                                          title: allClasses[i].title,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        fallback: (context)=>ConditionalBuilder(
                          condition: coachCubit.isLoadingClasses,
                          builder: (context)=>Center(child: CircularProgressIndicator(color: myYellow),),
                          fallback: (context)=>Center(child: Text("No Classes yet",style: TextStyle(color: Colors.grey),),),
                        ),
                      ),
                    ],
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
