import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/screens/questions/all-questions.dart';
import 'package:gym_project/screens/questions/my-questions.dart';

import '../../bloc/Admin_cubit/admin_states.dart';
import '../../bloc/newCreate/Create_states.dart';
import '../../bloc/newCreate/create_bloc.dart';
import '../../constants.dart';
import '../../services/questions-webservice.dart';
import '../admin/helping-widgets/create-form-widgets.dart';



class QuestionsScreen extends StatelessWidget {
  List<Widget> tabs = [
    Tab(
      text: 'All',
    ),
    Tab(
      text: 'My Questions',
    ),
  ];


  //Provider.of<AnswerListViewModel>(context, listen: false).getAllAnswers();



  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state)=>{},
      builder: (context,state){
        AdminCubit adminCubit=AdminCubit.get(context);
        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            backgroundColor: myBlack,
            floatingActionButton: Container(
              height: MediaQuery.of(context).size.height * 0.075,
              width: MediaQuery.of(context).size.width * 0.1,
              child: FloatingActionButton(
                onPressed: () {
                  var formKey=GlobalKey<FormState>();
                  TextEditingController titleController=TextEditingController();
                  TextEditingController BodyController=TextEditingController();
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
                                      Card(child: field("Title", "Enter Title", titleController),elevation: 0.0),
                                      Card(child: field("Body", "Enter Body", BodyController),elevation: 0.0),
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
                                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                                  textStyle: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              onPressed: () {
                                                FocusScope.of(context).requestFocus(new FocusNode());
                                                if(formKey.currentState.validate()){
                                                  QuestionsWebservice.postQuestion(
                                                      title: titleController.text,
                                                      body: BodyController.text,
                                                      adminCubit: adminCubit,
                                                    createCubit:createCubit,
                                                    context:context
                                                  );

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
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    title: Text(
                      'Questions',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: myBlack,
                    iconTheme: IconThemeData(color: myYellow),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 4.h),
                    color: myBlack,
                    child: new TabBar(
                      unselectedLabelColor: Colors.amber,
                      tabs: tabs,
                      indicator: BubbleTabIndicator(
                        indicatorRadius: 20.r,
                        indicatorColor: Color(0xFFFFCE2B),
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        indicatorHeight: 15.h,
                        padding: EdgeInsets.all(20),
                        insets: EdgeInsets.all(22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: Center(
                child: Container(
                  width: isWideScreen ? 900 : double.infinity,
                  child: TabBarView(
                    children: [
                      AllQuestions(),
                      MyQuestions(),
                    ],
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
