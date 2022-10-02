import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_project/common/my_list_tile_without_counter.dart';
import 'package:gym_project/constants.dart';
import '../../../bloc/Admin_cubit/admin_cubit.dart';
import '../../../bloc/Admin_cubit/admin_states.dart';
import 'branch_details.dart';
import 'create_branch.dart';

class ShowBranchesList extends StatelessWidget {
  final bar;
  final adminCubit;
  ShowBranchesList({this.bar=true,@required this.adminCubit});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:bar?AppBar(
        title: Text(
          'Branches',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff181818),
        iconTheme: IconThemeData(color: Color(0xFFFFCE2B)),
      ):PreferredSize(child: Container(), preferredSize: Size(0, 0)),
      body: SafeArea(
        child: ConditionalBuilder(
          condition: adminCubit.branchesList.isNotEmpty,
          builder: (context)=>Container(
            color: Colors.black,
            padding: EdgeInsetsDirectional.all(10),
            child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: adminCubit.branchesList.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () async {
                      Navigator.pushNamed(
                        context,
                        '/branch-details',
                        arguments: ScreenArguments(
                          adminCubit.branchesList[index],
                        ),
                      );
                    },
                    child: CustomListTileWithoutCounter(
                        'assets/images/branch.png',
                        adminCubit.branchesList[index].title,
                        '',
                        adminCubit.branchesList[index].number,
                        ''),
                  );
                }),
          ),
          fallback: (context)=>Center(
            child: Container(
              child: Text(
                "No Branches Found",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
