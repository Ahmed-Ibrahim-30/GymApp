import 'package:conditional_builder/conditional_builder.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import 'package:gym_project/screens/admin/classes/create_class.dart';
import 'package:gym_project/screens/admin/users/users_list.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../bloc/newCreate/Create_states.dart';
import '../../../bloc/newCreate/create_bloc.dart';
import '../../../constants.dart';
import '../../../models/classes.dart';
import '../../../models/user/coach_model.dart';
import '../../../models/user/member_model.dart';
import '../../../services/claseess_services.dart';
import '../../../widget/global.dart';
import '../helping-widgets/create-form-widgets.dart';

class ClassDetails extends StatelessWidget {
  final Classes classes;
  ClassDetails({this.classes});
  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit myCubit=AdminCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0.0,
            leading:  InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: new Icon(
                Icons.arrow_back_ios,
                color: myYellow,
                size: 22.0.sp,
              ),
            ),
            title: Text('Class Info',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0.sp,
                    fontFamily: 'sans-serif-light',
                    color: Colors.white)
            ),
            actions: [
              ConditionalBuilder(
                condition: Global.role== "admin",
                builder:(context)=>Container(
                  child: FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {
                      goToAnotherScreenPush(context, CreateClassForm(adminCubit: myCubit,isAdd: false,classes: classes,));
                      // Navigator.pushNamed(context, '/edit-class',
                      //     arguments: ClassesArguments(
                      //       id: classes.id,
                      //       description: classes.description,
                      //       title: classes.title,
                      //       link: classes.link,
                      //       level: classes.level,
                      //       capacity: classes.capacity,
                      //       price: classes.price,
                      //       duration: classes.duration,
                      //       date: classes.date,
                      //     ));
                    },
                    isExtended: true,
                    child: Icon(Icons.edit,color: Colors.black,),
                  ),
                  height: MediaQuery.of(context).size.height * 0.075,
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                fallback: (context)=>ConditionalBuilder(
                  condition: Global.role=="member",
                  builder: (context)=>Container(
                    child: FloatingActionButton.extended(
                      heroTag: "btn2",
                      onPressed: () {
                        _showDialog(context);
                      },
                      isExtended: true,
                      label: Text(
                        'Book Now !',
                        style: TextStyle(
                          fontSize: 20.0.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'assets/fonts/Changa-Bold.ttf',
                        ),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.075,
                    width: MediaQuery.of(context).size.width * 0.45,
                  ),
                  fallback: (context)=>SizedBox(),
                ),
              ),
              SizedBox(width: 10.w,),
              ConditionalBuilder(
                condition: Global.role == "admin",
                builder:(context)=> ConditionalBuilder(
                  condition: state is!DeleteClassesLoadingState,
                  builder: (context)=>FloatingActionButton(
                        heroTag: "btn3",
                        backgroundColor: Color(0xFFFFCE2B),
                        mini: true,
                        onPressed: () {
                          ClassesServices.deleteClass(
                            id: allClasses[classes.index].id,
                            index: allClasses[classes.index].index,
                            context: context,
                            adminCubit: myCubit,
                          );
                        },
                        child: Icon(Icons.delete,color: Colors.black,)
                    ),
                  fallback: (context)=>Center(child: CircularProgressIndicator(color: myYellow,),),
                ),
                fallback: (context)=>SizedBox(),
              ),
              SizedBox(width: 10.w,),
            ],
          ),
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
                      'assets/images/Boxing.jfif',
                      fit: BoxFit.cover,
                    ),
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),//image
                  SizedBox(height: 20.h,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myListTitle(
                        leading: Icon(Icons.title,color: Colors.yellow,size: 25.sp,),
                        title: allClasses[classes.index].title,
                        titleMaxLine: 2,
                        titleFontSize: 20.sp,
                        subtitle: allClasses[classes.index].description,
                        subtitleFontSize: 14.sp,
                        subtitleMaxLine: 5,
                      ),
                      myListTitle(
                        leading: Image.asset("assets/images/level.png",color: Colors.yellow,width:25.sp),
                        title:allClasses[classes.index].level,
                        titleFontSize: 20.sp,
                      ),
                      myListTitle(
                        leading: Icon(Icons.price_change_sharp,color: Colors.yellow,size: 25.sp,),
                        title: "Price : ${allClasses[classes.index].price}",
                        titleFontSize: 20.sp,
                      ),
                      myListTitle(
                        leading: Icon(Icons.reduce_capacity,color: Colors.yellow,size: 25.sp,),
                        title: "Capacity : ${allClasses[classes.index].capacity}",
                        titleFontSize: 20.sp,
                      ),
                      myListTitle(
                        leading: Icon(Icons.people,color: Colors.yellow,size: 25.sp,),
                        title: "${allClasses[classes.index].allCoaches.length}  Coaches",
                        titleFontSize: 20.sp,
                        trailing: ConditionalBuilder(
                          condition: Global.role=="admin",
                          builder: (context)=>TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: myYellow,
                              ),
                              onPressed: (){
                                goToAnotherScreenPush(context,
                                  userDetails(context, allClasses[classes.index].allCoaches,myCubit,appBarText: "Coaches",isCreate: true,myClass:classes),
                                );
                              },
                              child: Text(
                                "See All",
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                          ),
                          fallback: (context)=>SizedBox(),
                        ),
                      ),
                      myListTitle(
                        leading: Icon(Icons.emoji_people_rounded,color: Colors.yellow,size: 25.sp,),
                        title: "${allClasses[classes.index].allMembers.length}  Members",
                        trailing: ConditionalBuilder(
                          condition: Global.role=="admin",
                          builder: (context)=>TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: myYellow,
                                ),
                                onPressed: (){
                                  goToAnotherScreenPush(
                                      context,
                                      userDetails(context, allClasses[classes.index].allMembers,myCubit,appBarText: "Members",isCreate: true,myClass:classes)
                                  );
                                },
                                child: Text(
                                  "See All",
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                            ),
                          fallback: (context)=>SizedBox(),
                        ),
                        titleFontSize: 20.sp,
                      ),
                      myListTitle(
                        leading: Icon(Icons.date_range,color: Colors.yellow,size: 25.sp,),
                        title: classes.date,
                        titleFontSize: 20.sp,
                      ),

                      myListTitle(
                        leading: Icon(Icons.timelapse,color: Colors.yellow,size: 25.sp,),
                        title: classes.duration.toString() + " Hours",
                        titleFontSize: 20.sp,
                      ),
                      ListTile(
                        leading:  Icon(Icons.link,color: Colors.yellow,size: 25.sp,),
                        title:  InkWell(
                          onTap: ()=>launchUrl(Uri.parse("${classes.link}")),
                          child: Text(
                            classes.link,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 17.0.sp,
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void _showDialog(context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Color(0xff181818),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xff181818)),
      ),
      title: Text(
        "Book Class",
        style: TextStyle(
          color: Colors.amber,
          fontFamily: 'assets/fonts/Changa-Bold.ttf',
          fontSize: 25,
          //fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Are you sure you want to book this calss?",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'assets/fonts/Changa-Bold.ttf',
          fontSize: 18,
          //fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black),
          ),
          color: Colors.amber,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.amber,
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Book",
            style: TextStyle(color: Colors.black),
          ),
          color: Colors.amber,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.amber,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget userDetails(BuildContext context,var list,AdminCubit adminCubit,
    {@required String appBarText,bool isCreate=false,Classes myClass}){
  //TextEditingController emailController = TextEditingController();

  return Scaffold(
    backgroundColor: myBlack,
    appBar: AppBar(
      backgroundColor: myBlack,
      elevation: 0.0,
      leading: IconButton(
        icon: new Icon(
          Icons.arrow_back_ios,
          color: myYellow,
          size: 22.0.sp,
        ),
        onPressed: (){Navigator.pop(context);},
      ),
      title: Text("Class $appBarText", style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 19.0.sp,
          fontFamily:
          'assets/fonts/Changa-Bold.ttf',
          color: Colors.white)
      ),
    ),
    floatingActionButton: isCreate?FloatingActionButton(
      onPressed: (){
        String email;
        var formKey=GlobalKey<FormState>();
        myAlertDialog(context: context, Body: Center(
          child: Padding(
            padding:EdgeInsets.fromLTRB(22.w, 0, 22.w, 0),
            child: Form(
              key: formKey,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h,horizontal: 40.w),
                  child: BlocProvider(
                    create: (context)=>CreateCubit(),
                    child: BlocConsumer<CreateCubit,CreateStates>(
                      listener: (context,state){},
                      builder: (context,state){
                        CreateCubit createCubit=CreateCubit.get(context);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Card(child: field("Email", "Enter Member Email", emailController,keyboardType: TextInputType.emailAddress),elevation: 0.0),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: DropdownSearch<String>(
                                  mode: Mode.MENU,
                                  showSelectedItems: true,
                                  items: appBarText=="Members"?membersUsers.map((e) => e.email).toList():
                                  coachesUsers.map((e) => e.email).toList(),
                                  showClearButton: true,
                                  popupItemDisabled: (String s) => s.startsWith('I'),

                                  onChanged: (String data){
                                    email=data;
                                    createCubit.updateState();
                                  },
                                  validator: (String item) {
                                    if (item == null)
                                      return "Required field";
                                    else
                                      return null;
                                  },
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Email",
                                    hintText: "Enter Member Email",
                                    hintStyle: TextStyle(color: Colors.black),
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  selectedItem: email??''),
                            ),
                            Center(
                              child: ConditionalBuilder(
                                condition: state is! Loading1,
                                builder: (context)=>Container(
                                  width: 200.w,
                                  height: 30.h,
                                  child: new ElevatedButton(
                                    child: new Text(
                                      "Add",
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
                                    onPressed: () {
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      if(formKey.currentState.validate()){
                                        bool memberValid=false;
                                        if(appBarText=="Members"){
                                          Member member;
                                          for(int i=0;i<membersUsers.length;i++){
                                            if(membersUsers[i].email==email){
                                              member=membersUsers[i];
                                              bool memberValid2=true;
                                              for(int g=0;g<list.length;g++){
                                                if(member.id==list[g].id){
                                                  memberValid2=false;
                                                  break;
                                                }
                                              }
                                              if(memberValid2) memberValid=true;
                                              break;
                                            }
                                          }
                                          if(memberValid){
                                            ClassesServices.attachMembersToClass(
                                                member: member,
                                                classes: myClass,
                                                context: context,
                                                createCubit: createCubit,
                                                adminCubit: adminCubit
                                            );
                                          }
                                          else {
                                            myToast(message: "Member Already Found",color: Colors.red);
                                          }
                                        }
                                        else if(appBarText=="Coaches"){
                                          Coach coach;
                                          for(int i=0;i<coachesUsers.length;i++){
                                            if(coachesUsers[i].email==email){
                                              coach=coachesUsers[i];
                                              bool memberValid2=true;
                                              for(int g=0;g<list.length;g++){
                                                if(coach.id==list[g].id){
                                                  memberValid2=false;
                                                  break;
                                                }
                                              }
                                              if(memberValid2) memberValid=true;
                                              break;
                                            }
                                          }
                                          if(memberValid){
                                            ClassesServices.attachCoachToClass(
                                                coach: coach,
                                                classes: myClass,
                                                context: context,
                                                createCubit: createCubit,
                                                adminCubit: adminCubit
                                            );
                                          }
                                          else {
                                            myToast(message: "Coach Already Found",color: Colors.red);
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                                fallback: (context)=>CircularProgressIndicator(color: Colors.yellow,),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
      },
      child: Icon(Icons.add),
    ):const SizedBox(),
    body: BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        if(appBarText=="Members")return AllScreen(allClasses[myClass.index].allMembers, adminCubit,showDetails:false);
        else return AllScreen(allClasses[myClass.index].allCoaches, adminCubit,showDetails:false);
      },
    )
  );
}

