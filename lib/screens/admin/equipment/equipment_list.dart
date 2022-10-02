import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/screens/admin/equipment/equipment_details.dart';
import '../../../common/my_list_tile_without_counter.dart';
import '../../../models/admin-models/equipments/equipment-model.dart';
import '../../../widget/global.dart';
import 'create_equipment.dart';

class EquipmentList extends StatelessWidget {
  final List<Equipment>allEquipment;
  EquipmentList({this.allEquipment});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit myCubit=AdminCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0.0,
            leading: IconButton(
              icon: new Icon(
                Icons.arrow_back_ios,
                color: Color(0xFFFFCE2B),
                size: 22.0.sp,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: new Text('Equipment List',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0.sp,
                    fontFamily:
                    'assets/fonts/Changa-Bold.ttf',
                    color: Colors.white)),
          ),
          floatingActionButton: Global.role=="admin"?Container(
            child: FloatingActionButton(
              onPressed: () {
                goToAnotherScreenPush(context, EquipmentForm());
              },
              isExtended: false,
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.075,
            width: MediaQuery.of(context).size.width * 0.125,
          ):SizedBox(),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          body: ConditionalBuilder(
            condition: allEquipment.isNotEmpty,
            builder: (context)=>Container(
              color: Colors.black,
              padding: EdgeInsetsDirectional.all(10),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount:allEquipment.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        goToAnotherScreenPush(context, EquipmentDetails(equipment:allEquipment[index],adminCubit: myCubit,));
                      },
                      child: CustomListTileWithoutCounter(
                          allEquipment[index].picture,
                          allEquipment[index].name,
                          '',
                          allEquipment[index].description,
                          ''),
                    );
                  }),
            ),
            fallback: (context)=> Center(
              child: Container(
                child: Text(
                  "No Equipment Found yet",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
