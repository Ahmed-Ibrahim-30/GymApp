import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import 'package:gym_project/screens/questions/single-question.dart';
import '../../bloc/newCreate/Create_states.dart';
import '../../bloc/newCreate/create_bloc.dart';
import '../../constants.dart';
import '../../services/questions-webservice.dart';
import '../../widget/delete-iconbutton.dart';
import '../../widget/edit-iconbutton.dart';
import '../admin/helping-widgets/create-form-widgets.dart';



class QuestionsListTile extends StatelessWidget {
  final int num_of_answers;
  final String role;
  final int index;
  final AdminCubit adminCubit;
  final bool viewAnswersButton;

  QuestionsListTile({
    this.num_of_answers,
    this.role,
    this.index,
    this.adminCubit,
    this.viewAnswersButton = true,
  });
  bool is_visible=true;




  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit adminCubit=AdminCubit.get(context);
        //CreateCubit createCubit=CreateCubit.get(context);
        return Visibility(
          visible: is_visible,
          child: Container(
            margin: EdgeInsetsDirectional.only(bottom: 10.h),
            decoration: BoxDecoration(
              color: myGreen,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: ListTile(
              isThreeLine: true,
              onTap: () => goToAnotherScreenPush(context, SingleQuestionScreen(questionIndex:index,role:role)),
              minVerticalPadding: 10,
              title: Padding(
                padding:  EdgeInsets.only(right: 0.0, top: 8.0.h, bottom: 8.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      child: Icon(Icons.account_circle),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.025,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Text(
                              questionsList[index].user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                fontWeight: FontWeight.bold,
                                fontSize: 30.sp,
                              ),
                            ),
                          ),
                          Container(
                            child: FittedBox(
                              child: Text(
                                questionsList[index].date,
                                style: TextStyle(
                                  color: myYellow,
                                  fontSize: 11.sp,
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (role == "question_owner" ||role == "admin")
                        ? Container(
                      padding: EdgeInsets.only(right: 4.w),
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocProvider(
                            create:(context)=>CreateCubit(),
                            child: BlocConsumer<CreateCubit,CreateStates>(
                              listener: (context,state){},
                              builder: (context,state){
                                CreateCubit createCubit=CreateCubit.get(context);
                                return DeleteIconButton(
                                  context: context,
                                  text: 'Would you like to delete this question ?',
                                  onDelete: () {
                                    QuestionsWebservice.deleteQuestion(
                                        id: questionsList[index].id,
                                        index: index,
                                        adminCubit: adminCubit,
                                        createCubit: createCubit,
                                        context:context
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04,
                          ),
                          EditIconButton(
                              onPressed: () {
                                var formKey=GlobalKey<FormState>();
                                TextEditingController titleController=TextEditingController();
                                titleController.text=questionsList[index].title;
                                TextEditingController BodyController=TextEditingController();
                                BodyController.text=questionsList[index].body;
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
                                                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                                                textStyle: TextStyle(
                                                                  fontSize: 15.sp,
                                                                  fontWeight: FontWeight.bold,
                                                                )),
                                                            onPressed: () {
                                                              FocusScope.of(context).requestFocus(new FocusNode());
                                                              if(formKey.currentState.validate()){
                                                                QuestionsWebservice.editQuestion(
                                                                  id: questionsList[index].id,
                                                                    index: questionsList[index].index,
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
                              }
                          ),
                        ],
                      ),
                    )
                        : Container(),
                  ],
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                      text: TextSpan(
                        text: "Question :-  ",
                        style: TextStyle(color: Colors.blue, fontSize: 20,fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: "${questionsList[index].body}", style: TextStyle(fontFamily: 'assets/fonts/Changa-Bold.ttf',color: Colors.grey,fontSize: 15.sp)),
                        ]
                      )
                  ),

                  if (viewAnswersButton)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4, right: 8),
                          child: TextButton(
                            onPressed: () => goToAnotherScreenPush(context,SingleQuestionScreen(questionIndex:index,role:role)),
                            child: FittedBox(
                              child: Text(
                                //questionsList[index].num_of_answers.toString() +
                                " Answers",
                                style: TextStyle(
                                  color: Color(0xFFFFCE2B),
                                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
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
