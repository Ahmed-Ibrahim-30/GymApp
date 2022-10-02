import 'dart:io';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import 'package:gym_project/bloc/newCreate/Create_states.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/admin/equipment/equipment_details.dart';
import '../../../all_data.dart';
import '../../../common/my_list_tile_without_counter.dart';
import '../../../models/admin-models/branches/branch-model.dart';
import '../../../services/admin-services/branches-services.dart';
import '../../../widget/global.dart';

class branchEquipment{
  final int id;
  int index=-1;
  final String name;
  final String description;
  final String picture;
  bool isSelected=false;
  IconData selectedIcon;

  branchEquipment(
      this.id, this.name, this.description, this.picture, this.isSelected);
}

class ShowBranchEquipment extends StatelessWidget {
  final Branch branch;
  ShowBranchEquipment({this.branch});
  List<branchEquipment>validEquipment=[];
  List<branchEquipment> filterValidEquipments(AdminCubit adminCubit){
    List<branchEquipment>validEquipments=[];
    bool enter=false;
    allEquipment.forEach((element) {
      for(int i=0;i<branchesList[branch.index].allEquipment.length;i++){
        if(element.id==branchesList[branch.index].allEquipment[i].id){
          enter=true;
          break;
        }
      }
      if(!enter){
        branchEquipment branchEq=branchEquipment(
            element.id,
            element.name,
            element.description,
            element.picture,
            false
        );
        branchEq.selectedIcon=Icons.check_box_outline_blank;
        validEquipments.add(branchEq);
      }
      enter=false;
    });
    return validEquipments;
  }

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
            leading: IconButton(
              icon: new Icon(
                Icons.arrow_back_ios,
                color: Color(0xFFFFCE2B),
                size: 22.0.sp,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: new Text('Equipment List',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0.sp,
                    fontFamily:
                    'assets/fonts/Changa-Bold.ttf',
                    color: Colors.white)),
          ),
          floatingActionButton: Global.role=="admin"?Container(
            child: FloatingActionButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  barrierLabel: "Barrier",
                  barrierDismissible: false,
                  barrierColor: Colors.black.withOpacity(0.9),
                  transitionDuration: Duration(milliseconds: 700),
                  pageBuilder: (_, __, ___) {
                    validEquipment=filterValidEquipments(adminCubit);
                    return Center(
                      child: Padding(
                        padding:EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 10.h),
                        child: BlocProvider(
                          create: (context)=>CreateCubit(),
                          child: BlocConsumer<CreateCubit,CreateStates>(
                            listener: (context,state){
                              print("state = ${state}");
                            },
                            builder: (context,state){
                              CreateCubit createCubit=CreateCubit.get(context);
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.70,
                                    decoration: BoxDecoration(
                                      color: myGreen,
                                      borderRadius: BorderRadius.circular(40.r),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: ListView.separated(
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context,index)=>Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 7.w),
                                            child: Card(
                                              elevation: 0.0,
                                              child: InkWell(
                                                onTap: () {
                                                  createCubit.selectCheckBox(validEquipment[index]);
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                                  child: ListTile(
                                                    contentPadding: EdgeInsets.zero,
                                                    leading: Container(
                                                      width: 30.w,
                                                      height: 30.h,
                                                      decoration: const BoxDecoration(
                                                          shape:BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey,
                                                              blurRadius: 4,
                                                              spreadRadius: 2,
                                                            )
                                                          ]
                                                      ),
                                                      child: CircleAvatar(
                                                          radius: 25.r,//Image.file(File(widget.path))
                                                          backgroundColor: Colors.transparent,
                                                          child: ClipRRect(
                                                            borderRadius:BorderRadius.circular(25.r),
                                                            child: validEquipment[index].picture.contains('com.example.gymproject')?Image.file(File(validEquipment[index].picture),width: 30.w,height: 30.h,fit: BoxFit.fill,):
                                                            validEquipment[index].picture.contains('assets')?Image.asset(validEquipment[index].picture):
                                                            Image.asset('assets/images/branch.png'),
                                                          )
                                                      ),
                                                    ),
                                                    title: Text(
                                                      "${validEquipment[index].name}",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    trailing: Icon(validEquipment[index].selectedIcon),//check_box
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        separatorBuilder: (context,index)=>SizedBox(height: 5.h),
                                        itemCount: validEquipment.length
                                    ),
                                  ),
                                  SizedBox(height: 15.h,),
                                  Center(
                                    child: ConditionalBuilder(
                                      condition: state is! Loading1,
                                      builder: (context)=>Container(
                                        width: 200.w,
                                        height: 30.h,
                                        child: new ElevatedButton(
                                          child: new Text(
                                            "Save",
                                            style: TextStyle(
                                                fontSize: 16.sp
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                new BorderRadius.circular(10.0.r),
                                              ),
                                              primary: Color(0xFFFFCE2B),
                                              onPrimary: Colors.black,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              textStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          onPressed: () async{

                                            await BranchService.assignManyEquipment(
                                              branch:branch,
                                              equipments: validEquipment,
                                              adminCubit: adminCubit,
                                              createCubit: createCubit,
                                              context: context,
                                            );
                                          },
                                        ),
                                      ),
                                      fallback: (context)=>CircularProgressIndicator(color: Colors.yellow,),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  transitionBuilder: (_, anim, __, child) {
                    Tween<Offset> tween;
                    if (anim.status == AnimationStatus.reverse) {
                      tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
                    } else {
                      tween = Tween(begin: Offset(1, 0), end: Offset.zero);
                    }
                    return SlideTransition(
                      position: tween.animate(anim),
                      child: FadeTransition(
                        opacity: anim,
                        child: child,
                      ),
                    );
                  },
                );
              },
              isExtended: false,
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.075,
            width: MediaQuery.of(context).size.width * 0.125,
          ):SizedBox(),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          body: ConditionalBuilder(
            condition: branchesList[branch.index].allEquipment.isNotEmpty,
            builder: (context)=>Container(
              color: Colors.black,
              padding: EdgeInsetsDirectional.all(10),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: branchesList[branch.index].allEquipment.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        goToAnotherScreenPush(context, EquipmentDetails(equipment: branchesList[branch.index].allEquipment[index],allowUpdate: false,));
                      },
                      child: CustomListTileWithoutCounter(
                          branchesList[branch.index].allEquipment[index].picture,
                          branchesList[branch.index].allEquipment[index].name,
                          '',
                          branchesList[branch.index].allEquipment[index].description,
                          ''),
                    );
                  }),
            ),
            fallback: (context)=> Center(
              child: Container(
                child: Text(
                  "No Equipment Found yet",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold
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
