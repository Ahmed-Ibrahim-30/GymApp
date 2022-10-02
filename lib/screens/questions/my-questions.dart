import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/screens/questions/questions-list-tile.dart';
import 'package:gym_project/widget/global.dart';
import '../../all_data.dart';
import '../../bloc/Admin_cubit/admin_cubit.dart';
import '../../bloc/Admin_cubit/admin_states.dart';
import '../../constants.dart';

class MyQuestions extends StatelessWidget {
  String user_role=Global.role;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit adminCubit=AdminCubit.get(context);
        return Container(
          padding: EdgeInsets.all(10),
          child: ConditionalBuilder(
            condition: questionsList.isNotEmpty,
            builder: (context)=>ListView.builder(
              itemBuilder: (context, index) {
                return questionsList[index].user.user_id == Global.id
                    ? QuestionsListTile(
                  role: 'question_owner',
                  num_of_answers: 3,
                  index: questionsList[index].index,
                  adminCubit: adminCubit,
                  viewAnswersButton: true,
                )
                    : Container();
              },
              itemCount: questionsList.length,
              padding: const EdgeInsets.all(10),
            ),
            fallback: (context)=>ConditionalBuilder(
          condition: adminCubit.isLoadingQuestions,
          builder: (context)=>Center(child: CircularProgressIndicator(color: myYellow,),),
          fallback: (context)=>Text(
            "No Questions Found yet",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold
            ),
          ),
        )
          )
        );
      },
    );
  }
}
