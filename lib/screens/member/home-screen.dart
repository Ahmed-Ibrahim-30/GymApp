import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/event.dart';
import 'package:gym_project/screens/Events/event-details.dart';
import 'package:gym_project/viewmodels/event-view-model.dart';
import 'package:gym_project/viewmodels/login-view-model.dart';
import 'package:gym_project/widget/global.dart';
import 'package:provider/provider.dart';
import '../../all_data.dart';
import '../../bloc/member_cubit/member_cubit.dart';
import '../../bloc/member_cubit/member_states.dart';
import '../../style/styling.dart';
import '../../widget/popularCard.dart';
import '../admin/classes/class_details.dart';

class MemberHomeScreen extends StatefulWidget {
  List<Widget> events = [];
  List<Widget> classes = [];

  @override
  _MemberHomeScreenState createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  final String name = Global.username;
  @override
  void initState() {
    getEvents();
    getClasses();

    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
    // await Provider.of<EventViewModel>(context, listen: false).getAllEvents(Provider.of<LoginViewModel>(context, listen: false).token);
    // });
    super.initState();
  }

  String formatDateTime(String DateTime) {
    //2021-09-13 14:13:51
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    String year = DateTime.substring(0, 4);
    String month = DateTime.substring(5, 7);
    String day = DateTime.substring(8, 10);
    String time = DateTime.substring(11, 16);
    return '$day ${months[int.parse(month) - 1]} $year $time';
  }

  @override
  Widget build(BuildContext context) {
    var eventViewModel = Provider.of<EventViewModel>(context);
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    return BlocConsumer<MemberCubit,MemberStates>(
      listener: (context,state){},
      builder: (context,state){
        MemberCubit memberCubit=MemberCubit.get(context);
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
                                                            () {memberCubit.update();})));
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
                          condition: memberCubit.isLoadingEvents,
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
                          condition: memberCubit.isLoadingClasses,
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

  void getEvents() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<EventViewModel>(context, listen: false).getAllEvents(
          Provider.of<LoginViewModel>(context, listen: false).token);
      List<Event> eventsList =
          Provider.of<EventViewModel>(context, listen: false).allEvents;
      List<Widget> temp = [];
      setState(() {
        for (var i = 0; i < eventsList.length; i++) {
          temp.insert(
              i,
              GestureDetector(
                onTap: () async {
                  await Provider.of<EventViewModel>(context, listen: false)
                      .getEventById(
                          eventsList[i].id,
                          Provider.of<LoginViewModel>(context, listen: false)
                              .token);
                  Event currentEvent =
                      Provider.of<EventViewModel>(context, listen: false)
                          .currentevent;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventDetailsScreen(
                              currentEvent.id,
                              currentEvent.title,
                              currentEvent.price,
                              currentEvent.ticketsAvailable,
                              formatDateTime(currentEvent.startTime)
                                  .substring(0, 11),
                              formatDateTime(currentEvent.startTime)
                                  .substring(12),
                              currentEvent.endTime.substring(11, 16),
                              currentEvent.description,
                              update)));
                },
                child: PopularCard(
                  asset: "ht1",
                  title: eventsList[i].title,
                ),
              ));
          if (i == 5) break;
        }
      });
      widget.events = temp;
    });
  }

  void getClasses() {
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
    //   // await Provider.of<ClassesListViewModel>(context, listen: false).fetchListClasses();
    //   // List<Classes> classesList = Provider.of<ClassesListViewModel>(context, listen: false).classesList;
    //   List<Widget> temp = [];
    //   setState(() {
    //     for (var i = 0; i < classesList.length; i++) {
    //       // print(classesList[i].title);
    //       temp.insert(
    //           i,
    //           GestureDetector(
    //             onTap: () async {
    //               Navigator.pushNamed(context, '/class-details',
    //                   arguments: ClassesArguments(
    //                     id: classesList[i].id,
    //                     description: classesList[i].description,
    //                     title: classesList[i].title,
    //                     link: classesList[i].link,
    //                     level: classesList[i].level,
    //                     capacity: classesList[i].capacity,
    //                     price: classesList[i].price,
    //                     duration: classesList[i].duration,
    //                     date: classesList[i].date,
    //                   ));
    //             },
    //             child: PopularCard(
    //               asset: "ht2",
    //               title: classesList[i].title,
    //             ),
    //           ));
    //       if (i == 5) break;
    //     }
    //   });
    //   widget.classes = temp;
    // });
    ///Todo Modifiy in it
  }

  void update() {
    setState(() {});
  }
}
