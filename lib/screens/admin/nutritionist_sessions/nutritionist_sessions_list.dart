import 'package:conditional_builder/conditional_builder.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/models/user/nutritionist_model.dart';
import '../../../all_data.dart';
import '../../../bloc/Admin_cubit/admin_cubit.dart';
import '../../../bloc/Admin_cubit/admin_states.dart';
import '../../../bloc/newCreate/Create_states.dart';
import '../../../bloc/newCreate/create_bloc.dart';
import '../../../constants.dart';
import '../../../models/user/member_model.dart';
import '../../../services/nutritionist/nutritionist_sessions.dart';
import '../../../widget/global.dart';
import '../helping-widgets/create-form-widgets.dart';

class NutritionistSessionsList extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit myCubit=AdminCubit.get(context);
        return Scaffold(
          backgroundColor: myBlack,
          appBar: AppBar(
            backgroundColor: myBlack,
            elevation: 8.0,
            leading: backButton(context: context),
            title: Text('Nutritionist Sessions List',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0.sp,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                    color: Colors.white)
            ),
          ),
          floatingActionButton: Global.role == "admin" ? FloatingActionButton(
            heroTag: "bottom1",
            onPressed: () {
              String member_email;
              String nutritionist_email;
              TextEditingController DateController = TextEditingController();
              myAlertDialog(context: context, Body: Center(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding:EdgeInsets.fromLTRB(22.w, 0, 22.w, 0),
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
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20.h),
                                    child: DropdownSearch<String>(
                                        mode: Mode.MENU,
                                        showSelectedItems: true,
                                        items: nutritionistsUsers.map((e) => e.email).toList(),
                                        popupItemDisabled: (String s) => s.startsWith('I'),

                                        onChanged: (String data){
                                          nutritionist_email=data;
                                          createCubit.updateState();
                                        },
                                        validator: (String item) {
                                          if (item == null)
                                            return "Required field";
                                          else
                                            return null;
                                        },
                                        dropdownSearchDecoration: InputDecoration(
                                            labelText: "Nutritionist Email",
                                            hintText: "Enter Member Email",
                                            hintStyle: TextStyle(color: Colors.black),
                                            labelStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                        selectedItem: nutritionist_email??''),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20.h),
                                    child: DropdownSearch<String>(
                                        mode: Mode.MENU,
                                        showSelectedItems: true,
                                        items: membersUsers.map((e) => e.email).toList(),
                                        popupItemDisabled: (String s) => s.startsWith('I'),

                                        onChanged: (String data){
                                          member_email=data;
                                          createCubit.updateState();
                                        },
                                        validator: (String item) {
                                          if (item == null)
                                            return "Required field";
                                          else
                                            return null;
                                        },
                                        dropdownSearchDecoration: InputDecoration(
                                            labelText: "Member Email",
                                            hintText: "Enter Member Email",
                                            hintStyle: TextStyle(color: Colors.black),
                                            labelStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                        selectedItem: member_email??''),
                                  ),
                                  Card(
                                    elevation: 0.0,
                                    child: field(
                                        'Date',
                                        'Enter Session Date',
                                        DateController,
                                        onTabFunction: (){
                                          // Below line stops keyboard from appearing
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          _selectDate(context,createCubit,DateController);
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
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          onPressed: () {
                                            FocusScope.of(context).requestFocus(new FocusNode());
                                            Member member;
                                            for(int i=0;i<membersUsers.length;i++){
                                              if(member_email==membersUsers[i].email){
                                                member=membersUsers[i];
                                              }
                                            }
                                            Nutritionist nutritionist;
                                            for(int i=0;i<nutritionistsUsers.length;i++){
                                              if(nutritionist_email==nutritionistsUsers[i].email){
                                                nutritionist=nutritionistsUsers[i];
                                              }
                                            }
                                            NutritionistSessionsServices.addNutritionistSession(
                                                date: DateController.text,
                                                memberId: member.id,
                                                nutritionistId: nutritionist.id,
                                                context: context,
                                                createCubit: createCubit,
                                                adminCubit: myCubit
                                            );
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
            //isExtended: false,
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 24.sp,
            ),
          ) : Container(),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
            child: ConditionalBuilder(
              condition: nutritionistSessions.isNotEmpty,
              builder: (context)=>ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  separatorBuilder:(context,index)=> SizedBox(height: 10.h,),
                  itemCount: nutritionistSessions.length ?? 0,
                  itemBuilder: (ctx, index) {
                    var nutSes = nutritionistSessions[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: myPurple2,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: ListTile(
                        minVerticalPadding: 15.h,
                        leading: CircleAvatar(
                          radius: 20.r,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.asset('assets/images/branch.png'),
                          ),
                        ),
                        title: Text(
                          'Date: ${nutSes.date}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Nutritionist: ${nutSes.nutritionist.name}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white60,fontSize: 10.sp),
                                  ),
                                  Text(
                                    'Member: ${nutSes.member.name}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white60,fontSize: 10.sp),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Global.role== "admin" ? Row(
                              children: [
                                FloatingActionButton(
                                  heroTag: "ah1$index",
                                  mini: true,
                                  onPressed: () {
                                    String member_email=nutritionistSessions[index].member.email;
                                    TextEditingController DateController;
                                    DateController=TextEditingController(text: nutritionistSessions[index].date);
                                    myAlertDialog(context: context, Body: Center(
                                      child: Form(
                                        key: formKey,
                                        child: Padding(
                                          padding:EdgeInsets.fromLTRB(22.w, 0, 22.w, 0),
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
                                                        field(
                                                          "Nutritionist",
                                                          "",
                                                          TextEditingController(text: nutritionistSessions[index].nutritionist.email),
                                                          enable: false,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(bottom: 20.h),
                                                          child: DropdownSearch<String>(
                                                              mode: Mode.MENU,
                                                              showSelectedItems: true,
                                                              items: membersUsers.map((e) => e.email).toList(),
                                                              popupItemDisabled: (String s) => s.startsWith('I'),

                                                              onChanged: (String data){
                                                                member_email=data;
                                                                createCubit.updateState();
                                                              },
                                                              validator: (String item) {
                                                                if (item == null)
                                                                  return "Required field";
                                                                else
                                                                  return null;
                                                              },
                                                              dropdownSearchDecoration: InputDecoration(
                                                                  labelText: "Member Email",
                                                                  hintText: "Enter Member Email",
                                                                  hintStyle: TextStyle(color: Colors.black),
                                                                  labelStyle: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.bold
                                                                  )
                                                              ),
                                                              selectedItem: member_email??''),
                                                        ),
                                                        Card(
                                                          elevation: 0.0,
                                                          child: field(
                                                              'Date',
                                                              'Enter Session Date',
                                                              DateController,
                                                              onTabFunction: (){
                                                                // Below line stops keyboard from appearing
                                                                FocusScope.of(context).requestFocus(new FocusNode());
                                                                _selectDate(context,createCubit,DateController);
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
                                                                  "Update",
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
                                                                  Member member;
                                                                  for(int i=0;i<membersUsers.length;i++){
                                                                    if(member_email==membersUsers[i].email){
                                                                      member=membersUsers[i];
                                                                    }
                                                                  }

                                                                  NutritionistSessionsServices.editNutritionistSession(
                                                                      date: DateController.text,
                                                                      member_id: member.id,
                                                                      index: index,
                                                                      nutritionist_id: nutritionistSessions[index].nutritionist.id,
                                                                      id: nutritionistSessions[index].id,
                                                                      context: context,
                                                                      createCubit: createCubit,
                                                                      adminCubit: myCubit
                                                                  );
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
                                  child: Icon(Icons.edit,color: Colors.black,),
                                ),
                                SizedBox(width: 4.w,),
                                ConditionalBuilder(
                                  condition: state is DeleteNutritionistSessionsLoadingState && NutritionistSessionsServices.deleteIndex==index,
                                  builder: (context)=>Center(
                                    child: CircularProgressIndicator(color: myYellow),
                                  ),
                                  fallback: (context){
                                    return FloatingActionButton(
                                      heroTag: "ah2$index",
                                      mini: true,
                                      onPressed: () {
                                        NutritionistSessionsServices.deleteNutritionistSession(
                                            id: nutritionistSessions[index].id,
                                            index: index,
                                            adminCubit: myCubit
                                        );
                                      },
                                      child: Icon(Icons.delete,color: Colors.black,),
                                    );
                                  },
                                ),
                              ],
                            )
                                : Container()
                          ],
                        ),
                      ),
                    );
                  }),
              fallback: (context){
                return ConditionalBuilder(
                    condition: myCubit.isLoadingNutritionistSessions,
                    builder: (context)=>Center(child: CircularProgressIndicator(color: myYellow,),),
                  fallback: (context)=>Center(
                    child: Text(
                      "No Nutritionist Sessions Found !!",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
