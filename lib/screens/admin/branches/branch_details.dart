import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/newCreate/Create_states.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/admin-models/branches/branch-model.dart';
import 'package:gym_project/screens/admin/crowd_meter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../all_data.dart';
import '../../../services/admin-services/branches-services.dart';
import '../equipment/show_branch_equipments.dart';
import 'create_branch.dart';

class BranchDetails extends StatelessWidget {
  final AdminCubit adminCubit;
  final int index;
  BranchDetails({@required this.adminCubit,@required this.index});

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    return BlocProvider(
      create: (context)=>CreateCubit(),
      child: BlocConsumer<CreateCubit,CreateStates>(
        listener: (context,state){},
        builder: (context,state){
          CreateCubit myCubit=CreateCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0.0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: new Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFFFFCE2B),
                  size: 22.0.sp,
                ),
              ),
              title: Text(
                  'Branch Info',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0.sp,
                      fontFamily:
                      'assets/fonts/Changa-Bold.ttf',
                      color: Colors.white)
              ),
              actions: [
                FloatingActionButton(
                  mini: true,
                  heroTag: 'btn1',
                  onPressed: () {
                    goToAnotherScreenPush(context, BranchForm(adminCubit:adminCubit,branch: branchesList[index],isAdd: false,detailsContext:context));
                  },
                  isExtended: false,
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 15.w,),
                ConditionalBuilder(
                  condition: state is! Loading1,
                  builder: (context)=>FloatingActionButton(
                    mini: true,
                    heroTag: 'btn2',
                    onPressed: () {
                      BranchService.deleteBranch(
                          id: branchesList[index].id,
                          context: context,createCubit: myCubit,
                          adminCubit: adminCubit,
                        index: index,
                      );
                    },
                    isExtended: false,
                    child: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                  fallback: (context)=>Center(child: CircularProgressIndicator(color: Colors.yellow,strokeWidth: 4)),
                ),
                SizedBox(width: 15.w,),
              ],
            ),
            backgroundColor: Colors.black,
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
              child: Container(
                width: isWideScreen ? 900 : double.infinity,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        'assets/images/branch.jfif',
                        fit: BoxFit.cover,
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    SizedBox(height: 15.h,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Container(
                            height: double.infinity,
                            child: Icon(Icons.title,color: Colors.yellow,size: 25.sp,),
                          ),
                          title: Text(
                            branchesList[index].title,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 20.0.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: 'assets/fonts/Changa-Bold.ttf',
                            ),
                          ),
                          subtitle: Text(
                            branchesList[index].info,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                              fontFamily: 'assets/fonts/Changa-Bold.ttf',
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          leading:  Icon(Icons.phone,color: Colors.yellow,size: 25.sp,),
                          title:  InkWell(
                            onTap: ()=>launchUrl(Uri.parse("tel://${branchesList[index].number}")),
                            child: Text(
                              branchesList[index].number,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20.0.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                fontFamily:
                                'assets/fonts/Changa-Bold.ttf',
                              ),
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          leading:  Icon(Icons.location_on,color: Colors.yellow,size: 25.sp,),
                          title:  Text(
                            branchesList[index].location,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 20.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontFamily:
                              'assets/fonts/Changa-Bold.ttf',
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          leading:  Icon(Icons.event_seat,color: Colors.yellow,size: 25.sp,),
                          title:  Text(
                            branchesList[index].crowdMeter.toString() +
                                " seats",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 20.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontFamily:
                              'assets/fonts/Changa-Bold.ttf',
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          children: [
                            Flexible(
                              child: Card(
                                  color: Colors.white12,
                                  child: ListTile(
                                    title: Text(
                                      "Coaches",
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 12.sp,
                                        fontFamily:
                                        'assets/fonts/Changa-Bold.ttf',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    subtitle: Text(
                                      branchesList[index].coachesNumber.toString(),
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 12.sp,
                                        fontFamily:
                                        'assets/fonts/Changa-Bold.ttf',
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
                                      "Nutritionists",
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 12.0.sp,
                                        fontFamily:
                                        'assets/fonts/Changa-Bold.ttf',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    subtitle: Text(
                                      "-",
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 12.0.sp,
                                        fontFamily:
                                        'assets/fonts/Changa-Bold.ttf',
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
                                      "Members",
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 12.0.sp,
                                        fontFamily:
                                        'assets/fonts/Changa-Bold.ttf',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    subtitle: Text(
                                      branchesList[index].membersNumber.toString(),
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 12.0.sp,
                                        fontFamily:
                                        'assets/fonts/Changa-Bold.ttf',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h,),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: ElevatedButton(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.amber,
                              elevation: 5,
                              shadowColor: Colors.grey,
                              fixedSize: Size(250.w, 40.h),
                              textStyle: TextStyle(
                                fontSize: 20.sp,
                              ),
                            ),
                            onPressed: () {
                              goToAnotherScreenPush(context, ShowBranchEquipment(branch:branchesList[index]),type: PageTransitionType.leftToRightWithFade);
                            },
                            child: Text('View Equipment',),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: CrowdMeter(
                            checkedInMembers: 300,
                            totalMembers: branchesList[index].crowdMeter
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ScreenArguments {
  final Branch branchInfo;

  ScreenArguments(this.branchInfo);
}
