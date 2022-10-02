import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/common/my_list_tile_without_counter.dart';
import 'package:gym_project/constants.dart';
import '../../../all_data.dart';
import '../../../bloc/Admin_cubit/admin_cubit.dart';
import '../../../bloc/Admin_cubit/admin_states.dart';
import 'branch_details.dart';

class BranchesList extends StatelessWidget {
  final bar;
  BranchesList({this.bar=true});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit myCubit=AdminCubit.get(context);
        return Container(
          color: myBlack,
          child: Scaffold(
            appBar:bar?AppBar(
              title: Text(
                'Branches',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: myBlack,
              iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
            ):PreferredSize(child: Container(), preferredSize: Size(0, 0)),
            body: ConditionalBuilder(
              condition: branchesList.isNotEmpty,
              builder: (context)=>Container(
                color: Colors.black,
                padding: EdgeInsetsDirectional.all(10),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: branchesList.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          goToAnotherScreenPush(context, BranchDetails(adminCubit: myCubit,index:branchesList[index].index),
                          );
                        },
                        child: CustomListTileWithoutCounter(
                            "assets/images/as.png",
                            branchesList[index].title,
                            '${branchesList[index].allEquipment.length} Equipments',
                            branchesList[index].number,
                            ''),
                      );
                    }),
              ),
              fallback: (context)=>ConditionalBuilder(
                condition: myCubit.isLoadingBranch,
                builder: (context)=>Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3.r,
                    color: Color(0xFFFFCE2B),
                  ),
                ),
                fallback: (context){
                  return Center(
                    child: Container(
                      child: Text(
                        "No Branches Found",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
