import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/coach_cubit/coach_cubit.dart';
import 'package:gym_project/bloc/newCreate/Create_states.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:gym_project/common/my_list_tile_without_counter.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/admin/classes/class_details.dart';
import '../../bloc/coach_cubit/coach_states.dart';
import '../admin/classes/class_arguments.dart';

class MyClassesList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoachCubit,CoachStates>(
      listener: (context,state){},
      builder: (context,state){
        CoachCubit coachCubit=CoachCubit.get(context);
        return Scaffold(
          backgroundColor: myBlack,
          body: ConditionalBuilder(
            condition: allClasses.isNotEmpty,
            builder: (context)=>Padding(
              padding: EdgeInsets.only(left: 10.w,right: 10.w,top: 25.h),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: allClasses.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        goToAnotherScreenPush(context, ClassDetails(classes:allClasses[index]));
                      },
                      child: CustomListTileWithoutCounter(
                        'assets/images/branch.png',
                        allClasses[index].title,
                        allClasses[index].date,
                        'Capacity: ${allClasses[index].capacity}',
                        'Duration: ${allClasses[index].duration}',
                      ),
                    );
                  }),
            ),
            fallback: (context)=>ConditionalBuilder(
              condition: coachCubit.isLoadingClasses,
              builder: (context)=>Center(child: CircularProgressIndicator(color: myYellow),),
              fallback: (context)=>Center(child: Text("No Classes yet",style: TextStyle(color: Colors.grey),),),
            ),
          )
        );
      },
    );
  }
}
