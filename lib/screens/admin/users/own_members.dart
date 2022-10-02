import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import 'package:gym_project/bloc/newCreate/Create_states.dart';
import 'package:gym_project/models/user/member_model.dart';
import 'package:gym_project/services/user_services/coach-webservice.dart';
import '../../../all_data.dart';
import '../../../bloc/Admin_cubit/admin_cubit.dart';
import '../../../bloc/newCreate/create_bloc.dart';
import '../../../common/my_list_tile_without_counter.dart';
import '../../../constants.dart';
import '../../../services/user_services/nutritionist-service.dart';
import '../helping-widgets/create-form-widgets.dart';

class OwnMembers extends StatelessWidget{
  final String role;
  final user;
  final BuildContext context;
  OwnMembers({@required this.role,@required this.user,@required this.context});

  var formKey=GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context,CreateCubit createCubit,TextEditingController textEditingController) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2060),
    );
    if (selected != null && selected != selectedDate){
      selectedDate = selected;
      textEditingController.text=selectedDate.toString();
      createCubit.updateState();
    }
  }
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final myTween = Tween<Offset>(
    begin: const Offset(-1.0, 0.0),
    end: Offset.zero,
  );

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
                  color: myYellow,
                  size: 22.0.sp,
                ),
                onPressed: (){Navigator.pop(context);},
              ),
              title: Text("$role Members", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0.sp,
                  fontFamily:
                  'assets/fonts/Changa-Bold.ttf',
                  color: Colors.white)
              ),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: myYellow,
                child: Icon(Icons.add),
                isExtended: false,
                onPressed: (){
                  String member_email='';
                  final TextEditingController startDateController = TextEditingController();
                  final TextEditingController endDateController = TextEditingController();
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
                                  CreateCubit myCubit=CreateCubit.get(context);
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      myDropDownList(
                                          items: membersUsers.map((e) => e.email).toList(),
                                          onChanged: (value){
                                            member_email=value;
                                            myCubit.updateState();
                                          },
                                          selectedItem: member_email,
                                          labelText: "Member Email"
                                      ),
                                      SizedBox(height: 10.h,),
                                      Card(
                                        elevation: 0.0,
                                        child: field(
                                            'Start Date',
                                            'Enter Member Start Date',
                                            startDateController,
                                            onTabFunction: (){
                                              // Below line stops keyboard from appearing
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              _selectDate(context,myCubit,startDateController);
                                            }
                                        ),
                                      ),
                                      Card(
                                        elevation: 0.0,
                                        child: field(
                                            'End Date',
                                            'Enter Member End Date',
                                            endDateController,
                                            onTabFunction: (){
                                              // Below line stops keyboard from appearing
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              _selectDate(context,myCubit,endDateController);
                                            }
                                        ),
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
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              onPressed: () {
                                                FocusScope.of(context).requestFocus(new FocusNode());
                                                if(formKey.currentState.validate()){
                                                  bool memberValid=false;
                                                  Member member;
                                                  for(int i=0;i<membersUsers.length;i++){
                                                    if(membersUsers[i].email==member_email && ((role=="Nutritionist" && membersUsers[i].nutritionist==null)||((role=="Coach" && membersUsers[i].coach==null)))){
                                                      member=membersUsers[i];
                                                      memberValid=true;
                                                      break;
                                                    }
                                                  }
                                                  if(role=="Nutritionist"&&memberValid){
                                                    NutritionistWebservice.assignMember(
                                                        nutritionist: user,
                                                        member: member,
                                                        startDate: startDateController.text,
                                                        endDate: endDateController.text,
                                                        context: context,
                                                        createCubit: myCubit,
                                                        adminCubit: adminCubit
                                                    );
                                                  }
                                                  else if(role=="Coach" &&memberValid){
                                                    CoachWebService.assignMember(
                                                        coach: user,
                                                        member: member,
                                                        startDate: startDateController.text,
                                                        endDate: endDateController.text,
                                                        context: context,
                                                        createCubit: myCubit,
                                                        adminCubit: adminCubit
                                                    );
                                                  }
                                                  else{
                                                    myToast(message: "Member not Found or Member has ${role} already",color: Colors.red);
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
                }
            ),
            body: ConditionalBuilder(
              condition: role=="Coach"?coachesUsers[user.index].allMembers.isNotEmpty:nutritionistsUsers[user.index].allMembers.isNotEmpty,
              builder: (context)=>Container(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 20.h, bottom: 5.h),
                  child: ListView.separated(
                    itemCount: role=="Coach"?coachesUsers[user.index].allMembers.length:nutritionistsUsers[user.index].allMembers.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical: 4.h),
                        child: InkWell(
                          child: CustomListTileWithoutCounter(
                            'assets/images/user_icon.png',
                            role=="Coach"?coachesUsers[user.index].allMembers[index].name:nutritionistsUsers[user.index].allMembers[index].name,
                            role=="Coach"?coachesUsers[user.index].allMembers[index].number:nutritionistsUsers[user.index].allMembers[index].number,
                            role=="Coach"?coachesUsers[user.index].allMembers[index].role:nutritionistsUsers[user.index].allMembers[index].role,
                            role=="Coach"?coachesUsers[user.index].allMembers[index].email:nutritionistsUsers[user.index].allMembers[index].email,
                          ),
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index)=>SizedBox(height: 6.h,),
                  )
              ),
              fallback: (context)=>Center(
                child: Text(
                  "No Users Found !!",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          );
        },
    );
  }


}