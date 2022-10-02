import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/widget/global.dart';
import '../../all_data.dart';
import '../../bloc/Admin_cubit/admin_states.dart';
import 'questions-list-tile.dart';

class AllQuestions extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          AdminCubit adminCubit=AdminCubit.get(context);
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 8.w),
            child: Column(
              children: [
                Expanded(
                  child: ConditionalBuilder(
                    condition: questionsList.isNotEmpty,
                    builder: (context)=>ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount:questionsList.length,
                      itemBuilder: (context, index) {
                        print(questionsList.length);
                        return QuestionsListTile(
                            role: questionsList[index].user.user_id == Global.id
                                ? 'question_owner'
                                : Global.role,
                            num_of_answers: questionsList[index].allAnswers.length,
                            index:questionsList[index].index,
                            adminCubit:adminCubit
                        );
                      },

                      padding: const EdgeInsets.all(10),
                    ),
                    fallback: (context)=>ConditionalBuilder(
                      condition: adminCubit.isLoadingQuestions,
                      builder: (context)=>Center(child: CircularProgressIndicator(color: myYellow,),),
                      fallback: (context)=>Center(
                        child: FittedBox(
                          child: Text(
                            "No Questions Found yet ",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },

    );
  }
}
