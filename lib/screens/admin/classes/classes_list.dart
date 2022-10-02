import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/common/my_list_tile_without_counter.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/admin/classes/class_details.dart';
import '../../../all_data.dart';
import '../../../bloc/Admin_cubit/admin_cubit.dart';
import '../../../bloc/Admin_cubit/admin_states.dart';
import 'create_class.dart';


class ClassesList extends StatelessWidget {
  final bar;
  ClassesList({this.bar=true});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit myCubit=AdminCubit.get(context);
        return Scaffold(
          appBar:bar?AppBar(
            title: Text(
              'Classes',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xff181818),
            iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
          ):PreferredSize(child: Container(), preferredSize: Size(0, 0)),
          floatingActionButton: Container(
            child: FloatingActionButton(
              onPressed: () {
                goToAnotherScreenPush(context,CreateClassForm(adminCubit: myCubit,));
              },
              isExtended: false,
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.075,
            width: MediaQuery.of(context).size.width * 0.125,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          body: SafeArea(
            child: ConditionalBuilder(
              condition: allClasses.isNotEmpty,
              builder: (context)=>Container(
                color: Colors.black,
                padding: EdgeInsetsDirectional.all(10),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: allClasses.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          goToAnotherScreenPush(context, ClassDetails(classes: allClasses[index]));
                        },
                        child: CustomListTileWithoutCounter(
                            "assets/images/branch.png",
                            allClasses[index].title,
                            "Capacity : ${allClasses[index].capacity.toString()} member",
                            "Price : ${allClasses[index].price}",
                            "Level : ${allClasses[index].level}"),
                      );
                    }),
              ),
              fallback: (context)=>ConditionalBuilder(
                condition: state is FetchClassesLoadingState,
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
                        "No Classes Found",
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
